import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';

class SignupLockedStepRow extends StatelessWidget {
  const SignupLockedStepRow({super.key, required this.number, required this.title});
  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: HakimSpacing.lg, vertical: HakimSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? HakimColors.bgLocked : HakimColors.bgLockedLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline_rounded,
              size: 14, color: HakimColors.textHint),
          const SizedBox(width: HakimSpacing.sm),
          Text(title,
              style: const TextStyle(
                  fontSize: 13, color: HakimColors.textHint)),
          const Spacer(),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isDark ? HakimColors.bgInput : HakimColors.bgInputLight,
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Center(
              child: Text(number,
                  style: const TextStyle(
                      fontSize: 10,
                      color: HakimColors.textHint,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
