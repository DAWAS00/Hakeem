import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: HakimColors.border, thickness: 0.5)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
          child: Text(
            'أو',
            style: TextStyle(fontSize: 12, color: HakimColors.textHint),
          ),
        ),
        Expanded(child: Divider(color: HakimColors.border, thickness: 0.5)),
      ],
    );
  }
}
