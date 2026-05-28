import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import 'package:hakeem/core/l10n/app_localizations.dart';

class SignupTermsFooter extends StatelessWidget {
  const SignupTermsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
        padding: const EdgeInsets.only(top: HakimSpacing.md),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(fontSize: 11, color: HakimColorScheme.of(context).textHint),
            children: [
              TextSpan(text: l10n.byContinuing),
              TextSpan(
                text: l10n.termsOfUse,
                style: TextStyle(
                    color: HakimColorScheme.of(context).accent,
                    decoration: TextDecoration.underline,
                    decorationColor: HakimColorScheme.of(context).accent),
              ),
              TextSpan(text: l10n.and),
              TextSpan(
                text: l10n.privacyPolicy,
                style: TextStyle(
                    color: HakimColorScheme.of(context).accent,
                    decoration: TextDecoration.underline,
                    decorationColor: HakimColorScheme.of(context).accent),
              ),
            ],
          ),
        ),
      );
  }
}

