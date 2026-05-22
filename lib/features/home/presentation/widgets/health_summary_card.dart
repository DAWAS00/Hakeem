import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../domain/models/home_models.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: HakimColorScheme.of(context).sanad.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: HakimColorScheme.of(context).sanad.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      color: HakimColorScheme.of(context).sanad,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  summaryLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: HakimColorScheme.of(context).textHint,
                  ),
                ),
              ],
            ),
            const SizedBox(height: HakimSpacing.md),
            Row(
              children: vitals
                  .map((v) => Expanded(child: _VitalTile(vital: v)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _VitalTile extends StatelessWidget {
  const _VitalTile({required this.vital});
  final Vital vital;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: HakimColorScheme.of(context).bgBase,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          HugeIcon(icon: vital.icon, size: 18, color: vital.color),
          const SizedBox(height: 6),
          Text(
            vital.value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColorScheme.of(context).textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            vital.label,
            style: TextStyle(
              fontSize: 10,
              color: HakimColorScheme.of(context).textHint,
            ),
          ),
        ],
      ),
    );
  }
}
