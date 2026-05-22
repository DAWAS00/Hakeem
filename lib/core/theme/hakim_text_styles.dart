import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/hakim_colors.dart';

// ─────────────────────────────────────────────────────────────
//  HAKIM TEXT STYLES — complete typography system
//
//  All styles are defined at 1.0 textScaleFactor.
//  Flutter's accessibility system will scale them automatically.
//
//  USAGE:
//    Text('حكيم', style: HakimTextStyles.display(context))
//    Text('مواعيدك', style: HakimTextStyles.h1(context))
//
//  Each method reads HakimColorScheme.of(context) so the
//  correct text color is automatically applied per mode.
// ─────────────────────────────────────────────────────────────
abstract final class HakimTextStyles {

  // ── Display — app name on splash / onboarding ─────────────
  static TextStyle display(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize:      28,
    fontWeight:    FontWeight.w600,
    color:         HakimColorScheme.of(context).accent,
    letterSpacing: -0.5,
    height:        1.2,
  );

  // ── Headings ───────────────────────────────────────────────
  static TextStyle h1(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize:   20,
    fontWeight: FontWeight.w600,
    color:      HakimColorScheme.of(context).textPrimary,
    height:     1.3,
  );

  static TextStyle h2(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize:   17,
    fontWeight: FontWeight.w600,
    color:      HakimColorScheme.of(context).textPrimary,
    height:     1.3,
  );

  static TextStyle h3(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize:   15,
    fontWeight: FontWeight.w600,
    color:      HakimColorScheme.of(context).textPrimary,
    height:     1.4,
  );

  // ── Section title inside card ──────────────────────────────
  static TextStyle sectionTitle(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize:   13,
    fontWeight: FontWeight.w600,
    color:      HakimColorScheme.of(context).textPrimary,
    height:     1.4,
  );

  // ── Body ──────────────────────────────────────────────────
  static TextStyle bodyLg(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize: 16,
    color:    HakimColorScheme.of(context).textPrimary,
    height:   1.6,
  );

  static TextStyle body(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize: 14,
    color:    HakimColorScheme.of(context).textPrimary,
    height:   1.6,
  );

  static TextStyle bodySm(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize: 13,
    color:    HakimColorScheme.of(context).textSecondary,
    height:   1.5,
  );

  // ── Label — button text, field labels ─────────────────────
  static TextStyle labelLg(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize:   16,
    fontWeight: FontWeight.w600,
    color:      HakimColorScheme.of(context).primaryText,
    letterSpacing: 0.1,
  );

  static TextStyle label(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize:   14,
    fontWeight: FontWeight.w600,
    color:      HakimColorScheme.of(context).textPrimary,
  );

  static TextStyle labelSm(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize:   12,
    fontWeight: FontWeight.w500,
    color:      HakimColorScheme.of(context).textPrimary,
  );

  // ── Caption / hint ────────────────────────────────────────
  static TextStyle caption(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize: 12,
    color:    HakimColorScheme.of(context).textSecondary,
    height:   1.4,
  );

  static TextStyle hint(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize: 12,
    color:    HakimColorScheme.of(context).textHint,
  );

  // ── Micro — badges, nav labels, chips ─────────────────────
  static TextStyle micro(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize:      11,
    fontWeight:    FontWeight.w500,
    color:         HakimColorScheme.of(context).textHint,
    letterSpacing: 0.2,
  );

  static TextStyle microBold(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize:      11,
    fontWeight:    FontWeight.w600,
    color:         HakimColorScheme.of(context).textSecondary,
    letterSpacing: 0.3,
  );

  // ── Field label — above input fields ──────────────────────
  static TextStyle fieldLabel(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize:   13,
    fontWeight: FontWeight.w600,
    color:      HakimColorScheme.of(context).textPrimary,
  );

  // ── Input text — inside text fields ───────────────────────
  static TextStyle inputText(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize: 15,
    color:    HakimColorScheme.of(context).textPrimary,
    height:   1.4,
  );

  // ── Error message — below fields ──────────────────────────
  static TextStyle errorText(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize: 12,
    color:    HakimColorScheme.of(context).error,
  );

  // ── Link / action text ────────────────────────────────────
  static TextStyle link(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize:    13,
    color:       HakimColorScheme.of(context).primary,
    decoration:  TextDecoration.underline,
    decorationColor: HakimColorScheme.of(context).primary,
  );

  // ── Numeric vitals — large health metric values ────────────
  static TextStyle vital(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize:      15,
    fontWeight:    FontWeight.w700,
    color:         HakimColorScheme.of(context).textPrimary,
    fontFeatures:  const [FontFeature.tabularFigures()],
  );

  static TextStyle vitalLg(BuildContext context) => GoogleFonts.ibmPlexSansArabic(
    fontSize:      22,
    fontWeight:    FontWeight.w700,
    color:         HakimColorScheme.of(context).textPrimary,
    fontFeatures:  const [FontFeature.tabularFigures()],
  );

  // ── Mono — medication names, IDs ──────────────────────────
  static TextStyle mono(BuildContext context) => TextStyle(
    fontSize:   13,
    fontFamily: 'monospace',
    color:      HakimColorScheme.of(context).textSecondary,
    height:     1.5,
  );
}

// ─────────────────────────────────────────────────────────────
//  HAKIM TEXT THEME
//  Returns a complete TextTheme to plug into ThemeData.
//  All colors here are placeholders — actual widget colors
//  should use HakimTextStyles.xxx(context) for adaptive colors.
// ─────────────────────────────────────────────────────────────
TextTheme hakimTextTheme(Color primaryText, Color secondaryText) {
  return GoogleFonts.ibmPlexSansArabicTextTheme(
    TextTheme(
      displayLarge:   TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: primaryText, letterSpacing: -0.5),
      displayMedium:  TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: primaryText),
      displaySmall:   TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryText),
      headlineLarge:  TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryText),
      headlineMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: primaryText),
      headlineSmall:  TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: primaryText),
      titleLarge:     TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: primaryText),
      titleMedium:    TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: primaryText),
      titleSmall:     TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: primaryText),
      bodyLarge:      TextStyle(fontSize: 16, color: primaryText,   height: 1.6),
      bodyMedium:     TextStyle(fontSize: 14, color: primaryText,   height: 1.6),
      bodySmall:      TextStyle(fontSize: 13, color: secondaryText, height: 1.5),
      labelLarge:     TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryText),
      labelMedium:    TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: primaryText),
      labelSmall:     TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: secondaryText),
    )
  );
}
