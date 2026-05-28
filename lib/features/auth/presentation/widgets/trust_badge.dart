import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_icons.dart';
import '../../../../shared/widgets/hakim_icon.dart';
import '../../../../core/constants/hakim_colors.dart';

class TrustBadge extends StatelessWidget {
  const TrustBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: c.sanadBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: c.sanad.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HakimIcon(HakimIcons.shieldOutlined, size: 12, color: c.sanad),
          const SizedBox(width: 5),
          Text(
            'خدمة حكومية رسمية · وزارة الصحة',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: c.sanadText,
            ),
          ),
        ],
      ),
    );
  }
}
