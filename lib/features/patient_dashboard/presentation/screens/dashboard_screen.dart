import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import 'package:hakeem/core/l10n/app_localizations.dart';
import 'package:hakeem/features/home/domain/models/home_models.dart';
import 'package:hakeem/features/home/presentation/providers/home_provider.dart';

// ── Mock vitals data ─────────────────────────────────────────────────────────

class _Vital {
  const _Vital({
    required this.label,
    required this.value,
    required this.unit,
    required this.trend,
    required this.color,
    required this.spots,
    required this.isAbnormal,
    required this.icon,
  });
  final String label;
  final String value;
  final String unit;
  final _Trend trend;
  final Color color;
  final List<FlSpot> spots;
  final bool isAbnormal;
  final IconData icon;
}

enum _Trend { up, down, stable }

const _vitals = [
  _Vital(
    label: 'نبضات القلب',
    value: '105',
    unit: 'bpm',
    trend: _Trend.up,
    color: Color(0xFFEF4444),
    isAbnormal: true,
    icon: Icons.favorite_rounded,
    spots: [
      FlSpot(0, 70), FlSpot(1, 75), FlSpot(2, 72),
      FlSpot(3, 85), FlSpot(4, 80), FlSpot(5, 105),
    ],
  ),
  _Vital(
    label: 'ضغط الدم',
    value: '120/80',
    unit: 'mmHg',
    trend: _Trend.stable,
    color: Color(0xFF4C6A8D),
    isAbnormal: false,
    icon: Icons.speed_rounded,
    spots: [
      FlSpot(0, 110), FlSpot(1, 115), FlSpot(2, 120),
      FlSpot(3, 118), FlSpot(4, 122), FlSpot(5, 120),
    ],
  ),
  _Vital(
    label: 'مستوى السكر',
    value: '95',
    unit: 'mg/dL',
    trend: _Trend.stable,
    color: Color(0xFFF59E0B),
    isAbnormal: false,
    icon: Icons.water_drop_rounded,
    spots: [
      FlSpot(0, 90), FlSpot(1, 100), FlSpot(2, 92),
      FlSpot(3, 98), FlSpot(4, 95), FlSpot(5, 95),
    ],
  ),
  _Vital(
    label: 'تشبع الأكسجين',
    value: '98',
    unit: '%',
    trend: _Trend.stable,
    color: Color(0xFF22C55E),
    isAbnormal: false,
    icon: Icons.air_rounded,
    spots: [
      FlSpot(0, 97), FlSpot(1, 98), FlSpot(2, 98),
      FlSpot(3, 97), FlSpot(4, 99), FlSpot(5, 98),
    ],
  ),
];

const _healthScore = 68;

