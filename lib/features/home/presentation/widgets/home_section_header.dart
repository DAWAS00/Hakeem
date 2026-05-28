import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(HakimSpacing.xl, 4, HakimSpacing.xl, 8),
      child: Row(
        children: [
          if (actionLabel != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionLabel!,
                style: TextStyle(
                  fontSize: 12,
                  color: HakimColorScheme.of(context).info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.titleMedium?.color ?? HakimColorScheme.of(context).textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

