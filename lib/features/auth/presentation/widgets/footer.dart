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
          style: TextStyle(fontSize: 13, color: HakimColorScheme.of(context).textSecondary),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onRegisterTap,
          child: Text(
            l10n.registerNow,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: HakimColorScheme.of(context).accent,
              decoration: TextDecoration.underline,
              decorationColor: HakimColorScheme.of(context).accent,
            ),
          ),
        ),
      ],
    );
  }
}
