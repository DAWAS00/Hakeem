import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../smart_health/domain/models/lab_flag.dart';

class LabResultTile extends StatelessWidget {
  const LabResultTile({
    super.key,
    required this.lab,
    this.onTap,
  });

  final LabFlag lab;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: HakimRadius.blg,
      child: Container(
        padding: const EdgeInsets.all(HakimSpacing.md),
        decoration: BoxDecoration(
          color: c.bgCard,
          borderRadius: HakimRadius.blg,
          border: Border.all(color: c.borderCard),
          ),

        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: _getStatusColor(c, lab.status),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: HakimSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lab.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ),
                  Text(
                    'المستوى الطبيعي: ${lab.referenceRange}',
                    style: TextStyle(
                      fontSize: 11,
                      color: c.textHint,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (lab.trend != 0)
                      Icon(
                        lab.trend > 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                        size: 14,
                        color: c.textHint,
                      ),
                    const SizedBox(width: 4),
                    Text(
                      '${lab.value} ${lab.unit}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(c, lab.status),
                      ),
                    ),
                  ],
                ),
                Text(
                  _getStatusText(lab.status),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(c, lab.status),
                  ),
                ),
              ],
            ),
            const SizedBox(width: HakimSpacing.sm),
            Icon(
              Icons.chevron_left_rounded, // Arabic RTL
              color: c.textHint.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(HakimColorScheme c, LabStatus status) {
    return switch (status) {
      LabStatus.normal   => c.sanad,
      LabStatus.abnormal => c.warning,
      LabStatus.critical => c.error,
    };
  }

  String _getStatusText(LabStatus status) {
    return switch (status) {
      LabStatus.normal   => 'طبيعي',
      LabStatus.abnormal => 'غير طبيعي',
      LabStatus.critical => 'حرج',
    };
  }
}
