import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Shared logger for the whole app — repositories log mapped failures here.
///
/// `main.dart` creates the real instance before `runApp` (so it can capture
/// `FlutterError.onError`/`PlatformDispatcher.instance.onError`/zone errors
/// during startup too) and overrides this provider with that same instance
/// via `talkerProvider.overrideWithValue(talker)`, so the whole app — including
/// this default fallback — shares one logger. Never expose the Talker screen
/// in release builds.
final talkerProvider = Provider<Talker>((ref) {
  return TalkerFlutter.init(
    settings: TalkerSettings(
      useConsoleLogs: true,
    ),
  );
});
