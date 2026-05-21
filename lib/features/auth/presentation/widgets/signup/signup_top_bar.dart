import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/constants/hakim_colors.dart';
import '../../../../../core/constants/hakim_spacing.dart';
import '../../../../../core/l10n/app_localizations.dart';

class SignupTopBar extends StatelessWidget {
  const SignupTopBar({super.key, required this.step, required this.onBack});
  final int step;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 56,
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBack,
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              size: 20, 
              color: HakimColors.accent,
            ),
          ),

          const Spacer(),

          // Title
          Text(
            l10n.signup,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleMedium?.color ?? HakimColors.textPrimary,
            ),
          ),

          const Spacer(),

          // Step badge
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: HakimSpacing.sm, vertical: 3),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Text(
              '${step + 1} / 4',
              style: const TextStyle(
                  fontSize: 12,
                  color: HakimColors.accent,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
