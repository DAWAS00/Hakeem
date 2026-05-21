import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import 'package:hakeem/core/l10n/app_localizations.dart';
import '../signup_step_card.dart';
import '../signup_card_header.dart';
import '../signup_consent_widgets.dart';

class Step4Consent extends StatelessWidget {
  const Step4Consent({
    super.key,
    required this.acceptedTerms,
    required this.notificationsOn,
    required this.dataAccuracy,
    required this.onTermsChanged,
    required this.onNotifChanged,
    required this.onDataChanged,
    required this.onFinish,
  });

  final bool acceptedTerms;
  final bool notificationsOn;
  final bool dataAccuracy;
  final ValueChanged<bool?> onTermsChanged;
  final ValueChanged<bool> onNotifChanged;
  final ValueChanged<bool?> onDataChanged;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canFinish = acceptedTerms && dataAccuracy;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(HakimSpacing.xl),
      child: Column(
        children: [
          SignupStepCard(
            child: Column(
              children: [
                SignupCardHeader(
                  icon: Icons.verified_user_outlined,
                  title: l10n.consentAndTerms,
                  subtitle: l10n.consentSubtitle,
                ),
                const SizedBox(height: HakimSpacing.sm),

                SignupConsentCheckRow(
                  title: l10n.acceptTerms,
                  subtitle: l10n.acceptTermsSubtitle,
                  value: acceptedTerms,
                  onChanged: onTermsChanged,
                  icon: Icons.article_outlined,
                ),
                const SizedBox(height: HakimSpacing.sm),
                Divider(color: Theme.of(context).dividerColor),
                const SizedBox(height: HakimSpacing.sm),

                SignupConsentToggleRow(
                  title: l10n.enableNotifications,
                  subtitle: l10n.notificationsSubtitle,
                  value: notificationsOn,
                  onChanged: onNotifChanged,
                  icon: Icons.notifications_outlined,
                ),
                const SizedBox(height: HakimSpacing.sm),
                Divider(color: Theme.of(context).dividerColor),
                const SizedBox(height: HakimSpacing.sm),

                SignupConsentCheckRow(
                  title: l10n.confirmAccuracy,
                  subtitle: l10n.accuracySubtitle,
                  value: dataAccuracy,
                  onChanged: onDataChanged,
                  icon: Icons.fact_check_outlined,
                ),
                const SizedBox(height: HakimSpacing.md),

                Container(
                  padding: const EdgeInsets.all(HakimSpacing.md),
                  decoration: BoxDecoration(
                    color: HakimColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: HakimColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 16, color: HakimColors.accent),
                      const SizedBox(width: HakimSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n.finalStepInfo,
                          style: const TextStyle(
                              fontSize: 12, color: HakimColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: HakimSpacing.lg),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: canFinish ? onFinish : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: HakimColors.sanad,
                disabledBackgroundColor:
                    HakimColors.sanad.withValues(alpha: 0.35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 20),
                  const SizedBox(width: HakimSpacing.sm),
                  Text(l10n.finishRegistration,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),

          if (!canFinish) ...[
            const SizedBox(height: HakimSpacing.sm),
            Text(
              l10n.finishRegistrationError,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: HakimColors.textHint),
            ),
          ],

          const SizedBox(height: HakimSpacing.xl),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: HakimSpacing.lg,
            children: [
              Text(l10n.privacyPolicy,
                  style: const TextStyle(
                      fontSize: 12,
                      color: HakimColors.accent,
                      decoration: TextDecoration.underline,
                      decorationColor: HakimColors.accent)),
              Text(l10n.termsOfUse,
                  style: const TextStyle(
                      fontSize: 12,
                      color: HakimColors.accent,
                      decoration: TextDecoration.underline,
                      decorationColor: HakimColors.accent)),
              Text(l10n.contactUs,
                  style: const TextStyle(
                      fontSize: 12,
                      color: HakimColors.accent,
                      decoration: TextDecoration.underline,
                      decorationColor: HakimColors.accent)),
            ],
          ),
          const SizedBox(height: HakimSpacing.sm),
          Text(l10n.rightsReserved,
              style: const TextStyle(fontSize: 11, color: HakimColors.textHint)),
          const SizedBox(height: HakimSpacing.xl),
        ],
      ),
    );
  }
}
