import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';

InputDecoration signupFieldDec(BuildContext context, {
  required String hint,
  IconData? prefixIcon,
  Widget? suffix,
  Widget? prefix,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: HakimColors.textHint, fontSize: 14),
    prefixIcon: prefixIcon != null
        ? Icon(prefixIcon, size: 18, color: HakimColors.accent)
        : prefix,
    suffixIcon: suffix,
    filled: true,
    fillColor: isDark ? HakimColors.bgInput : HakimColors.primary.withValues(alpha: 0.04),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? Theme.of(context).dividerColor : HakimColors.primary.withValues(alpha: 0.1))),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? Theme.of(context).dividerColor : HakimColors.primary.withValues(alpha: 0.1))),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: HakimColors.borderFocus, width: 1.5)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: HakimColors.error)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: HakimColors.error, width: 1.5)),
    errorStyle:
        const TextStyle(color: HakimColors.error, fontSize: 11),
  );
}
