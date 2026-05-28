import 'package:flutter/material.dart';
import '../../../../../core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import '../../../../../core/constants/hakim_icons.dart';
import '../../../../../shared/widgets/hakim_icon.dart';
import '../../../../../core/l10n/app_localizations.dart';

class SignupSanadBanner extends StatelessWidget {
  const SignupSanadBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: HakimColorScheme.of(context).sanadDark.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HakimColorScheme.of(context).sanad.withValues(alpha: 0.4)),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: HakimSpacing.lg, vertical: HakimSpacing.md),
      child: Row(
        children: [
          HakimIcon(HakimIcons.accountBalanceOutlined,
              size: 20, color: HakimColorScheme.of(context).sanad),
          const SizedBox(width: HakimSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.registerWithSanad,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: HakimColorScheme.of(context).sanad)),
                Text(l10n.sanadFillHint,
                    style:
                        TextStyle(fontSize: 11, color: HakimColorScheme.of(context).textHint)),
              ],
            ),
          ),
          const SizedBox(width: HakimSpacing.md),
          ElevatedButton(
            onPressed: () {}, // TODO: Sanad OAuth
            style: ElevatedButton.styleFrom(
              backgroundColor: HakimColorScheme.of(context).sanad,
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

