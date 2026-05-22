import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
//  HAKIM COLORS — complete dual-mode token system
//
//  USAGE RULE — never hardcode hex values in widgets.
//  Always resolve via HakimColorScheme.of(context):
//
//    final c = HakimColorScheme.of(context);
//    Container(color: c.bgCard)
//
//  The static classes below are raw values only.
//  Use them for ThemeData construction, not in widgets directly.
// ─────────────────────────────────────────────────────────────

// ── Raw dark-mode values ───────────────────────────────────
abstract final class HakimDark {
  // Backgrounds
  static const bgBase    = Color(0xFF081424);
  static const bgCard    = Color(0xFF152031);
  static const bgInput   = Color(0xFF2A3547);
  static const bgDeep    = Color(0xFF0E1A26);
  static const bgSurface = Color(0xFF111E2E);

  // Borders
  static const border      = Color(0xFF43474E);
  static const borderFocus = Color(0xFF4C6A8D);
  static const borderCard  = Color(0xFF1E2D3D);
  static const borderMuted = Color(0xFF2A3547);

  // Brand
  static const primary      = Color(0xFF4C6A8D);
  static const primaryDark  = Color(0xFF3D5873);
  static const primaryLight = Color(0xFF6A8BAD);
  static const primaryText  = Color(0xFFDAE9FF);
  static const accent       = Color(0xFFAAC9F1);

  // Semantic — green (Sanad)
  static const sanad     = Color(0xFF10B981);
  static const sanadDark = Color(0xFF0D9268);
  static const sanadBg   = Color(0x2610B981);
  static const sanadText = Color(0xFF6EE7B7);

  // Semantic — error
  static const error     = Color(0xFFEF4444);
  static const errorDark = Color(0xFFDC2626);
  static const errorBg   = Color(0x1FEF4444);
  static const errorText = Color(0xFFFCA5A5);

  // Semantic — warning
  static const warning     = Color(0xFFF59E0B);
  static const warningDark = Color(0xFFD97706);
  static const warningBg   = Color(0x26F59E0B);
  static const warningText = Color(0xFFFCD34D);

  // Semantic — info
  static const info     = Color(0xFF3B82F6);
  static const infoBg   = Color(0x1F3B82F6);
  static const infoText = Color(0xFF93C5FD);

  // Text
  static const textPrimary   = Color(0xFFD7E3FA);
  static const textSecondary = Color(0xFFC3C6CF);
  static const textHint      = Color(0xFF888EA0);
  static const textDisabled  = Color(0xFF4A5568);

  // Vitals
  static const heartRate = Color(0xFFEF4444);
  static const bloodPres = Color(0xFF4C6A8D);
  static const steps     = Color(0xFF10B981);
}

// ── Raw light-mode values ──────────────────────────────────
abstract final class HakimLight {
  // Backgrounds
  static const bgBase    = Color(0xFFF5F7FA);
  static const bgCard    = Color(0xFFFFFFFF);
  static const bgInput   = Color(0xFFEDF0F5);
  static const bgDeep    = Color(0xFFE8EDF5);
  static const bgSurface = Color(0xFFF0F4F8);

  // Borders
  static const border      = Color(0xFFD1D9E6);
  static const borderFocus = Color(0xFF2E5F8A);
  static const borderCard  = Color(0xFFE2E8F0);
  static const borderMuted = Color(0xFFEDF0F5);

  // Brand
  static const primary      = Color(0xFF2E5F8A);
  static const primaryDark  = Color(0xFF1A4A73);
  static const primaryLight = Color(0xFF4A7BA8);
  static const primaryText  = Color(0xFFFFFFFF);
  static const accent       = Color(0xFF1A4A73);

  // Semantic — green (Sanad)
  static const sanad     = Color(0xFF0E9268);
  static const sanadDark = Color(0xFF0A7554);
  static const sanadBg   = Color(0x1A0E9268);
  static const sanadText = Color(0xFF065F46);

  // Semantic — error
  static const error     = Color(0xFFDC2626);
  static const errorDark = Color(0xFFB91C1C);
  static const errorBg   = Color(0x14DC2626);
  static const errorText = Color(0xFF991B1B);

  // Semantic — warning
  static const warning     = Color(0xFFD97706);
  static const warningDark = Color(0xFFB45309);
  static const warningBg   = Color(0x14D97706);
  static const warningText = Color(0xFF92400E);

  // Semantic — info
  static const info     = Color(0xFF1D4ED8);
  static const infoBg   = Color(0x141D4ED8);
  static const infoText = Color(0xFF1E3A8A);

