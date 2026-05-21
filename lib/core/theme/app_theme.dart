import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/hakim_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: HakimColors.bgBaseLight,
      colorScheme: const ColorScheme.light(
        primary: HakimColors.primaryLight,
        secondary: HakimColors.accent,
        surface: HakimColors.bgCardLight,
        error: HakimColors.error,
      ),
      textTheme: GoogleFonts.cairoTextTheme(base.textTheme).apply(
        bodyColor: HakimColors.textPrimaryLight,
        displayColor: HakimColors.textPrimaryLight,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: HakimColors.bgInputLight,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: HakimColors.bgBaseLight,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: HakimColors.bgBase,
      colorScheme: const ColorScheme.dark(
        primary: HakimColors.primary,
        secondary: HakimColors.accent,
        surface: HakimColors.bgCard,
        error: HakimColors.error,
      ),
      textTheme: GoogleFonts.cairoTextTheme(base.textTheme).apply(
        bodyColor: HakimColors.textPrimary,
        displayColor: HakimColors.textPrimary,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: HakimColors.bgInput,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: HakimColors.bgBase,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
    );
  }
}
