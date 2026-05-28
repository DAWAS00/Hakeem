import 'package:flutter/material.dart';
import '../../../../../core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import '../../../../../shared/widgets/hakim_icon.dart';

class SignupCardHeader extends StatelessWidget {
  const SignupCardHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final String icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HakimIcon(icon, size: 18, color: HakimColorScheme.of(context).accent),
              const SizedBox(width: HakimSpacing.sm),
              Text(title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.titleMedium?.color ?? HakimColorScheme.of(context).textPrimary,
                  )),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle,
              style: TextStyle(
                  fontSize: 12, color: HakimColorScheme.of(context).textHint)),
          const SizedBox(height: HakimSpacing.md),
          Divider(color: Theme.of(context).dividerColor, thickness: 1),
        ],
      );
}