  // Text
  static const textPrimary   = Color(0xFF1A2E45);
  static const textSecondary = Color(0xFF3D5268);
  static const textHint      = Color(0xFF6B7C93);
  static const textDisabled  = Color(0xFFB0BBC8);

  // Vitals
  static const heartRate = Color(0xFFDC2626);
  static const bloodPres = Color(0xFF2E5F8A);
  static const steps     = Color(0xFF0E9268);
}

// ─────────────────────────────────────────────────────────────
//  HAKIM COLOR SCHEME
//  A resolved color set that adapts to the current brightness.
//  Obtain via HakimColorScheme.of(context) inside any widget.
// ─────────────────────────────────────────────────────────────
@immutable
class HakimColorScheme extends ThemeExtension<HakimColorScheme> {
  const HakimColorScheme({
    required this.bgBase,
    required this.bgCard,
    required this.bgInput,
    required this.bgDeep,
    required this.bgSurface,
    required this.border,
    required this.borderFocus,
    required this.borderCard,
    required this.borderMuted,
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.primaryText,
    required this.accent,
    required this.sanad,
    required this.sanadDark,
    required this.sanadBg,
    required this.sanadText,
    required this.error,
    required this.errorDark,
    required this.errorBg,
    required this.errorText,
    required this.warning,
    required this.warningDark,
    required this.warningBg,
    required this.warningText,
    required this.info,
    required this.infoBg,
    required this.infoText,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.textDisabled,
    required this.heartRate,
    required this.bloodPres,
    required this.steps,
  });

  // Backgrounds
  final Color bgBase;
  final Color bgCard;
  final Color bgInput;
  final Color bgDeep;
  final Color bgSurface;

  // Borders
  final Color border;
  final Color borderFocus;
  final Color borderCard;
  final Color borderMuted;

  // Brand
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color primaryText;
  final Color accent;

  // Semantic — green
  final Color sanad;
  final Color sanadDark;
  final Color sanadBg;
  final Color sanadText;

  // Semantic — error
  final Color error;
  final Color errorDark;
  final Color errorBg;
  final Color errorText;

  // Semantic — warning
  final Color warning;
  final Color warningDark;
  final Color warningBg;
  final Color warningText;

  // Semantic — info
  final Color info;
  final Color infoBg;
  final Color infoText;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color textDisabled;

  // Vitals
  final Color heartRate;
  final Color bloodPres;
  final Color steps;

  // ── Pre-built instances ─────────────────────────────────
  static const dark = HakimColorScheme(
    bgBase:        HakimDark.bgBase,
    bgCard:        HakimDark.bgCard,
    bgInput:       HakimDark.bgInput,
    bgDeep:        HakimDark.bgDeep,
    bgSurface:     HakimDark.bgSurface,
    border:        HakimDark.border,
    borderFocus:   HakimDark.borderFocus,
    borderCard:    HakimDark.borderCard,
    borderMuted:   HakimDark.borderMuted,
    primary:       HakimDark.primary,
    primaryDark:   HakimDark.primaryDark,
    primaryLight:  HakimDark.primaryLight,
    primaryText:   HakimDark.primaryText,
    accent:        HakimDark.accent,
    sanad:         HakimDark.sanad,
    sanadDark:     HakimDark.sanadDark,
    sanadBg:       HakimDark.sanadBg,
    sanadText:     HakimDark.sanadText,
    error:         HakimDark.error,
    errorDark:     HakimDark.errorDark,
    errorBg:       HakimDark.errorBg,
    errorText:     HakimDark.errorText,
    warning:       HakimDark.warning,
    warningDark:   HakimDark.warningDark,
    warningBg:     HakimDark.warningBg,
    warningText:   HakimDark.warningText,
    info:          HakimDark.info,
    infoBg:        HakimDark.infoBg,
    infoText:      HakimDark.infoText,
    textPrimary:   HakimDark.textPrimary,
    textSecondary: HakimDark.textSecondary,
    textHint:      HakimDark.textHint,
    textDisabled:  HakimDark.textDisabled,
    heartRate:     HakimDark.heartRate,
    bloodPres:     HakimDark.bloodPres,
    steps:         HakimDark.steps,
  );

