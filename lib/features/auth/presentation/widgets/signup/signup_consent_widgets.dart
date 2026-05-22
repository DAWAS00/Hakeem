import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';

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
                    Icon(icon, size: 15, color: HakimColorScheme.of(context).accent),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColorScheme.of(context).textPrimary)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 11, color: HakimColorScheme.of(context).textHint)),
              ],
            ),
          ),
          const SizedBox(width: HakimSpacing.md),
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: HakimColorScheme.of(context).primary,
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
                    Icon(icon, size: 15, color: HakimColorScheme.of(context).accent),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColorScheme.of(context).textPrimary)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 11, color: HakimColorScheme.of(context).textHint)),
              ],
            ),
          ),
          const SizedBox(width: HakimSpacing.md),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: HakimColorScheme.of(context).sanad,
            activeTrackColor: HakimColorScheme.of(context).sanad.withValues(alpha: 0.3),
            inactiveThumbColor: HakimColorScheme.of(context).textHint,
            inactiveTrackColor: HakimColorScheme.of(context).bgInput,
          ),
        ],
      );
  }
}
