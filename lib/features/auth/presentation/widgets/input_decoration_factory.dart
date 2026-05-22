import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';

abstract final class InputDecorationFactory {
  static InputDecoration build({
    required BuildContext context,
    required String hint,
    required Widget prefixIcon,
    Widget? suffixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const radius = BorderRadius.all(Radius.circular(10));
    
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: HakimColorScheme.of(context).textHint, fontSize: 14),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: HakimColorScheme.of(context).bgInput.withValues(alpha: 0.04),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: HakimSpacing.lg,
        vertical: HakimSpacing.md + 2,
      ),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(
          color: HakimColorScheme.of(context).border.withValues(alpha: 0.12),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(
          color: HakimColorScheme.of(context).border.withValues(alpha: 0.12),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: HakimColorScheme.of(context).borderFocus, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: HakimColorScheme.of(context).error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: HakimColorScheme.of(context).error, width: 1.5),
      ),
      errorStyle: TextStyle(color: HakimColorScheme.of(context).error, fontSize: 12),
    );
  }
}
