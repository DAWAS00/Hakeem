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
    final c = HakimColorScheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(HakimSpacing.xl, 4, HakimSpacing.xl, 8),
      child: Row(
        children: [
          // Title — rightmost in RTL
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          const Spacer(),
          // Action link — leftmost in RTL
          if (actionLabel != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionLabel!,
                style: TextStyle(
                  fontSize: 12,
                  color: c.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

