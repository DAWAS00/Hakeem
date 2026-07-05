# Supabase migration conventions

Established by the `auth` slice (`0001_profiles_and_auth.sql`, `0002_profiles_signup_fields.sql`,
`0003_login_attempts_retention.sql`). Every new feature's migration should follow these
rather than re-deriving them — this is especially load-bearing for `family_hub`'s
`family_links` table, since every other clinical feature's RLS design depends on it.

## RLS

- Every table gets `alter table ... enable row level security;` in the **same migration**
  that creates it. A table merged with RLS disabled "temporarily" is not acceptable
  (see `AGENTS.md` §4).
- Deny-by-default: write only the explicit policies a table actually needs. Don't add
  a blanket "authenticated can do anything" policy.
- Prefer `using (auth.uid() = <owner_column>)` for owner-only access — `auth.uid()` is
  indexed implicitly via the primary key/foreign key it's compared against.
- A table that should be reachable only by `service_role` (e.g. rate-limit counters)
  should still call `enable row level security` with **zero policies** — RLS-enabled
  with no policies denies `anon`/`authenticated` entirely while `service_role` still
  bypasses RLS by design. Don't skip enabling RLS just because "no client should ever
  touch this" — enabling it is what enforces that.

## SECURITY DEFINER functions

- Use only when the client legitimately needs a narrow, elevated-privilege lookup that
  would otherwise require bypassing RLS (e.g. `resolve_identifier_by_national_id`).
- Always pair with `set search_path = public` (prevents search-path hijacking) and an
  explicit `revoke execute ... from public, anon, authenticated` + `grant execute ...
  to service_role` — the function must never be directly callable by a client role, only
  reachable through an Edge Function using the service-role key.
- Return only the minimum data needed (e.g. an email, not the full row).

## Rate-limiting / attempt-tracking tables

- Insert-only tables used for rate limiting (e.g. `login_identifier_attempts`) need a
  `pg_cron` pruning job in the same migration set (see `0003_login_attempts_retention.sql`)
  — they grow unboundedly otherwise. Don't add one without the other.
- Index on `(key_column, created_at)` where `key_column` is whatever you rate-limit by
  (IP, user id, etc.) — the rate-limit check is always a range query on `created_at`
  filtered by that key.

## Error mapping (Dart side)

- Postgrest error codes are SQLSTATE strings (e.g. `'23505'`), not HTTP status codes —
  never `int.tryParse` them. Use `ServerFailure.postgresCode` (String?), not `statusCode`
  (reserved for real HTTP status codes from Edge Function responses).
- Every new repository should wrap datasource calls with `RepositoryGuard`
  (`lib/core/data/repository_guard.dart`) rather than hand-rolling try/catch — it already
  maps `AuthException`/`PostgrestException`/`FunctionException`/unknown errors to
  `Failure` and logs via Talker.

## Migration numbering

- Sequential, zero-padded, one migration file per logical change:
  `NNNN_short_description.sql`. Don't bundle unrelated schema changes into one file.
