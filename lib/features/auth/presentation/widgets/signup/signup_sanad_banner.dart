import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import 'package:hakeem/core/l10n/app_localizations.dart';

class SignupSanadBanner extends StatelessWidget {
  const SignupSanadBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: HakimColors.sanadDark.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HakimColors.sanad.withValues(alpha: 0.4)),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: HakimSpacing.lg, vertical: HakimSpacing.md),
      child: Row(
        children: [
          const Icon(Icons.account_balance_outlined,
              size: 20, color: HakimColors.sanad),
          const SizedBox(width: HakimSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.registerWithSanad,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: HakimColors.sanad)),
                Text(l10n.sanadFillHint,
                    style:
                        const TextStyle(fontSize: 11, color: HakimColors.textHint)),
              ],
            ),
          ),
          const SizedBox(width: HakimSpacing.md),
          ElevatedButton(
            onPressed: () {}, // TODO: Sanad OAuth
            style: ElevatedButton.styleFrom(
              backgroundColor: HakimColors.sanad,
              foregroundColor: Colors.white,
              minimumSize: const Size(72, 34),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: Text(l10n.useSanad,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
