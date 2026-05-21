import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'trust_badge.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.circle,
            border: Border.all(color: HakimColors.border, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x304C6A8D),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedHospital02,
            size: 32,
            color: HakimColors.accent,
          ),
        ).animate().scale(
              duration: 400.ms,
              curve: Curves.elasticOut,
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
            ),

        const SizedBox(height: HakimSpacing.sm),

        Text(
          l10n.appTitle,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: HakimColors.accent,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(delay: 150.ms),

        const SizedBox(height: HakimSpacing.xs),

        Text(
          l10n.appSlogan,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).textTheme.bodySmall?.color ?? HakimColors.textSecondary,
          ),
        ).animate().fadeIn(delay: 200.ms),

        const SizedBox(height: HakimSpacing.md),

        const TrustBadge().animate().fadeIn(delay: 300.ms),
      ],
    );
  }
}
