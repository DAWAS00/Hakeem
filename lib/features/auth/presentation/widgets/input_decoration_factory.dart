import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';

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
      hintStyle: const TextStyle(color: HakimColors.textHint, fontSize: 14),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDark ? HakimColors.bgInput : HakimColors.primary.withValues(alpha: 0.04),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: HakimSpacing.lg,
        vertical: HakimSpacing.md + 2,
      ),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(
          color: isDark ? HakimColors.border : HakimColors.primary.withValues(alpha: 0.12),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(
          color: isDark ? HakimColors.border : HakimColors.primary.withValues(alpha: 0.12),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: HakimColors.borderFocus, width: 1.5),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: HakimColors.error),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: HakimColors.error, width: 1.5),
      ),
      errorStyle: const TextStyle(color: HakimColors.error, fontSize: 12),
    );
  }
}
