import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';

class SignupConsentCheckRow extends StatelessWidget {
  const SignupConsentCheckRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 15, color: HakimColors.accent),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColors.textPrimary)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 11, color: HakimColors.textHint)),
              ],
            ),
          ),
          const SizedBox(width: HakimSpacing.md),
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: HakimColors.primary,
            checkColor: Colors.white,
            side: BorderSide(color: Theme.of(context).dividerColor, width: 1.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)),
          ),
        ],
      );
}

class SignupConsentToggleRow extends StatelessWidget {
  const SignupConsentToggleRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 15, color: HakimColors.accent),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColors.textPrimary)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 11, color: HakimColors.textHint)),
              ],
            ),
          ),
          const SizedBox(width: HakimSpacing.md),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: HakimColors.sanad,
            activeTrackColor: HakimColors.sanad.withValues(alpha: 0.3),
            inactiveThumbColor: HakimColors.textHint,
            inactiveTrackColor: isDark ? HakimColors.bgInput : HakimColors.bgInputLight,
          ),
        ],
      );
  }
}
