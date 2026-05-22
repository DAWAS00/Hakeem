import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/hakim_colors.dart';
import 'hakim_text_styles.dart';

// ─────────────────────────────────────────────────────────────
//  HAKIM THEME
//
//  Usage in main.dart / app root:
//
//    MaterialApp.router(
//      theme:      HakimTheme.light,
//      darkTheme:  HakimTheme.dark,
//      themeMode:  ThemeMode.system,   // or .light / .dark
//      ...
//    )
//
//  Then inside any widget:
//    final c = HakimColorScheme.of(context);
//    final t = HakimTextStyles.body(context);
// ─────────────────────────────────────────────────────────────
abstract final class AppTheme {

  // ── DARK ─────────────────────────────────────────────────
  static final ThemeData dark = _build(
    brightness:   Brightness.dark,
    colors:       HakimColorScheme.dark,
    statusIcons:  Brightness.light,
  );

  // ── LIGHT ─────────────────────────────────────────────────
  static final ThemeData light = _build(
    brightness:   Brightness.light,
    colors:       HakimColorScheme.light,
    statusIcons:  Brightness.dark,
  );

  // ── Builder ───────────────────────────────────────────────
  static ThemeData _build({
    required Brightness        brightness,
    required HakimColorScheme  colors,
    required Brightness        statusIcons,
  }) {
    final isDark = brightness == Brightness.dark;
    final fontFamily = GoogleFonts.ibmPlexSansArabic().fontFamily;

    return ThemeData(
      useMaterial3:   true,
      brightness:     brightness,
      fontFamily:     fontFamily,
      extensions:     [colors],

      // ── Color scheme wired to Material3 ─────────────────
      colorScheme: ColorScheme(
        brightness:       brightness,
        primary:          colors.primary,
        onPrimary:        colors.primaryText,
        primaryContainer: colors.primaryDark,
        onPrimaryContainer: colors.primaryText,
        secondary:        colors.sanad,
        onSecondary:      Colors.white,
        secondaryContainer: colors.sanadBg,
        onSecondaryContainer: colors.sanadText,
        tertiary:         colors.warning,
        onTertiary:       Colors.white,
        error:            colors.error,
        onError:          Colors.white,
        errorContainer:   colors.errorBg,
        onErrorContainer: colors.errorText,
        surface:          colors.bgCard,
        onSurface:        colors.textPrimary,
        surfaceContainerHighest: colors.bgInput,
        onSurfaceVariant: colors.textSecondary,
        outline:          colors.border,
        outlineVariant:   colors.borderMuted,
        shadow:           Colors.black,
        scrim:            Colors.black,
        inverseSurface:       isDark ? HakimLight.bgCard  : HakimDark.bgCard,
        onInverseSurface:     isDark ? HakimLight.textPrimary : HakimDark.textPrimary,
        inversePrimary:       isDark ? HakimLight.primary  : HakimDark.primary,
      ),

      // ── Scaffold ─────────────────────────────────────────
      scaffoldBackgroundColor: colors.bgBase,

      // ── Text ─────────────────────────────────────────────
      textTheme: hakimTextTheme(colors.textPrimary, colors.textSecondary),

      // ── AppBar ───────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor:  colors.bgBase,
        foregroundColor:  colors.textPrimary,
        elevation:        0,
        scrolledUnderElevation: 0,
        centerTitle:      true,
        titleTextStyle:   TextStyle(
          fontSize:   17,
          fontWeight: FontWeight.w600,
          color:      colors.textPrimary,
          fontFamily: fontFamily,
        ),
        iconTheme:        IconThemeData(color: colors.accent),
        actionsIconTheme: IconThemeData(color: colors.accent),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:            Colors.transparent,
          statusBarIconBrightness:   statusIcons,
          statusBarBrightness:       brightness,
          systemNavigationBarColor:  colors.bgDeep,
          systemNavigationBarIconBrightness: statusIcons,
        ),
      ),

