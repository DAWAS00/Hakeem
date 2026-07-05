-- Signup slice migration: adds the multi-step signup form's fields
-- (identity/contact/health/consent) to public.profiles.
-- See plan/auth_slice_technical_plan.md and docs/features/auth.md for
-- context — profiles.national_id/phone/full_name already exist from
-- 0001_profiles_and_auth.sql; this adds everything else the signup form
-- collects, written after phone-OTP verification (see
-- lib/features/auth/data/datasources/signup_remote_datasource.dart).

alter table public.profiles
  add column if not exists gender text,
  add column if not exists date_of_birth date,
  add column if not exists governorate text,
  add column if not exists city text,
  add column if not exists blood_type text,
  add column if not exists chronic_diseases text[] not null default '{}',
  add column if not exists allergies text,
  add column if not exists height_cm smallint,
  add column if not exists weight_kg smallint,
  add column if not exists current_medications text,
  add column if not exists accept_terms boolean not null default false,
  add column if not exists enable_notifications boolean not null default true;

-- RLS policies from 0001 (profiles_select_own/update_own/insert_own) already
-- cover these new columns — RLS in Postgres is row-level, not column-level,
-- so no new policies are needed here.
