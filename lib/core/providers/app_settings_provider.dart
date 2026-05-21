import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class AppSettingsState {
  final ThemeMode themeMode;
  final Locale locale;

  const AppSettingsState({
    required this.themeMode,
    required this.locale,
  });

  AppSettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return AppSettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettingsState>(AppSettingsNotifier.new);

class AppSettingsNotifier extends Notifier<AppSettingsState> {
  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale';

  @override
  AppSettingsState build() {
    final prefs = ref.watch(sharedPreferencesProvider);

    final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.system.index;
    final localeCode = prefs.getString(_localeKey) ?? 'ar';

    return AppSettingsState(
      themeMode: ThemeMode.values[themeIndex],
      locale: Locale(localeCode),
    );
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = state.copyWith(themeMode: newMode);
    
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_themeKey, newMode.index);
  }

  Future<void> setLocale(Locale locale) async {
    if (state.locale == locale) return;
    state = state.copyWith(locale: locale);

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_localeKey, locale.languageCode);
  }
}
