import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';

class OtpHint extends StatelessWidget {
  const OtpHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HakimSpacing.md,
        vertical: HakimSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1A26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(Icons.sms_outlined, size: 14, color: HakimColorScheme.of(context).accent),
          SizedBox(width: HakimSpacing.sm),
          Expanded(
            child: Text(
              'سيتم إرسال رمز التحقق إلى رقم جوالك المسجل',
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 11, color: HakimColorScheme.of(context).textHint),
            ),
          ),
        ],
      ),
    );
  }
}
