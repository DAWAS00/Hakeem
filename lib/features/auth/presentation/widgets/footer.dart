import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/l10n/app_localizations.dart';

class Footer extends StatelessWidget {
  const Footer({super.key, required this.onRegisterTap});

  final VoidCallback onRegisterTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.dontHaveAccount,
          style: const TextStyle(fontSize: 13, color: HakimColors.textSecondary),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onRegisterTap,
          child: Text(
            l10n.registerNow,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: HakimColors.accent,
              decoration: TextDecoration.underline,
              decorationColor: HakimColors.accent,
            ),
          ),
        ),
      ],
    );
  }
}
