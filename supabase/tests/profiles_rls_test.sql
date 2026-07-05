-- pgTAP RLS test for public.profiles. Run via `supabase test db`.
begin;
select plan(4);

-- Two fake auth users.
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'user-a@test.local'),
  ('22222222-2222-2222-2222-222222222222', 'user-b@test.local');

insert into public.profiles (id, national_id, phone, full_name) values
  ('11111111-1111-1111-1111-111111111111', 'A-NID-1', '+962700000001', 'User A'),
  ('22222222-2222-2222-2222-222222222222', 'B-NID-1', '+962700000002', 'User B');

-- Act as user A.
set local role authenticated;
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

select is(
  (select count(*)::int from public.profiles where id = '11111111-1111-1111-1111-111111111111'),
  1,
  'user A can read their own profile'
);

select is(
  (select count(*)::int from public.profiles where id = '22222222-2222-2222-2222-222222222222'),
  0,
  'user A cannot read user B''s profile (RLS silently filters, no error)'
);

update public.profiles set full_name = 'User A Updated' where id = '11111111-1111-1111-1111-111111111111';
select is(
  (select full_name from public.profiles where id = '11111111-1111-1111-1111-111111111111'),
  'User A Updated',
  'user A can update their own profile'
);

update public.profiles set full_name = 'Hacked' where id = '22222222-2222-2222-2222-222222222222';
select is(
  (select full_name from public.profiles where id = '22222222-2222-2222-2222-222222222222'),
  'User B',
  'user A cannot update user B''s profile'
);

select * from finish();
rollback;
