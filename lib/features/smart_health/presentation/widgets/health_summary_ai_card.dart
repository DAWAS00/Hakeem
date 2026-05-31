import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../../shared/widgets/ai_disclaimer_banner.dart';
import '../../../smart_health/domain/models/health_summary.dart';

class HealthSummaryAiCard extends StatelessWidget {
  const HealthSummaryAiCard({
    super.key,
    required this.summary,
  });

  final HealthSummary summary;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: HakimRadius.bxl,
        side: BorderSide(color: c.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AiDisclaimerBanner(isVisible: !summary.isConfirmed),
          Padding(
            padding: const EdgeInsets.all(HakimSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(HakimSpacing.sm),
                      decoration: BoxDecoration(
                        color: c.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.insights_rounded,
                        color: c.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: HakimSpacing.md),
                    Text(
                      'ملخص صحتك الأسبوعي',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: c.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: HakimSpacing.md),
                Text(
                  summary.weekSummaryAr,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
