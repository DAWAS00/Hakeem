import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_icons.dart';
import '../../../../shared/widgets/hakim_icon.dart';
import '../../../../core/constants/hakim_colors.dart';

class OtpHint extends StatelessWidget {
  const OtpHint({super.key});

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: c.infoBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: c.info.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HakimIcon(HakimIcons.smsOutlined, size: 15, color: c.info),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'سيتم إرسال رمز التحقق إلى رقم جوالك المسجل',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 12, height: 1.5, color: c.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
