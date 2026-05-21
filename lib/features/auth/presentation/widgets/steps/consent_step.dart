import 'package:flutter/material.dart';
import '../../../../../core/constants/hakim_colors.dart';
import '../../../../../core/constants/hakim_spacing.dart';
import '../../../../../core/l10n/app_localizations.dart';
import 'step_section_header.dart';

class ConsentStep extends StatelessWidget {
  const ConsentStep({
    super.key,
    required this.acceptTerms,
    required this.enableNotifications,
    required this.confirmAccuracy,
    required this.onAcceptTermsChanged,
    required this.onEnableNotificationsChanged,
    required this.onConfirmAccuracyChanged,
  });

  final bool acceptTerms;
  final bool enableNotifications;
  final bool confirmAccuracy;
  final ValueChanged<bool> onAcceptTermsChanged;
  final ValueChanged<bool> onEnableNotificationsChanged;
  final ValueChanged<bool> onConfirmAccuracyChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StepSectionHeader(
          title: l10n.consentAndTerms,
          subtitle: l10n.consentSubtitle,
        ),

        const SizedBox(height: HakimSpacing.xl),

        _ConsentTile(
          icon: Icons.gavel_outlined,
          title: l10n.acceptTerms,
          subtitle: l10n.acceptTermsSubtitle,
          value: acceptTerms,
          onChanged: onAcceptTermsChanged,
          required: true,
        ),

        const SizedBox(height: HakimSpacing.md),

        _ConsentTile(
          icon: Icons.notifications_outlined,
          title: l10n.enableNotifications,
          subtitle: l10n.notificationsSubtitle,
          value: enableNotifications,
          onChanged: onEnableNotificationsChanged,
        ),

        const SizedBox(height: HakimSpacing.md),

        _ConsentTile(
          icon: Icons.fact_check_outlined,
          title: l10n.confirmAccuracy,
          subtitle: l10n.accuracySubtitle,
          value: confirmAccuracy,
          onChanged: onConfirmAccuracyChanged,
          required: true,
        ),

        const SizedBox(height: HakimSpacing.xl),

        // Info banner
        Container(
          padding: const EdgeInsets.all(HakimSpacing.md),
          decoration: BoxDecoration(
            color: HakimColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: HakimColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 18,
                color: HakimColors.accent,
              ),
              const SizedBox(width: HakimSpacing.sm),
              Expanded(
                child: Text(
                  l10n.finalStepInfo,
                  style: const TextStyle(
                    fontSize: 12,
                    color: HakimColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: HakimSpacing.lg),

        // Terms & privacy links
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              l10n.byContinuing,
              style: const TextStyle(
                fontSize: 12,
                color: HakimColors.textHint,
              ),
            ),
            GestureDetector(
              child: Text(
                l10n.termsOfUse,
                style: const TextStyle(
                  fontSize: 12,
                  color: HakimColors.accent,
                  decoration: TextDecoration.underline,
                  decorationColor: HakimColors.accent,
                ),
              ),
            ),
            Text(
              l10n.and,
              style: const TextStyle(fontSize: 12, color: HakimColors.textHint),
            ),
            GestureDetector(
              child: Text(
                l10n.privacyPolicy,
                style: const TextStyle(
                  fontSize: 12,
                  color: HakimColors.accent,
                  decoration: TextDecoration.underline,
                  decorationColor: HakimColors.accent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ConsentTile extends StatelessWidget {
  const _ConsentTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.required = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(HakimSpacing.md),
        decoration: BoxDecoration(
          color: value
              ? HakimColors.primary.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value ? HakimColors.primary : HakimColors.border,
            width: value ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: value ? HakimColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: value ? HakimColors.primary : HakimColors.border,
                  width: 1.5,
                ),
              ),
              child: value
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),

            const SizedBox(width: HakimSpacing.md),

            // Icon + text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 16, color: HakimColors.accent),
                      const SizedBox(width: HakimSpacing.xs),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: value
                                ? HakimColors.accent
                                : Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      if (required)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: HakimColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'مطلوب',
                            style: TextStyle(
                              fontSize: 10,
                              color: HakimColors.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: HakimSpacing.xs),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: HakimColors.textHint,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