  static const light = HakimColorScheme(
    bgBase:        HakimLight.bgBase,
    bgCard:        HakimLight.bgCard,
    bgInput:       HakimLight.bgInput,
    bgDeep:        HakimLight.bgDeep,
    bgSurface:     HakimLight.bgSurface,
    border:        HakimLight.border,
    borderFocus:   HakimLight.borderFocus,
    borderCard:    HakimLight.borderCard,
    borderMuted:   HakimLight.borderMuted,
    primary:       HakimLight.primary,
    primaryDark:   HakimLight.primaryDark,
    primaryLight:  HakimLight.primaryLight,
    primaryText:   HakimLight.primaryText,
    accent:        HakimLight.accent,
    sanad:         HakimLight.sanad,
    sanadDark:     HakimLight.sanadDark,
    sanadBg:       HakimLight.sanadBg,
    sanadText:     HakimLight.sanadText,
    error:         HakimLight.error,
    errorDark:     HakimLight.errorDark,
    errorBg:       HakimLight.errorBg,
    errorText:     HakimLight.errorText,
    warning:       HakimLight.warning,
    warningDark:   HakimLight.warningDark,
    warningBg:     HakimLight.warningBg,
    warningText:   HakimLight.warningText,
    info:          HakimLight.info,
    infoBg:        HakimLight.infoBg,
    infoText:      HakimLight.infoText,
    textPrimary:   HakimLight.textPrimary,
    textSecondary: HakimLight.textSecondary,
    textHint:      HakimLight.textHint,
    textDisabled:  HakimLight.textDisabled,
    heartRate:     HakimLight.heartRate,
    bloodPres:     HakimLight.bloodPres,
    steps:         HakimLight.steps,
  );

  // ── Context accessor ─────────────────────────────────────
  /// Resolves the correct color scheme from the nearest Theme.
  /// Usage: final c = HakimColorScheme.of(context);
  static HakimColorScheme of(BuildContext context) {
    return Theme.of(context).extension<HakimColorScheme>() ??
        (Theme.of(context).brightness == Brightness.dark ? dark : light);
  }

  // ── ThemeExtension interface ─────────────────────────────
  @override
  HakimColorScheme copyWith({
    Color? bgBase, Color? bgCard, Color? bgInput, Color? bgDeep,
    Color? bgSurface, Color? border, Color? borderFocus, Color? borderCard,
    Color? borderMuted, Color? primary, Color? primaryDark, Color? primaryLight,
    Color? primaryText, Color? accent, Color? sanad, Color? sanadDark,
    Color? sanadBg, Color? sanadText, Color? error, Color? errorDark,
    Color? errorBg, Color? errorText, Color? warning, Color? warningDark,
    Color? warningBg, Color? warningText, Color? info, Color? infoBg,
    Color? infoText, Color? textPrimary, Color? textSecondary,
    Color? textHint, Color? textDisabled, Color? heartRate,
    Color? bloodPres, Color? steps,
  }) {
    return HakimColorScheme(
      bgBase:        bgBase        ?? this.bgBase,
      bgCard:        bgCard        ?? this.bgCard,
      bgInput:       bgInput       ?? this.bgInput,
      bgDeep:        bgDeep        ?? this.bgDeep,
      bgSurface:     bgSurface     ?? this.bgSurface,
      border:        border        ?? this.border,
      borderFocus:   borderFocus   ?? this.borderFocus,
      borderCard:    borderCard    ?? this.borderCard,
      borderMuted:   borderMuted   ?? this.borderMuted,
      primary:       primary       ?? this.primary,
      primaryDark:   primaryDark   ?? this.primaryDark,
      primaryLight:  primaryLight  ?? this.primaryLight,
      primaryText:   primaryText   ?? this.primaryText,
      accent:        accent        ?? this.accent,
      sanad:         sanad         ?? this.sanad,
      sanadDark:     sanadDark     ?? this.sanadDark,
      sanadBg:       sanadBg       ?? this.sanadBg,
      sanadText:     sanadText     ?? this.sanadText,
      error:         error         ?? this.error,
      errorDark:     errorDark     ?? this.errorDark,
      errorBg:       errorBg       ?? this.errorBg,
      errorText:     errorText     ?? this.errorText,
      warning:       warning       ?? this.warning,
      warningDark:   warningDark   ?? this.warningDark,
      warningBg:     warningBg     ?? this.warningBg,
      warningText:   warningText   ?? this.warningText,
      info:          info          ?? this.info,
      infoBg:        infoBg        ?? this.infoBg,
      infoText:      infoText      ?? this.infoText,
      textPrimary:   textPrimary   ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint:      textHint      ?? this.textHint,
      textDisabled:  textDisabled  ?? this.textDisabled,
      heartRate:     heartRate     ?? this.heartRate,
      bloodPres:     bloodPres     ?? this.bloodPres,
      steps:         steps         ?? this.steps,
    );
  }

