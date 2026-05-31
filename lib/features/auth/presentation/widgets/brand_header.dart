import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../shared/widgets/hakeem_heritage_logo.dart';
import 'trust_badge.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = HakimColorScheme.of(context);

    return Column(
      children: [
        const HakeemHeritageLogo(
          width: 200,
        ).animate().scale(
              duration: 400.ms,
              curve: Curves.elasticOut,
              begin: const Offset(0.8, 0.8),
              end: const Offset(1, 1),
            ),

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
