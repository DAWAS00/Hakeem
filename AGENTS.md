# AGENTS.md — Rules for AI Agents Working on Hakeem

This file governs how any AI agent (Claude Code or otherwise) builds features in this repository. It supplements `CLAUDE.md` — `CLAUDE.md` describes what the codebase looks like today; this file describes the *process* an agent must follow when changing it, specifically for the Supabase/fpdart/Riverpod-Generator/Talker migration and every feature built after it.

If any rule here conflicts with a direct user instruction in the moment, the user instruction wins for that task — but flag the conflict, don't silently deviate.

---

## 1. Before touching any code

1. Read `CLAUDE.md` (architecture, conventions, commands).
2. Read `plan/architecture_redesign_plan.md` (the overall migration decisions and sequencing).
3. If the feature has a slice plan (`plan/<feature>_slice_technical_plan.md`), read it. `plan/auth_slice_technical_plan.md` is the reference template — its structure (diagrams, file manifest, function table, testing matrix) is mandatory shape for every other feature's slice plan.
4. Check `plan/architecture_redesign_plan.md` §5F for migration order. **Do not migrate a feature out of order** — `auth` first, `family_hub` second (its `family_links` table gates RLS everywhere else), the rest after.

## 2. One vertical slice per task, never a big-bang rewrite

- One feature migrates per PR/task: datasource → repository → use case → notifier → RLS → tests, all for that one feature, together.
- Never touch two features' data layers in the same change unless the user explicitly asks for a cross-cutting change (e.g. adding a new core provider both depend on).
- If a shared `core/` utility doesn't exist yet (`Failure`, `FailureMapper`, `FailureLocalizer`, `talker_provider`), create it once, on the first feature that needs it — do not duplicate per-feature.

## 3. Required order of work per feature slice

1. Write/extend the slice plan doc (`plan/<feature>_slice_technical_plan.md`) — diagrams, file manifest, function table, testing matrix — **before** writing implementation code. If the plan reveals an open question (e.g. an RLS relationship that isn't decided), stop and ask the user; don't guess on data-access rules for a healthcare app.
2. Domain layer: update repository interface return types to `Future<Either<Failure, T>>`, update use cases.
3. Data layer: datasource swaps to `supabase_flutter` calls (or Edge Function calls where secrets/cross-user reads are needed — see architecture plan §5D); repository impl wraps in try/catch → `Either`, logs failures via `Talker`.
4. Presentation layer: convert the notifier to `@riverpod`, replace any ad-hoc error-string switch with `FailureLocalizer`.
5. Supabase: write the migration SQL with RLS enabled by default (deny-by-default, explicit policies), commit it under `supabase/migrations/`. Never hand-edit schema via the dashboard.
6. Tests: unit tests for mapper/usecase/repository/notifier, pgTAP test for every new RLS policy, integration test for any new Edge Function. See the testing matrix categories in `auth_slice_technical_plan.md` §5 — every feature slice needs the same categories filled in.
7. Run the full local gate (§5 below). Do not mark work done until it's green.
8. Delete the old Dio/`api.hakeem.jo` code path for that feature — no long-lived dual-backend code per feature.
9. Write the completion doc (§6 below).

## 4. Conventions specific to this migration

- **Failures, not exceptions, cross layer boundaries.** Anything a repository or use case returns to a notifier is `Either<Failure, T>`. Exceptions are only caught and converted, never left to propagate into presentation.
- **One `FailureMapper`, one `FailureLocalizer`.** Don't write a per-feature error-string switch — extend the shared ones in `lib/core/error_handling/`.
- **RLS is not optional and not an afterthought.** Every new table ships with RLS enabled and explicit policies in the same migration file that creates it. A table with RLS disabled "temporarily" does not get merged.
- **Edge Functions for secrets and cross-user reads only.** If a client-side RLS-scoped query can do it, do it client-side. Reach for an Edge Function only when a secret is involved (LLM API keys) or the read legitimately needs to cross RLS boundaries (national-ID login resolution, genetic-risk aggregation across family members).
- **Talker in every failure path**, not just logged prints. `avoid_print` is already enforced by the linter — this migration is what replaces the remaining ad-hoc error handling with structured logging.
- **Riverpod Generator (`@riverpod`) for all new/migrated providers.** Manual `Provider(...)`/`NotifierProvider(...)` definitions are only acceptable in not-yet-migrated features; don't write new manual ones.

## 5. Verification gate (must pass before a slice is considered done)

```bash
flutter analyze --fatal-warnings
flutter test
dart run build_runner build --delete-conflicting-outputs
```
Plus, for the feature's RLS policies: `supabase test db` (pgTAP) green. Plus a manual two-account test that RLS actually denies cross-user access — a passing unit test suite is not sufficient proof for access-control on a healthcare app.

Do not report a slice as complete if any of these fail. Do not skip the manual RLS check because the automated tests passed — automated RLS tests catch regressions, they don't substitute for a human confirming the policy does what's intended the first time.

## 6. Mandatory completion documentation

When a feature slice is finished (gate passed), the agent writes `docs/features/<feature>.md` containing:

- What changed (one paragraph, plain language).
- The function table from the slice plan, updated to reflect what was *actually* built (not just what was planned — note any deviations and why).
- Schema/RLS added, with the actual final SQL.
- What was tested and how (link to test files, not just a description).
- **Follow-ups**: append 2+ concrete improvement items to `plan/backlog.md` (create it if it doesn't exist) — things noticed but out of scope for this slice (e.g. "national-ID lookup Edge Function has no audit log yet — add one before this ships to production"). This is not optional busywork; it's how gaps don't get silently forgotten between features.

`docs/features/<feature>.md` is the source of truth for "how this feature actually works" going forward — the next agent touching this feature reads it before touching code, per §1.

## 7. When in doubt

Ask the user rather than guessing on: RLS relationship design, whether a field is patient-identifying data requiring extra protection, and any decision that's expensive to reverse once real user data exists. Cheap-to-reverse implementation details (naming, file placement matching the existing pattern) don't need to be asked — just match what `auth_slice_technical_plan.md` already established.
