import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';

class SignupCardHeader extends StatelessWidget {
  const SignupCardHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: HakimColors.accent),
              const SizedBox(width: HakimSpacing.sm),
              Text(title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.titleMedium?.color ?? HakimColors.textPrimary,
                  )),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(
                  fontSize: 12, color: HakimColors.textHint)),
          const SizedBox(height: HakimSpacing.md),
          Divider(color: Theme.of(context).dividerColor, thickness: 1),
        ],
      );
}
