# Auth Feature — Completion Doc (Login + Signup Slices)

Status: **login and signup both migrated to Supabase.** Signup uses phone-OTP verification (no password) — see the OTP/login gap noted below. RLS/e2e verification against a live Supabase project is **not yet done** — see Verification Gap below before this ships.

## What changed

Login (`loginWithPhone`, `loginWithNationalId`) moved off `api.hakeem.jo`/Dio onto `supabase_flutter`. The domain layer returns `Either<Failure, UserEntity>` instead of throwing, `LoginNotifier` is a Riverpod-Generator `@riverpod` class instead of a manual `Notifier`, and errors are localized through a shared `FailureLocalizer` instead of a per-notifier switch. National-ID login resolves to an email via a `resolve-login-identifier` Edge Function before signing in, since Supabase Auth has no native national-ID login.

Signup (`SendSignupOtpUseCase`, `VerifySignupOtpUseCase`, `signup_remote_datasource.dart`) also moved off Dio/`api.hakeem.jo` onto Supabase in this pass, alongside a set of cross-cutting fixes found while reviewing the login slice as the "reference pattern" for the rest of the app:

- Extracted the login slice's private `_guard` try/catch→`Either`+Talker pattern into a shared `RepositoryGuard` (`lib/core/data/repository_guard.dart`), so `AuthRepositoryImpl` and the new `SignupRepositoryImpl` both use the same class instead of duplicating it. Every future feature's repository should use `RepositoryGuard` too.
- Wired Talker globally in `main.dart` (`FlutterError.onError`, `PlatformDispatcher.instance.onError`, `runZonedGuarded`, `TalkerRiverpodObserver`) — previously Talker only ever saw errors from inside the login repository's own try/catch; nothing else in the app was observed.
- Added `lib/core/data/json_field_x.dart` (typed JSON accessors that throw `FormatException` instead of a bare `TypeError`) and applied it to `family_hub`'s `emergency_card.dart`, which had unchecked `as` casts against mock data — pre-empting the same risk before `family_hub` gets a real Supabase datasource.
- Removed `dio`/`dio_provider.dart`/`flutter_secure_storage` entirely — after signup migrated, nothing in the app used Dio anymore (every other unmigrated feature is mock-backed, not Dio-backed), and `flutter_secure_storage` had zero usages anywhere.
- Added `.github/workflows/ci.yml` (analyze/format/test gate) — previously only Gemini review automation existed, no build/test CI at all.
- Fixed `FailureMapper.mapPostgrestException`: Postgrest error codes are SQLSTATE strings (e.g. `'23505'`), not HTTP status codes — `int.tryParse` was silently dropping them. `ServerFailure` now has a separate `postgresCode` (String?) alongside `statusCode` (int?, reserved for real HTTP codes from Edge Functions).
- Added `supabase/CONVENTIONS.md` documenting the RLS/SECURITY DEFINER/rate-limit-table patterns established here, so `family_hub` (next in the migration queue) doesn't have to re-derive them.

### Signup design decision: phone OTP, no password (known gap)

`SignupFormData` never collected a password, and `signup_screen.dart` was completely disconnected from its own notifier (`_finish()` was a bare `// TODO`). Rather than guess on the auth design, this was raised to the user directly. Decision: **signup uses `supabase.auth.signInWithOtp`/`verifyOTP` (phone OTP) with no password set, ever** — and this ships knowing that **new users created via signup cannot log in through the existing password-only login screen** (`loginWithPhone` calls `signInWithPassword`, which requires a password that OTP-only signup never sets). This is intentional per the user's explicit choice, not an oversight — an OTP-based login path is a required follow-up before this is usable end-to-end. See `plan/backlog.md`.

## Function table (as actually built)

