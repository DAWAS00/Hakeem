import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/hakim_icons.dart';
import '../../../../shared/widgets/hakim_icon.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'trust_badge.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = HakimColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: isDark ? c.bgDeep : c.infoBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.info, width: 1),
          ),
          child: Center(
            child: HakimIcon(
              HakimIcons.hospital02,
              size: 30,
              color: c.info,
            ),
          ),
        ).animate().scale(
              duration: 400.ms,
              curve: Curves.elasticOut,
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
            ),

        const SizedBox(height: 12),

        Text(
          l10n.appTitle,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: isDark ? Colors.white : c.textPrimary,
          ),
        ).animate().fadeIn(delay: 150.ms),

        const SizedBox(height: 4),

        Text(
          l10n.appSlogan,
          style: TextStyle(fontSize: 13, color: c.textHint),
        ).animate().fadeIn(delay: 200.ms),

        const SizedBox(height: 12),

        const TrustBadge().animate().fadeIn(delay: 300.ms),
      ],
    );
  }
}
