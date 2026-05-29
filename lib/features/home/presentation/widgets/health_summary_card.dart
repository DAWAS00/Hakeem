import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../shared/widgets/hakim_icon.dart';
import '../../domain/models/home_models.dart';
import 'vital_details_sheet.dart';

class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({
    super.key,
    required this.vitals,
    required this.status,
    this.onTap,
    required this.summaryLabel,
  });

  final List<Vital> vitals;
  final String status;
  final VoidCallback? onTap;
  final String summaryLabel;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: c.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? c.border : c.borderCard, width: 0.5),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                // Title — rightmost in RTL
                Text(
                  summaryLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
                const Spacer(),
                // Status badge — leftmost in RTL
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? c.sanad.withValues(alpha: 0.12) : c.sanadBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: c.sanad.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? c.sanad : c.sanadText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: vitals
                  .map((v) => Expanded(child: _VitalTile(vital: v, isDark: isDark)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _VitalTile extends StatelessWidget {
  const _VitalTile({required this.vital, required this.isDark});

  final Vital vital;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: c.bgBase,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => VitalDetailsSheet(vital: vital),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark
                      ? vital.iconColor.withValues(alpha: 0.15)
                      : vital.iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: HakimIcon(vital.icon, size: 18, color: vital.iconColor),
              ),
              const SizedBox(height: 6),
              Text(
                vital.value,
                                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                vital.label,
                                style: TextStyle(fontSize: 10, color: c.textHint),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
