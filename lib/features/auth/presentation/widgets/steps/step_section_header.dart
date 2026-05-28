import 'package:flutter/material.dart';
import '../../../../../core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';

class StepSectionHeader extends StatelessWidget {
  const StepSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: HakimColorScheme.of(context).accent,
          ),
        ),
        const SizedBox(height: HakimSpacing.xs),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).brightness == Brightness.dark
                ? HakimColorScheme.of(context).textSecondary
                : HakimColorScheme.of(context).textSecondary,
          ),
        ),
      ],
    );
  }
}

