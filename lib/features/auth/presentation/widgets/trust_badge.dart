import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';

class TrustBadge extends StatelessWidget {
  const TrustBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HakimSpacing.md,
        vertical: HakimSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: HakimColors.trustBadge,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x9943474E)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_outlined, size: 13, color: HakimColors.sanad),
          SizedBox(width: HakimSpacing.xs),
          Text(
            'خدمة حكومية رسمية · وزارة الصحة',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 11, color: HakimColors.textHint),
          ),
        ],
      ),
    );
  }
}
