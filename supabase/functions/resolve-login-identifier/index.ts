// Resolves a national ID to its auth email, so the client can call
// `signInWithPassword(email: ..., password: ...)` for national-ID login.
//
// Runs with the service_role key so it can call the SECURITY DEFINER
// `resolve_identifier_by_national_id` RPC (see
// supabase/migrations/0001_profiles_and_auth.sql). The client never gets
// direct table/RPC access to this lookup — only this function does.
//
// Rate-limited per IP (not per national_id — a single IP is capped globally
// across all national IDs it tries, which is stricter and simpler than
// per-identifier limiting) via the `login_identifier_attempts` table, to
// blunt national-ID enumeration attacks.

import { createClient } from 'jsr:@supabase/supabase-js@2';

const RATE_LIMIT_WINDOW_MINUTES = 15;
const RATE_LIMIT_MAX_ATTEMPTS = 5;

Deno.serve(async (req: Request) => {
  if (req.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 });
  }

  let nationalId: string | undefined;
  try {
    const body = await req.json();
    nationalId = body?.national_id;
  } catch {
    return new Response(JSON.stringify({ error: 'invalid_body' }), { status: 400 });
  }

  if (typeof nationalId !== 'string' || nationalId.trim().length === 0) {
    return new Response(JSON.stringify({ error: 'national_id_required' }), { status: 400 });
  }

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  const clientIp = req.headers.get('x-forwarded-for')?.split(',')[0]?.trim() ?? 'unknown';

  const windowStart = new Date(Date.now() - RATE_LIMIT_WINDOW_MINUTES * 60_000).toISOString();
  const { count, error: countError } = await supabase
    .from('login_identifier_attempts')
    .select('id', { count: 'exact', head: true })
    .eq('ip', clientIp)
    .gte('created_at', windowStart);

  if (countError) {
    return new Response(JSON.stringify({ error: 'rate_limit_check_failed' }), { status: 500 });
  }

  if ((count ?? 0) >= RATE_LIMIT_MAX_ATTEMPTS) {
    return new Response(JSON.stringify({ error: 'rate_limited' }), { status: 429 });
  }

  await supabase.from('login_identifier_attempts').insert({ ip: clientIp });

  const { data: email, error } = await supabase.rpc('resolve_identifier_by_national_id', {
    p_national_id: nationalId,
  });

  if (error) {
    return new Response(JSON.stringify({ error: 'lookup_failed' }), { status: 500 });
  }

  if (!email) {
    return new Response(JSON.stringify({ error: 'not_found' }), { status: 404 });
  }

  return new Response(JSON.stringify({ email }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
});
