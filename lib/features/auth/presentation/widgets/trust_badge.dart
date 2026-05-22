import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';

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
        color: HakimColorScheme.of(context).primary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x9943474E)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_outlined, size: 13, color: HakimColorScheme.of(context).sanad),
          SizedBox(width: HakimSpacing.xs),
          Text(
            'خدمة حكومية رسمية · وزارة الصحة',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 11, color: HakimColorScheme.of(context).textHint),
          ),
        ],
      ),
    );
  }
}