// ── Screen ───────────────────────────────────────────────────────────────────

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  static const bool _isTachycardic = true;

  @override
  void initState() {
    super.initState();
    if (_isTachycardic) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(mascotStateProvider.notifier).set(MascotState.concerned);
        }
      });
    }
  }

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
        error: (e, s) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: c.error),
              const SizedBox(height: HakimSpacing.md),
              Text(l10n.errorLoadingData,
                  style: TextStyle(color: c.textSecondary)),
              const SizedBox(height: HakimSpacing.md),
              FilledButton(
                onPressed: () => ref.invalidate(homeProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () => ref.read(homeProvider.notifier).refresh(),
          color: c.primary,
          backgroundColor: c.bgCard,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              HakimSpacing.xl,
              HakimSpacing.md,
              HakimSpacing.xl,
              HakimSpacing.xxxl,
            ),
            children: [
              // ── Health Score Arc ──────────────────────────────────────
              _HealthScoreCard(score: _healthScore)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.05, end: 0),

              const SizedBox(height: HakimSpacing.xl),

              // ── Clinical alert (if abnormal) ──────────────────────────
              if (_isTachycardic) ...[
                _ClinicalAlertCard(
                  onConsult: () => context.push('/assistant'),
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 100.ms)
                    .slideY(begin: 0.05, end: 0),
                const SizedBox(height: HakimSpacing.xl),
              ],

              // ── Vitals 2×2 grid ───────────────────────────────────────
              Text(
                'المؤشرات الحيوية',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 150.ms),

              const SizedBox(height: HakimSpacing.md),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: HakimSpacing.md,
                  mainAxisSpacing: HakimSpacing.md,
                  childAspectRatio: 0.95,
                ),
                itemCount: _vitals.length,
                itemBuilder: (context, i) => _VitalGridCard(vital: _vitals[i])
                    .animate()
                    .fadeIn(duration: 300.ms, delay: Duration(milliseconds: 180 + i * 60))
                    .slideY(begin: 0.08, end: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Health Score Card ─────────────────────────────────────────────────────────

class _HealthScoreCard extends StatefulWidget {
  const _HealthScoreCard({required this.score});
  final int score;

  @override
  State<_HealthScoreCard> createState() => _HealthScoreCardState();
}

class _HealthScoreCardState extends State<_HealthScoreCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scoreAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _scoreAnim = Tween<double>(begin: 0, end: widget.score.toDouble())
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final score = widget.score;

    final (arcColor, statusLabel, statusIcon) = score >= 80
        ? (const Color(0xFF22C55E), 'ممتازة', Icons.sentiment_very_satisfied_rounded)
        : score >= 60
            ? (const Color(0xFFF59E0B), 'تحتاج متابعة', Icons.sentiment_neutral_rounded)
            : (c.error, 'تنبيه طبي', Icons.sentiment_very_dissatisfied_rounded);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        HakimSpacing.xl,
        HakimSpacing.xl,
        HakimSpacing.xl,
        HakimSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            arcColor.withValues(alpha: 0.12),
            arcColor.withValues(alpha: 0.04),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: arcColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          // Arc gauge
          SizedBox(
            width: 190,
            height: 110,
            child: AnimatedBuilder(
              animation: _scoreAnim,
              builder: (context2, child) => CustomPaint(
                painter: _ArcGaugePainter(
                  progress: _scoreAnim.value / 100,
                  arcColor: arcColor,
                  trackColor: arcColor.withValues(alpha: 0.12),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        '${_scoreAnim.value.toInt()}',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: arcColor,
                          height: 1,
                        ),
                      ),
                      Text(
                        'من 100',
                        style: TextStyle(fontSize: 11, color: c.textHint),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: HakimSpacing.md),

          // Status row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(statusIcon, size: 18, color: arcColor),
              const SizedBox(width: 6),
              Text(
                'حالتك الصحية — $statusLabel',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: HakimSpacing.sm),

          Text(
            'آخر تحديث: اليوم 09:30',
            style: TextStyle(fontSize: 11, color: c.textHint),
          ),

          const SizedBox(height: HakimSpacing.md),

          // Score breakdown chips
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ScoreChip(label: 'نبضات', value: '↑ مرتفعة', color: c.error),
              const SizedBox(width: HakimSpacing.sm),
              _ScoreChip(label: 'ضغط الدم', value: '✓ طبيعي', color: const Color(0xFF22C55E)),
              const SizedBox(width: HakimSpacing.sm),
              _ScoreChip(label: 'السكر', value: '✓ طبيعي', color: const Color(0xFF22C55E)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.borderCard),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: c.textHint)),
          Text(
            value,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}

// ── Arc Gauge Painter ─────────────────────────────────────────────────────────

class _ArcGaugePainter extends CustomPainter {
  _ArcGaugePainter({
    required this.progress,
    required this.arcColor,
    required this.trackColor,
  });

  final double progress;
  final Color arcColor;
  final Color trackColor;

  static const _sweepAngle = 200.0; // degrees
  static const _startAngle = 170.0; // degrees from right (3 o'clock)

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.9);
    final radius = size.width * 0.46;
    const strokeWidth = 14.0;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      _toRad(_startAngle),
      _toRad(_sweepAngle),
      false,
      trackPaint,
    );

    // Progress
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = arcColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        _toRad(_startAngle),
        _toRad(_sweepAngle * progress),
        false,
        progressPaint,
      );
    }
  }

  double _toRad(double degrees) => degrees * math.pi / 180;

  @override
  bool shouldRepaint(_ArcGaugePainter old) =>
      old.progress != progress || old.arcColor != arcColor;
}