  @override
  HakimColorScheme lerp(HakimColorScheme? other, double t) {
    if (other == null) return this;
    return HakimColorScheme(
      bgBase:        Color.lerp(bgBase,        other.bgBase,        t)!,
      bgCard:        Color.lerp(bgCard,        other.bgCard,        t)!,
      bgInput:       Color.lerp(bgInput,       other.bgInput,       t)!,
      bgDeep:        Color.lerp(bgDeep,        other.bgDeep,        t)!,
      bgSurface:     Color.lerp(bgSurface,     other.bgSurface,     t)!,
      border:        Color.lerp(border,        other.border,        t)!,
      borderFocus:   Color.lerp(borderFocus,   other.borderFocus,   t)!,
      borderCard:    Color.lerp(borderCard,    other.borderCard,    t)!,
      borderMuted:   Color.lerp(borderMuted,   other.borderMuted,   t)!,
      primary:       Color.lerp(primary,       other.primary,       t)!,
      primaryDark:   Color.lerp(primaryDark,   other.primaryDark,   t)!,
      primaryLight:  Color.lerp(primaryLight,  other.primaryLight,  t)!,
      primaryText:   Color.lerp(primaryText,   other.primaryText,   t)!,
      accent:        Color.lerp(accent,        other.accent,        t)!,
      sanad:         Color.lerp(sanad,         other.sanad,         t)!,
      sanadDark:     Color.lerp(sanadDark,     other.sanadDark,     t)!,
      sanadBg:       Color.lerp(sanadBg,       other.sanadBg,       t)!,
      sanadText:     Color.lerp(sanadText,     other.sanadText,     t)!,
      error:         Color.lerp(error,         other.error,         t)!,
      errorDark:     Color.lerp(errorDark,     other.errorDark,     t)!,
      errorBg:       Color.lerp(errorBg,       other.errorBg,       t)!,
      errorText:     Color.lerp(errorText,     other.errorText,     t)!,
      warning:       Color.lerp(warning,       other.warning,       t)!,
      warningDark:   Color.lerp(warningDark,   other.warningDark,   t)!,
      warningBg:     Color.lerp(warningBg,     other.warningBg,     t)!,
      warningText:   Color.lerp(warningText,   other.warningText,   t)!,
      info:          Color.lerp(info,          other.info,          t)!,
      infoBg:        Color.lerp(infoBg,        other.infoBg,        t)!,
      infoText:      Color.lerp(infoText,      other.infoText,      t)!,
      textPrimary:   Color.lerp(textPrimary,   other.textPrimary,   t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint:      Color.lerp(textHint,      other.textHint,      t)!,
      textDisabled:  Color.lerp(textDisabled,  other.textDisabled,  t)!,
      heartRate:     Color.lerp(heartRate,     other.heartRate,     t)!,
      bloodPres:     Color.lerp(bloodPres,     other.bloodPres,     t)!,
      steps:         Color.lerp(steps,         other.steps,         t)!,
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SPACING + RADIUS  (mode-independent)
// ─────────────────────────────────────────────────────────────
abstract final class HakimSpacing {
  static const xs      = 4.0;
  static const sm      = 8.0;
  static const md      = 12.0;
  static const lg      = 16.0;
  static const xl      = 20.0;
  static const xxl     = 24.0;
  static const xxxl    = 32.0;
  static const screenH = 20.0; // horizontal page padding
  static const screenV = 16.0; // vertical section gap
}

abstract final class HakimRadius {
  static const xs     = Radius.circular(6);
  static const sm     = Radius.circular(8);
  static const md     = Radius.circular(10);
  static const lg     = Radius.circular(12);
  static const xl     = Radius.circular(14);
  static const xxl    = Radius.circular(20);
  static const pill   = Radius.circular(99);
  static const circle = Radius.circular(999);

  // BorderRadius shortcuts
  static const bxs     = BorderRadius.all(xs);
  static const bsm     = BorderRadius.all(sm);
  static const bmd     = BorderRadius.all(md);
  static const blg     = BorderRadius.all(lg);
  static const bxl     = BorderRadius.all(xl);
  static const bxxl    = BorderRadius.all(xxl);
  static const bpill   = BorderRadius.all(pill);
  static const bcircle = BorderRadius.all(circle);
}