      // ── Bottom Navigation Bar ─────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:     colors.bgDeep,
        selectedItemColor:   colors.accent,
        unselectedItemColor: colors.textHint,
        selectedLabelStyle:  TextStyle(
          fontSize:   9,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 9),
        showSelectedLabels:   true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // ── Navigation Bar (Material3) ─────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:     colors.bgDeep,
        indicatorColor:      colors.primary.withOpacity(0.2),
        iconTheme:           WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return IconThemeData(
            color: active ? colors.accent : colors.textHint,
            size:  22,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize:   9,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color:      active ? colors.accent : colors.textHint,
            fontFamily: fontFamily,
          );
        }),
        elevation:      0,
        overlayColor:   WidgetStateProperty.all(Colors.transparent),
      ),

      // ── Card ──────────────────────────────────────────────
      cardTheme: CardThemeData(
        color:        colors.bgCard,
        elevation:    0,
        shape: RoundedRectangleBorder(
          borderRadius: HakimRadius.blg,
          side: BorderSide(color: colors.border, width: 1),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: HakimSpacing.screenH,
          vertical:   HakimSpacing.xs,
        ),
      ),

      // ── Elevated Button ───────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:         colors.primary,
          foregroundColor:         colors.primaryText,
          disabledBackgroundColor: colors.primary.withOpacity(0.4),
          disabledForegroundColor: colors.primaryText.withOpacity(0.5),
          minimumSize:  const Size.fromHeight(52),
          padding:      const EdgeInsets.symmetric(horizontal: 24),
          elevation:    0,
          shape: RoundedRectangleBorder(
            borderRadius: HakimRadius.bmd,
          ),
          textStyle: TextStyle(
            fontSize:   16,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),

      // ── Outlined Button ───────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor:  colors.primary,
          minimumSize:      const Size.fromHeight(52),
          padding:          const EdgeInsets.symmetric(horizontal: 24),
          elevation:        0,
          side:             BorderSide(color: colors.border, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: HakimRadius.bmd,
          ),
          textStyle: TextStyle(
            fontSize:   16,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),

      // ── Text Button ───────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: TextStyle(
            fontSize:   14,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily,
          ),
        ),
      ),

      // ── FAB ───────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor:    colors.primary,
        foregroundColor:    colors.primaryText,
        elevation:          0,
        focusElevation:     0,
        hoverElevation:     0,
        highlightElevation: 0,
        shape: const CircleBorder(),
      ),

      // ── Input / TextField ─────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled:          true,
        fillColor:       colors.bgInput,
        hintStyle:       TextStyle(color: colors.textHint, fontSize: 14),
        contentPadding:  const EdgeInsets.symmetric(
          horizontal: 16,
          vertical:   14,
        ),
        border: OutlineInputBorder(
          borderRadius: HakimRadius.bmd,
          borderSide:   BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: HakimRadius.bmd,
          borderSide:   BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: HakimRadius.bmd,
          borderSide:   BorderSide(color: colors.borderFocus, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: HakimRadius.bmd,
          borderSide:   BorderSide(color: colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: HakimRadius.bmd,
          borderSide:   BorderSide(color: colors.error, width: 1.5),
        ),
        errorStyle:   TextStyle(color: colors.error, fontSize: 12),
        labelStyle:   TextStyle(color: colors.textHint, fontSize: 14),
        prefixIconColor: colors.accent,
        suffixIconColor: colors.textHint,
      ),

      // ── Checkbox ──────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.sanad;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side:       BorderSide(color: colors.border, width: 1.5),
        shape:      RoundedRectangleBorder(
          borderRadius: HakimRadius.bxs,
        ),
      ),

      // ── Switch ────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return colors.textHint;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.sanad;
          return colors.bgInput;
        }),
      ),

      // ── Chip ──────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor:    colors.bgInput,
        selectedColor:      colors.primary,
        disabledColor:      colors.bgInput,
        labelStyle:         TextStyle(color: colors.textPrimary, fontSize: 13),
        secondaryLabelStyle: TextStyle(color: colors.primaryText, fontSize: 13),
        padding:            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        side:               BorderSide(color: colors.border, width: 0.5),
        shape:              const StadiumBorder(),
        elevation:          0,
        pressElevation:     0,
      ),

      // ── Divider ───────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color:     colors.borderCard,
        thickness: 0.5,
        space:     0,
      ),

      // ── List Tile ─────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor:      Colors.transparent,
        iconColor:      colors.accent,
        textColor:      colors.textPrimary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: HakimSpacing.screenH,
          vertical:   HakimSpacing.xs,
        ),
        minLeadingWidth:  20,
        minVerticalPadding: 10,
        shape: RoundedRectangleBorder(
          borderRadius: HakimRadius.bmd,
        ),
      ),

      // ── Dialog ────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: colors.bgCard,
        elevation:       0,
        shape: RoundedRectangleBorder(
          borderRadius: HakimRadius.bxl,
          side: BorderSide(color: colors.border),
        ),
        titleTextStyle: TextStyle(
          fontSize:   17,
          fontWeight: FontWeight.w600,
          color:      colors.textPrimary,
          fontFamily: fontFamily,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          color:    colors.textSecondary,
          height:   1.6,
        ),
      ),

      // ── Bottom Sheet ──────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor:     colors.bgCard,
        surfaceTintColor:    Colors.transparent,
        elevation:           0,
        modalElevation:      0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: HakimRadius.xl,
          ),
          side: BorderSide(color: colors.border),
        ),
        dragHandleColor: colors.border,
        showDragHandle:  true,
      ),

      // ── Snack Bar ─────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor:    colors.bgInput,
        contentTextStyle:   TextStyle(
          color:      colors.textPrimary,
          fontSize:   13,
          fontFamily: fontFamily,
        ),
        actionTextColor:    colors.primary,
        elevation:          0,
        behavior:           SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: HakimRadius.bmd,
          side: BorderSide(color: colors.border),
        ),
      ),

      // ── Progress Indicator ────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color:            colors.primary,
        linearTrackColor: colors.border,
        linearMinHeight:  2,
        circularTrackColor: colors.border,
      ),

      // ── Slider ───────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor:   colors.primary,
        inactiveTrackColor: colors.border,
        thumbColor:         colors.primary,
        overlayColor:       colors.primary.withOpacity(0.15),
        valueIndicatorColor: colors.primary,
        trackHeight:        2,
      ),

      // ── Tab Bar ───────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor:         colors.primary,
        unselectedLabelColor: colors.textHint,
        indicatorColor:     colors.primary,
        indicatorSize:      TabBarIndicatorSize.label,
        dividerColor:       colors.borderCard,
        labelStyle: TextStyle(
          fontSize:   14,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
      ),

      // ── Icon ─────────────────────────────────────────────
      iconTheme: IconThemeData(color: colors.accent, size: 22),

      // ── Popup Menu ───────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color:     colors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: HakimRadius.bmd,
          side: BorderSide(color: colors.border),
        ),
        textStyle: TextStyle(
          color:      colors.textPrimary,
          fontSize:   14,
          fontFamily: fontFamily,
        ),
      ),

      // ── Dropdown ─────────────────────────────────────────
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: TextStyle(
          color:      colors.textPrimary,
          fontSize:   14,
          fontFamily: fontFamily,
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(colors.bgCard),
          elevation:       WidgetStateProperty.all(0),
          side:            WidgetStateProperty.all(
            BorderSide(color: colors.border),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: HakimRadius.bmd),
          ),
        ),
      ),

      // ── Date Picker ──────────────────────────────────────
      datePickerTheme: DatePickerThemeData(
        backgroundColor:    colors.bgCard,
        headerBackgroundColor: colors.primary,
        headerForegroundColor: colors.primaryText,
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.primaryText;
          if (states.contains(WidgetState.disabled)) return colors.textDisabled;
          return colors.textPrimary;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.primary;
          return Colors.transparent;
        }),
        todayBorder:    BorderSide(color: colors.primary),
        todayForegroundColor: WidgetStateProperty.all(colors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: HakimRadius.bxl,
          side: BorderSide(color: colors.border),
        ),
        dividerColor: colors.borderCard,
      ),

      // ── Refresh Indicator ────────────────────────────────
      // (no theme; set color in widget directly to colors.accent)

      // ── Splash / Ripple ───────────────────────────────────
      splashFactory:  InkRipple.splashFactory,
      splashColor:    colors.primary.withOpacity(0.08),
      highlightColor: colors.primary.withOpacity(0.05),

      // ── Page transitions ──────────────────────────────────
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS:     CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
