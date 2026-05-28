import 'package:flutter/material.dart';
import '../../../../../core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import '../../../../../shared/widgets/hakim_icon.dart';

InputDecoration signupFieldDec(BuildContext context, {
  required String hint,
  String? prefixIcon,
  Widget? suffix,
  Widget? prefix,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: HakimColorScheme.of(context).textHint, fontSize: 14),
    prefixIcon: prefixIcon != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.md),
            child: HakimIcon(prefixIcon, size: 18, color: HakimColorScheme.of(context).accent),
          )
        : prefix,
    suffixIcon: suffix,
    filled: true,
    fillColor: HakimColorScheme.of(context).bgInput.withValues(alpha: 0.04),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? Theme.of(context).dividerColor : HakimColorScheme.of(context).primary.withValues(alpha: 0.1))),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? Theme.of(context).dividerColor : HakimColorScheme.of(context).primary.withValues(alpha: 0.1))),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            BorderSide(color: HakimColorScheme.of(context).borderFocus, width: 1.5)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: HakimColorScheme.of(context).error)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            BorderSide(color: HakimColorScheme.of(context).error, width: 1.5)),
    errorStyle:
        TextStyle(color: HakimColorScheme.of(context).error, fontSize: 11),
  );
}