| Function | File | Notes vs. plan |
|---|---|---|
| `LoginUseCase.call` | `domain/usecases/login_usecase.dart` | Matches plan exactly. |
| `AuthRepositoryImpl.loginWithPhone`/`loginWithNationalId` | `data/repositories/auth_repository_impl.dart` | Now delegates to the shared `RepositoryGuard` (`lib/core/data/repository_guard.dart`) instead of a private `_guard` method — same behavior, now reusable. |
| `AuthRemoteDatasourceImpl.loginWithPhone`/`loginWithNationalId` | `data/datasources/auth_remote_datasource.dart` | Matches plan; `_toUserModel` helper shares the session/profile-join logic between both login paths. |
| `FailureMapper.mapAuthException`/`mapPostgrestException`/`mapEdgeFunctionException`/`mapUnknown` | `core/error_handling/failure_mapper.dart` | Added `mapEdgeFunctionException` 404 → `AuthFailureCode.identifierNotFound`, mapped to the *same* Arabic message as invalid credentials (deliberate — avoids leaking whether a national ID exists). Added `otp_expired`/`otp_disabled` → `AuthFailureCode.otpInvalid` for signup. `mapPostgrestException` now stores the raw SQLSTATE in `ServerFailure.postgresCode` instead of a lossy `int.tryParse`. |
| `FailureLocalizer.localize` | `core/error_handling/failure_localizer.dart` | Matches plan; added `AuthFailureCode.otpInvalid` message. |
| `LoginNotifier.login`/`loginWithBiometric`/`switchTab`/`togglePassword` | `presentation/providers/login_notifier.dart` | Unchanged from the login slice. `_checkBiometricSupport`'s catch now logs via Talker and checks `ref.mounted` before touching `ref`/`state` post-async-gap (previously a bare silent `catch (_) {}`). |
| `SendSignupOtpUseCase.call` / `VerifySignupOtpUseCase.call` | `domain/usecases/send_signup_otp_usecase.dart` / `verify_signup_otp_usecase.dart` | Replaces the old single `RegisterUseCase` — one usecase per action, per the two-step OTP flow. |
| `SignupRepositoryImpl.sendOtp`/`verifyOtp` | `data/repositories/signup_repository_impl.dart` | Uses `RepositoryGuard`, same pattern as `AuthRepositoryImpl`. |
| `SignupRemoteDatasourceImpl.sendOtp`/`verifyOtp` | `data/datasources/signup_remote_datasource.dart` | `sendOtp` → `supabase.auth.signInWithOtp(phone:)`. `verifyOtp` → `supabase.auth.verifyOTP(type: OtpType.sms, ...)`, then updates the `profiles` row (already created by `handle_new_user`) with the rest of the form's data via `SignupProfileUpdate`, then best-effort links an email via `updateUser` if provided (for future national-ID login). |
| `SignupNotifier.sendOtp`/`verifyOtp` | `presentation/providers/signup_notifier.dart` | New `@riverpod` class (generated provider name: `signupProvider`, per the same Riverpod Generator suffix-stripping as `loginProvider`). `sendOtp` advances `SignupState` to `SignupStep.otp` on success. |
| `SignupScreen._finish`/`_verifyOtp`/`_resendOtp` | `presentation/screens/signup_screen.dart` | Converted to `ConsumerStatefulWidget`, wired to `signupProvider`; added a 5th step (`Step5Otp`, `widgets/signup/steps/step_5_otp.dart`) using `pinput` for the code entry UI. |
| `resolve-login-identifier` Edge Function | `supabase/functions/resolve-login-identifier/index.ts` | Unchanged behavior; fixed a doc comment that overstated it as per-`(IP, national_id)` rate-limiting when it's actually per-IP only. |

## Schema / RLS (final SQL)

- `supabase/migrations/0001_profiles_and_auth.sql`: `profiles` table (owner-only select/insert/update via RLS), `handle_new_user` trigger auto-creating a profile row on signup, `resolve_identifier_by_national_id` SECURITY DEFINER function (execute revoked from `anon`/`authenticated`, granted only to `service_role`), and `login_identifier_attempts` for rate-limiting.
- `supabase/migrations/0002_profiles_signup_fields.sql`: adds `gender`, `date_of_birth`, `governorate`, `city`, `blood_type`, `chronic_diseases text[]`, `allergies`, `height_cm`, `weight_kg`, `current_medications`, `accept_terms`, `enable_notifications` to `profiles` — no new RLS policies needed (RLS is row-level, existing owner-only policies already cover the new columns).
- `supabase/migrations/0003_login_attempts_retention.sql`: `pg_cron` daily job pruning `login_identifier_attempts` rows older than 1 day — the table was insert-only with no retention before this.

## What was tested and how

- `test/core/data/repository_guard_test.dart` — the extracted guard's mapping for `AuthException`/`PostgrestException`/unknown errors.
- `test/core/data/json_field_x_test.dart` — `requireString`/`optionalString`/`requireList` success and `FormatException` paths.
- `test/core/error_handling/failure_mapper_test.dart` — updated for `postgresCode` (was `statusCode` from a lossy `int.tryParse`).
- `test/features/auth/data/repositories/auth_repository_impl_test.dart` — updated for the `RepositoryGuard` constructor; same coverage as before.
- `test/features/auth/data/repositories/signup_repository_impl_test.dart` — `sendOtp`/`verifyOtp` success and exception-to-`Left` paths (new).
- `test/features/auth/domain/usecases/send_signup_otp_usecase_test.dart` / `verify_signup_otp_usecase_test.dart` — dispatch and `Either` passthrough (new; replaces the untested old `register_usecase.dart`).
- `test/features/auth/presentation/providers/login_notifier_test.dart` — unchanged coverage; fixed a `ref`-after-dispose crash in `_checkBiometricSupport` surfaced by this pass's Talker-logging change.
- `test/features/auth/presentation/providers/signup_notifier_test.dart` — `sendOtp`/`verifyOtp` success/failure state transitions via `ProviderContainer` with `signupRepositoryProvider` overridden (new).
- `supabase/tests/profiles_rls_test.sql` (pgTAP) — written but **still not executed**, no Supabase CLI/local stack available in this environment.
- All 62 tests pass; `flutter analyze --fatal-warnings` clean; `dart run build_runner build --delete-conflicting-outputs` succeeds.

## Verification gap (must close before production)

1. **pgTAP test never run.** `supabase/tests/profiles_rls_test.sql` exists but hasn't executed against a real Postgres instance — run `supabase test db` before trusting the RLS policies. Still applies to the new `0002`/`0003` migrations too (no RLS changes, but the `pg_cron` job in `0003` has never run against a real instance either).
2. **No live end-to-end login or signup tested.** Everything above is unit/provider-level with fakes; nobody has signed up or logged in against a real Supabase project yet. Needs `supabase start` (or a dev project) + `env.json` populated from `env.example.json`.
3. **Manual two-account RLS check not performed** — AGENTS.md requires this specifically because passing automated tests isn't sufficient proof for access control on a healthcare app.
4. **New users from signup cannot use the existing login screen** (see the OTP/login gap above) — this needs an OTP-based login path before signup is genuinely end-to-end usable, not just a known cosmetic gap.

## Follow-ups (backlog)

See `plan/backlog.md`.
