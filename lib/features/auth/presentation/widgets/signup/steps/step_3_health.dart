import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/l10n/app_localizations.dart';
import '../signup_cta_button.dart';
import '../signup_locked_step_row.dart';
import '../signup_step_card.dart';
import '../signup_card_header.dart';
import '../signup_terms_footer.dart';
import '../signup_field_dec.dart';
import '../../field_label.dart';

class Step3Health extends StatefulWidget {
  const Step3Health({
    super.key,
    required this.bloodType,
    required this.chronicDiseases,
    required this.allergiesCtrl,
    required this.heightCtrl,
    required this.weightCtrl,
    required this.medicationsCtrl,
    required this.onBloodTypeChanged,
    required this.onDiseaseToggled,
    required this.onNext,
  });
  final String? bloodType;
  final List<String> chronicDiseases;
  final TextEditingController allergiesCtrl;
  final TextEditingController heightCtrl;
  final TextEditingController weightCtrl;
  final TextEditingController medicationsCtrl;
  final ValueChanged<String?> onBloodTypeChanged;
  final ValueChanged<String> onDiseaseToggled;
  final VoidCallback onNext;

  @override
  State<Step3Health> createState() => _Step3HealthState();
}

class _Step3HealthState extends State<Step3Health> {
  final _formKey = GlobalKey<FormState>();
  
  static const _bloodTypes = ['A+', 'A−', 'B+', 'B−', 'AB+', 'AB−', 'O+', 'O−'];
  static const _diseaseOptions = ['لا يوجد', 'السكر', 'ضغط الدم', 'القلب', 'الربو', 'الكلى'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(HakimSpacing.xl),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SignupStepCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SignupCardHeader(
                    icon: Icons.favorite_border_rounded,
                    title: l10n.healthProfile,
                    subtitle: l10n.healthSubtitle,
                  ),
                  const SizedBox(height: HakimSpacing.sm),

                  FieldLabel(l10n.bloodType),
                  DropdownButtonFormField<String>(
                    initialValue: widget.bloodType,
                    decoration: signupFieldDec(context,
                        hint: l10n.bloodTypeHint,
                        prefixIcon: Icons.water_drop_outlined),
                    dropdownColor: Theme.of(context).cardColor,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColorScheme.of(context).textPrimary, 
                        fontSize: 14),
                    icon: Icon(Icons.keyboard_arrow_down_rounded,
                        color: HakimColorScheme.of(context).textHint),
                    onChanged: widget.onBloodTypeChanged,
                    items: _bloodTypes
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: HakimSpacing.md),

                  FieldLabel(l10n.chronicDiseases),
                  Wrap(
                    spacing: HakimSpacing.sm,
                    runSpacing: HakimSpacing.sm,
                    children: [
                      ..._diseaseOptions.map((d) {
                        final selected =
                            widget.chronicDiseases.contains(d);
                        return GestureDetector(
                          onTap: () => widget.onDiseaseToggled(d),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? HakimColorScheme.of(context).primary
                                  : (HakimColorScheme.of(context).bgInput),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: selected
                                      ? HakimColorScheme.of(context).borderFocus
                                      : Theme.of(context).dividerColor),
                            ),
                            child: Text(d,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: selected
                                        ? Colors.white
                                        : HakimColorScheme.of(context).textHint,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w400)),
                          ),
                        );
                      }),
                      GestureDetector(
                        onTap: () {}, // TODO: show add chip dialog
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: HakimColorScheme.of(context).bgInput,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Theme.of(context).dividerColor,
                                style: BorderStyle.solid),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add,
                                  size: 14, color: HakimColorScheme.of(context).accent),
                              const SizedBox(width: 4),
                              Text(l10n.add,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: HakimColorScheme.of(context).accent)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: HakimSpacing.md),

                  FieldLabel(l10n.allergies),
                  TextFormField(
                    controller: widget.allergiesCtrl,
                    maxLines: 3,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColorScheme.of(context).textPrimary, 
                        fontSize: 13),
                    decoration: signupFieldDec(context,
                        hint: l10n.allergiesHint),
                  ),
                  const SizedBox(height: HakimSpacing.md),

                  FieldLabel(l10n.heightAndWeight),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.height,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: HakimColorScheme.of(context).textSecondary)),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: widget.heightCtrl,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColorScheme.of(context).textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                              decoration: signupFieldDec(context, hint: '170'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: HakimSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.weight,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: HakimColorScheme.of(context).textSecondary)),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: widget.weightCtrl,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColorScheme.of(context).textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                              decoration: signupFieldDec(context, hint: '70'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: HakimSpacing.md),

                  FieldLabel(l10n.currentMedications),
                  TextFormField(
                    controller: widget.medicationsCtrl,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColorScheme.of(context).textPrimary, 
                        fontSize: 14),
                    decoration: signupFieldDec(context,
                        hint: l10n.medicationsHint,
                        prefixIcon: Icons.medication_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(height: HakimSpacing.lg),

            SignupCtaButton(
                label: l10n.next,
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onNext();
                  }
                }),
            const SizedBox(height: HakimSpacing.sm),
            const SignupTermsFooter(),
            const SizedBox(height: HakimSpacing.lg),

            SignupLockedStepRow(number: '4', title: l10n.consentAndTerms),
            const SizedBox(height: HakimSpacing.xl),
          ],
        ),
      ),
    );
  }
}
