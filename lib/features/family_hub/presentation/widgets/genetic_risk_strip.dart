import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../domain/models/genetic_risk_flag.dart';

class GeneticRiskStrip extends StatelessWidget {
  const GeneticRiskStrip({super.key, required this.flags});

  final List<GeneticRiskFlag> flags;

  static const _disclaimerKey = 'genetic_disclaimer_shown';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
      child: Row(
        children: List.generate(flags.length, (i) {
          final flag = flags[i];
          return Padding(
            padding: const EdgeInsets.only(left: HakimSpacing.sm),
            child: _RiskChip(
              flag: flag,
              onTap: () => _handleTap(context, flag),
            )
                .animate(delay: Duration(milliseconds: 70 * i))
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.2, end: 0, duration: 300.ms, curve: Curves.easeOut),
          );
        }),
      ),
    );
  }

  Future<void> _handleTap(BuildContext context, GeneticRiskFlag flag) async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool(_disclaimerKey) ?? false;

    if (!context.mounted) return;

    if (!shown) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => _DisclaimerDialog(
          onConfirm: () async {
            await prefs.setBool(_disclaimerKey, true);
            if (ctx.mounted) Navigator.pop(ctx);
          },
        ),
      );
    }

    if (!context.mounted) return;
    _showDetailSheet(context, flag);
  }

  void _showDetailSheet(BuildContext context, GeneticRiskFlag flag) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _GeneticDetailSheet(flag: flag),
    );
  }
}

// ── Risk chip ─────────────────────────────────────────────────────────────────

class _RiskChip extends StatelessWidget {
  const _RiskChip({required this.flag, required this.onTap});
  final GeneticRiskFlag flag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final (color, icon, label) = switch (flag.riskLevel) {
      RiskLevel.high => (c.error, Icons.warning_rounded, 'مرتفع'),
      RiskLevel.moderate => (const Color(0xFFF59E0B), Icons.info_rounded, 'متوسط'),
      RiskLevel.low => (const Color(0xFF22C55E), Icons.check_circle_rounded, 'منخفض'),
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color + icon + text — never color alone (CLN-001)
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flag.condition,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                Text(
                  'خطر $label',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Non-dismissable disclaimer dialog ─────────────────────────────────────────

class _DisclaimerDialog extends StatelessWidget {
  const _DisclaimerDialog({required this.onConfirm});
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return AlertDialog(
      backgroundColor: c.bgCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: c.primary, size: 22),
          const SizedBox(width: HakimSpacing.sm),
          Text(
            'تنبيه مهم',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
      content: Text(
        'هذه المعلومات الجينية هي إرشادية فقط بناءً على التاريخ العائلي.\n\nهذا ليس تشخيصاً طبياً. استشر طبيبك دائماً قبل اتخاذ أي قرار صحي.',
        style: TextStyle(fontSize: 14, color: c.textSecondary, height: 1.6),
      ),
      actions: [
        FilledButton(
          onPressed: onConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: c.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('فهمت'),
        ),
      ],
    );
  }
}

// ── Detail bottom sheet ───────────────────────────────────────────────────────

class _GeneticDetailSheet extends StatelessWidget {
  const _GeneticDetailSheet({required this.flag});
  final GeneticRiskFlag flag;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final (color, icon, label) = switch (flag.riskLevel) {
      RiskLevel.high => (c.error, Icons.warning_rounded, 'مرتفع'),
      RiskLevel.moderate => (const Color(0xFFF59E0B), Icons.info_rounded, 'متوسط'),
      RiskLevel.low => (const Color(0xFF22C55E), Icons.check_circle_rounded, 'منخفض'),
    };

    return Container(
      decoration: BoxDecoration(
        color: c.bgBase,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(
        HakimSpacing.xl,
        HakimSpacing.lg,
        HakimSpacing.xl,
        HakimSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: c.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: HakimSpacing.xl),

          Row(
            children: [
              Expanded(
                child: Text(
                  flag.condition,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c.textPrimary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 13, color: color),
                    const SizedBox(width: 4),
                    Text(
                      'خطر $label',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: HakimSpacing.sm),

          Row(
            children: [
              Icon(Icons.group_rounded, size: 14, color: c.textHint),
              const SizedBox(width: 4),
              Text(
                '${flag.affectedRelativesCount} من أفراد العائلة مصابون',
                style: TextStyle(fontSize: 12, color: c.textHint),
              ),
            ],
          ),
          const SizedBox(height: HakimSpacing.xl),

          _Section(title: 'ما المقصود؟', content: flag.explanationAr, c: c),
          const SizedBox(height: HakimSpacing.lg),
          _Section(title: 'ماذا تفعل؟', content: flag.recommendationAr, c: c),
          const SizedBox(height: HakimSpacing.xl),

          // Mandatory disclaimer footer
          Container(
            padding: const EdgeInsets.all(HakimSpacing.md),
            decoration: BoxDecoration(
              color: c.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.borderCard),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 14, color: c.textHint),
                const SizedBox(width: HakimSpacing.sm),
                Expanded(
                  child: Text(
                    'هذا ليس تشخيصاً طبياً — استشر طبيبك دائماً',
                    style: TextStyle(fontSize: 11, color: c.textHint, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: HakimSpacing.lg),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.content, required this.c});
  final String title;
  final String content;
  final HakimColorScheme c;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: c.textPrimary)),
        const SizedBox(height: 6),
        Text(content, style: TextStyle(fontSize: 14, color: c.textSecondary, height: 1.6)),
      ],
    );
  }
}
