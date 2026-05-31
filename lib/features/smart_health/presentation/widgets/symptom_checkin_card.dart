import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';

class SymptomCheckinCard extends StatelessWidget {
  const SymptomCheckinCard({
    super.key,
    this.lastCheckInDate,
    this.onTap,
  });

  final DateTime? lastCheckInDate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    
    final lastCheckInStr = lastCheckInDate != null
        ? 'آخر تسجيل: ${DateFormat.MMMd('ar').format(lastCheckInDate!)}'
        : 'لم تسجل أي أعراض بعد';

    return InkWell(
      onTap: onTap,
      borderRadius: HakimRadius.bxl,
      child: Container(
        padding: const EdgeInsets.all(HakimSpacing.lg),
        decoration: BoxDecoration(
          color: c.bgSurface,
          borderRadius: HakimRadius.bxl,
          border: Border.all(color: c.borderCard),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'كيف تشعر اليوم؟',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: HakimSpacing.xs),
                  Text(
                    lastCheckInStr,
                    style: TextStyle(
                      fontSize: 12,
                      color: c.textHint,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(HakimSpacing.md),
              decoration: BoxDecoration(
                color: c.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic_none_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
