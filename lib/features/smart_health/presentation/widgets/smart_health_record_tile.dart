import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';

class SmartHealthRecordTile extends StatelessWidget {
  const SmartHealthRecordTile({
    super.key,
    required this.title,
    required this.date,
    required this.hospital,
    required this.isAbnormal,
    required this.status,
    this.onTap,
  });

  final String title;
  final String date;
  final String hospital;
  final bool isAbnormal;
  final String status;
  final VoidCallback? onTap;

  void _showSecureShare(BuildContext context, String recordTitle) {
    final c = HakimColorScheme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: c.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'مشاركة آمنة',
          style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'سيتم إنشاء رابط مؤقت ومحمي برمز PIN لمشاركة $recordTitle.',
              style: TextStyle(color: c.textSecondary),
            ),
            const SizedBox(height: HakimSpacing.xl),
            Container(
              padding: const EdgeInsets.all(HakimSpacing.md),
              decoration: BoxDecoration(
                color: c.bgInput,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PIN: 5821',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: c.primary,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: c.textHint)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(backgroundColor: c.primary),
            child: const Text('نسخ الرابط'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(HakimSpacing.lg),
        decoration: BoxDecoration(
          color: c.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.borderCard),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: c.textPrimary,
                          ),
                        ),
                      ),
                      if (isAbnormal) ...[
                        const SizedBox(width: HakimSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: c.errorBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'غير طبيعي',
                            style: TextStyle(
                              color: c.error,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$hospital • $date',
                    style: TextStyle(fontSize: 12, color: c.textHint),
                  ),
                  const SizedBox(height: HakimSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAbnormal
                          ? c.error.withValues(alpha: 0.1)
                          : c.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isAbnormal ? c.error : c.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _showSecureShare(context, title),
              icon: Icon(Icons.share_outlined, color: c.primary, size: 20),
            ),
            Icon(Icons.chevron_left_rounded, color: c.textHint),
          ],
        ),
      ),
    );
  }
}
