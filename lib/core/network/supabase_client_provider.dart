import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Passed in via `--dart-define-from-file=env.json` (gitignored — see
/// `env.example.json`). Never hardcode real project credentials here.
const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabasePublishableKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

/// Call once in `main()` before `runApp`, after `WidgetsFlutterBinding.ensureInitialized()`.
///
/// Throws [SupabaseConfigError] when the required compile-time defines are
/// missing — this is a build-config failure, not a runtime condition, so it
/// must surface as a real exception (not an `assert`, which is stripped in
/// release builds and would let the app boot with empty credentials).
Future<void> initializeSupabase() async {
  if (_supabaseUrl.isEmpty || _supabasePublishableKey.isEmpty) {
    throw SupabaseConfigError(
      'SUPABASE_URL / SUPABASE_PUBLISHABLE_KEY not provided — run with '
      '--dart-define-from-file=env.json (copy env.example.json first).',
    );
  }
  await Supabase.initialize(
    url: _supabaseUrl,
    publishableKey: _supabasePublishableKey,
  );
}

/// Thrown when Supabase compile-time credentials are missing or empty.
///
/// `main()` catches this and shows a fatal configuration-error screen instead
/// of letting the app boot into a broken state (e.g. empty URL → mysterious
/// failures later in the datasources).
class SupabaseConfigError extends Error {
  SupabaseConfigError(this.message);

  final String message;

  @override
  String toString() => 'SupabaseConfigError: $message';
}

/// Single shared client — every datasource reads it through this provider
/// instead of calling `Supabase.instance.client` directly, so it can be
/// overridden in tests.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
