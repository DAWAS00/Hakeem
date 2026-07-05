-- login_identifier_attempts (0001_profiles_and_auth.sql) is insert-only and
-- has no pruning — it would grow unboundedly. Schedule a daily pg_cron job
-- to delete rows older than the rate-limit window needs (kept slightly
-- longer than the 15-minute window used by resolve-login-identifier for
-- safety margin/debugging).

create extension if not exists pg_cron;

select cron.schedule(
  'prune_login_identifier_attempts',
  '0 3 * * *', -- daily at 03:00 UTC
  $$
    delete from public.login_identifier_attempts
    where created_at < now() - interval '1 day';
  $$
);
