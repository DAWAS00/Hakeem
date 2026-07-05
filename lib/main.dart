import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/app_settings_provider.dart';
import 'core/l10n/app_localizations.dart';
import 'core/telemetry/talker_provider.dart';

void main() async {
  final talker = TalkerFlutter.init(
    settings: TalkerSettings(useConsoleLogs: true),
  );

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    talker.handle(details.exception, details.stack, 'FlutterError');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    talker.handle(error, stack, 'PlatformDispatcher uncaught error');
    return true;
  };

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    runApp(
      ProviderScope(
        observers: [TalkerRiverpodObserver(talker: talker)],
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          talkerProvider.overrideWithValue(talker),
        ],
        child: const HakeemApp(),
      ),
    );
  }, (error, stackTrace) {
    talker.handle(error, stackTrace, 'Uncaught zone error');
  });
}

class HakeemApp extends ConsumerWidget {
  const HakeemApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    return MaterialApp.router(
      title: 'حكيم',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      routerConfig: appRouter,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => Directionality(
        textDirection: settings.locale.languageCode == 'en'
            ? TextDirection.ltr
            : TextDirection.rtl,
        child: child!,
      ),
    );
  }
}