// ── Vital Grid Card ───────────────────────────────────────────────────────────

class _VitalGridCard extends StatelessWidget {
  const _VitalGridCard({required this.vital});
  final _Vital vital;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final (trendIcon, trendLabel, trendColor) = switch (vital.trend) {
      _Trend.up   => (Icons.trending_up_rounded,   'ارتفاع', vital.isAbnormal ? c.error : const Color(0xFF22C55E)),
      _Trend.down => (Icons.trending_down_rounded, 'انخفاض', vital.isAbnormal ? c.error : const Color(0xFF22C55E)),
      _Trend.stable => (Icons.trending_flat_rounded, 'مستقر', c.textHint),
    };

    Widget card = Container(
      padding: const EdgeInsets.all(HakimSpacing.md),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: vital.isAbnormal
              ? c.error.withValues(alpha: 0.4)
              : c.borderCard,
          width: vital.isAbnormal ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (vital.isAbnormal ? c.error : Colors.black)
                .withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + abnormal badge
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: vital.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(vital.icon, size: 16, color: vital.color),
              ),
              const Spacer(),
              if (vital.isAbnormal)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: c.errorBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 10, color: c.error),
                      const SizedBox(width: 2),
                      Text(
                        'تنبيه',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: c.error,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: HakimSpacing.sm),

          // Vital name
          Text(
            vital.label,
            style: TextStyle(
              fontSize: 11,
              color: c.textHint,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2),

          // Value
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: vital.value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: vital.isAbnormal ? c.error : c.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  TextSpan(
                    text: ' ${vital.unit}',
                    style: TextStyle(fontSize: 10, color: c.textHint),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Sparkline
          SizedBox(
            height: 42,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: vital.spots,
                    isCurved: true,
                    color: vital.color,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, _) =>
                          spot == vital.spots.last,
                      getDotPainter: (spot, pct, bar, idx) =>
                          FlDotCirclePainter(
                            radius: 3,
                            color: vital.color,
                            strokeWidth: 0,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: vital.color.withValues(alpha: 0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Trend row — color + icon + text (CLN-001)
          Row(
            children: [
              Icon(trendIcon, size: 13, color: trendColor),
              const SizedBox(width: 3),
              Text(
                trendLabel,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: trendColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (vital.isAbnormal) {
      card = card
          .animate(onPlay: (ctrl) => ctrl.repeat(reverse: true))
          .shimmer(
            duration: 2000.ms,
            color: c.error.withValues(alpha: 0.06),
          );
    }

    return card;
  }
}

// ── Clinical Alert Card ───────────────────────────────────────────────────────

class _ClinicalAlertCard extends StatelessWidget {
  const _ClinicalAlertCard({required this.onConsult});
  final VoidCallback onConsult;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Container(
      padding: const EdgeInsets.all(HakimSpacing.lg),
      decoration: BoxDecoration(
        color: c.errorBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.error.withValues(alpha: 0.35), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: c.error, size: 20),
              const SizedBox(width: HakimSpacing.sm),
              Text(
                'تنبيه طبي',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: c.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: HakimSpacing.sm),
          Text(
            'نبضات القلب مرتفعة (105 bpm). يُنصح باستشارة مساعد حكيم أو مراجعة الطبيب.',
            style: TextStyle(fontSize: 13, color: c.textSecondary, height: 1.5),
          ),
          const SizedBox(height: HakimSpacing.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onConsult,
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 15),
              label: const Text('استشارة حكيم AI'),
              style: FilledButton.styleFrom(
                backgroundColor: c.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
