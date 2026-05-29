import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import 'package:hakeem/core/l10n/app_localizations.dart';
import 'package:hakeem/features/home/presentation/providers/home_provider.dart';
import 'package:hakeem/features/home/domain/models/home_models.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final c = HakimColorScheme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final homeState = ref.watch(homeProvider);
return Scaffold(
  backgroundColor: c.bgBase,
  appBar: AppBar(
    backgroundColor: c.bgBase,
    elevation: 0,
    centerTitle: true,
    title: Text(
      l10n.healthSummary,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: c.textPrimary,
      ),
    ),
  ),
  body: homeState.when(
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, s) => Center(child: Text(e.toString())),
    data: (state) {
      // Task 007: Simulation of abnormal state
      final isTachycardic = true; // Simulated abnormal heart rate
      if (isTachycardic) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(mascotStateProvider.notifier).set(MascotState.concerned);
        });
      }

      return ListView(
        padding: const EdgeInsets.all(HakimSpacing.xl),
        children: [
          if (isTachycardic) ...[
            _buildClinicalAlert(context),
            const SizedBox(height: HakimSpacing.lg),
          ],
          _buildStatusHeader(context, state.healthStatus),
          const SizedBox(height: HakimSpacing.xl),
...
Widget _buildStatusHeader(BuildContext context, String status) {
...
}

Widget _buildClinicalAlert(BuildContext context) {
final c = HakimColorScheme.of(context);
return Container(
  padding: const EdgeInsets.all(HakimSpacing.lg),
  decoration: BoxDecoration(
    color: c.error.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: c.error.withValues(alpha: 0.3), width: 2),
  ),
  child: Column(
    children: [
      Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: c.error, size: 28),
          const SizedBox(width: HakimSpacing.md),
          Expanded(
            child: Text(
              'تنبيه طبي: تم رصد ارتفاع في نبضات القلب (105 bpm). يرجى استشارة المساعد الطبي.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: c.error,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: HakimSpacing.md),
      SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () => context.push('/assistant'),
          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
          label: const Text('استشارة المساعد الذكي الآن'),
          style: FilledButton.styleFrom(
            backgroundColor: c.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    ],
  ),
);
}

Widget _buildVitalChart(
              unit: 'bpm',
              color: Colors.redAccent,
              spots: [
                const FlSpot(0, 70),
                const FlSpot(1, 75),
                const FlSpot(2, 72),
                const FlSpot(3, 85),
                const FlSpot(4, 80),
                const FlSpot(5, 82),
              ],
            ),
            const SizedBox(height: HakimSpacing.lg),
            
            _buildVitalChart(
              context,
              title: 'ضغط الدم',
              value: '120/80',
              unit: 'mmHg',
              color: Colors.blueAccent,
              spots: [
                const FlSpot(0, 110),
                const FlSpot(1, 115),
                const FlSpot(2, 120),
                const FlSpot(3, 118),
                const FlSpot(4, 122),
                const FlSpot(5, 120),
              ],
            ),
            const SizedBox(height: HakimSpacing.lg),
            
            _buildVitalChart(
              context,
              title: 'مستوى السكر',
              value: '95',
              unit: 'mg/dL',
              color: Colors.orangeAccent,
              spots: [
                const FlSpot(0, 90),
                const FlSpot(1, 100),
                const FlSpot(2, 92),
                const FlSpot(3, 98),
                const FlSpot(4, 95),
                const FlSpot(5, 95),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context, String status) {
    final c = HakimColorScheme.of(context);
    return Container(
      padding: const EdgeInsets.all(HakimSpacing.lg),
      decoration: BoxDecoration(
        color: c.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: c.primary, size: 32),
          const SizedBox(width: HakimSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حالتك الصحية الحالية',
                  style: TextStyle(
                    fontSize: 14,
                    color: c.textSecondary,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalChart(
    BuildContext context, {
    required String title,
    required String value,
    required String unit,
    required Color color,
    required List<FlSpot> spots,
  }) {
    final c = HakimColorScheme.of(context);
    return Container(
      padding: const EdgeInsets.all(HakimSpacing.lg),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.borderCard),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: c.textPrimary,
                      ),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: unit,
                      style: TextStyle(
                        fontSize: 12,
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: HakimSpacing.xl),
          SizedBox(
            height: 100,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowArea: BarAreaData(
                      show: true,
                      color: color.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
