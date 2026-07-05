-- Auth slice migration: profiles table + RLS + national-ID login resolution.
-- See plan/auth_slice_technical_plan.md for the full design rationale.

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  national_id text unique,
  phone text,
  full_name text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

-- Deny-by-default: only explicit policies below grant access.
create policy "profiles_select_own"
  on public.profiles for select
  using (auth.uid() = id);

create policy "profiles_update_own"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

create policy "profiles_insert_own"
  on public.profiles for insert
  with check (auth.uid() = id);

-- No delete policy: profiles are never deleted by the client directly
-- (account deletion is a separate, audited admin flow — out of scope here).

-- Auto-create a profile row whenever a new auth user is created, so every
-- signup path (phone, national ID, Sanad) ends up with a profiles row.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, phone)
  values (new.id, new.phone);
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Used by the resolve-login-identifier Edge Function to look up which auth
-- identity a national ID belongs to, without granting the client direct
-- table access. SECURITY DEFINER intentionally bypasses RLS — it returns
-- only the email, never the full profile row, and must only ever be called
-- from the Edge Function (never granted to the `anon`/`authenticated` role
-- directly — see the REVOKE below).
create or replace function public.resolve_identifier_by_national_id(p_national_id text)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_email text;
begin
  select u.email into v_email
  from public.profiles p
  join auth.users u on u.id = p.id
  where p.national_id = p_national_id;

  return v_email; -- null if not found; caller (Edge Function) maps to 404
end;
$$;

revoke execute on function public.resolve_identifier_by_national_id(text) from public, anon, authenticated;
-- Only the service_role (used by the Edge Function) may call this.
grant execute on function public.resolve_identifier_by_national_id(text) to service_role;

-- Rate-limit tracking for the resolve-login-identifier Edge Function.
-- Written only by service_role (the Edge Function's client); no client
-- access needed or granted.
create table if not exists public.login_identifier_attempts (
  id bigint generated always as identity primary key,
  ip text not null,
  created_at timestamptz not null default now()
);

alter table public.login_identifier_attempts enable row level security;
-- No policies: RLS enabled with zero policies means even service_role's
-- policy-based access is denied, but service_role bypasses RLS entirely
-- by design in Postgres/Supabase, so this table is fully denied to anon/
-- authenticated while still writable by the Edge Function.

create index if not exists login_identifier_attempts_ip_created_idx
  on public.login_identifier_attempts (ip, created_at);
