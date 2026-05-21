import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import 'package:hakeem/core/l10n/app_localizations.dart';
import '../signup_cta_button.dart';
import '../signup_gender_button.dart';
import '../signup_locked_step_row.dart';
import '../signup_sanad_banner.dart';
import '../signup_step_card.dart';
import '../signup_card_header.dart';
import '../signup_terms_footer.dart';
import '../signup_field_dec.dart';
import '../../field_label.dart';

class Step1Personal extends StatefulWidget {
  const Step1Personal({
    super.key,
    required this.fullNameCtrl,
    required this.nationalIdCtrl,
    required this.dobCtrl,
    required this.phoneCtrl,
    required this.gender,
    required this.onGenderChanged,
    required this.onNext,
  });

  final TextEditingController fullNameCtrl;
  final TextEditingController nationalIdCtrl;
  final TextEditingController dobCtrl;
  final TextEditingController phoneCtrl;
  final String? gender;
  final ValueChanged<String?> onGenderChanged;
  final VoidCallback onNext;

  @override
  State<Step1Personal> createState() => _Step1PersonalState();
}

class _Step1PersonalState extends State<Step1Personal> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1930),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
      builder: (ctx, child) => Theme(
        data: Theme.of(context).brightness == Brightness.dark ? ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: HakimColors.primary,
            surface: HakimColors.bgCard,
          ),
        ) : ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: HakimColors.primary,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      widget.dobCtrl.text =
          '${picked.day.toString().padLeft(2, '0')} / ${picked.month.toString().padLeft(2, '0')} / ${picked.year}';
    }
  }

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
            const SignupSanadBanner(),
            const SizedBox(height: HakimSpacing.lg),

            SignupStepCard(
              child: Column(
                children: [
                  SignupCardHeader(
                    icon: Icons.person_outline_rounded,
                    title: l10n.personalInfo,
                    subtitle: l10n.personalInfoSubtitle,
                  ),
                  const SizedBox(height: HakimSpacing.sm),

                  FieldLabel(l10n.fullName),
                  TextFormField(
                    controller: widget.fullNameCtrl,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColors.textPrimary, 
                        fontSize: 14),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? l10n.requiredField
                        : null,
                    decoration: signupFieldDec(context,
                        hint: l10n.fullNameHint,
                        prefixIcon: Icons.badge_outlined),
                  ),
                  const SizedBox(height: HakimSpacing.md),

                  FieldLabel(l10n.nationalId),
                  TextFormField(
                    controller: widget.nationalIdCtrl,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColors.textPrimary,
                        fontSize: 14,
                        letterSpacing: 1.5),
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.requiredField;
                      if (v.length != 10) return l10n.invalidNationalId;
                      return null;
                    },
                    decoration: signupFieldDec(context,
                        hint: 'X-XXXX-XXXXX',
                        prefixIcon: Icons.credit_card_outlined,
                        suffix: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.lock_outline,
                              size: 14, color: HakimColors.sanad),
                        )),
                  ),
                  const SizedBox(height: HakimSpacing.xs),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      '🔒 ${l10n.confirmAccuracy}',
                      style: const TextStyle(fontSize: 11, color: HakimColors.textHint),
                    ),
                  ),
                  const SizedBox(height: HakimSpacing.md),

                  FieldLabel(l10n.dob),
                  TextFormField(
                    controller: widget.dobCtrl,
                    readOnly: true,
                    onTap: _pickDate,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColors.textPrimary, 
                        fontSize: 14),
                    validator: (v) => (v == null || v.isEmpty)
                        ? l10n.requiredField
                        : null,
                    decoration: signupFieldDec(context,
                        hint: l10n.dobHint,
                        prefixIcon: Icons.calendar_month_outlined),
                  ),
                  const SizedBox(height: HakimSpacing.md),

                  FieldLabel(l10n.gender),
                  Row(
                    children: [
                      Expanded(
                        child: SignupGenderButton(
                          label: l10n.female,
                          icon: Icons.female_rounded,
                          selected: widget.gender == 'female',
                          onTap: () => widget.onGenderChanged('female'),
                        ),
                      ),
                      const SizedBox(width: HakimSpacing.sm),
                      Expanded(
                        child: SignupGenderButton(
                          label: l10n.male,
                          icon: Icons.male_rounded,
                          selected: widget.gender == 'male',
                          onTap: () => widget.onGenderChanged('male'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: HakimSpacing.md),

                  FieldLabel(l10n.phone),
                  TextFormField(
                    controller: widget.phoneCtrl,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColors.textPrimary,
                        fontSize: 14,
                        letterSpacing: 1.2),
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.requiredField;
                      if (v.length < 9) return l10n.invalidPhone;
                      return null;
                    },
                    decoration: signupFieldDec(context,
                      hint: '7X XXX XXXX',
                      prefixIcon: Icons.phone_outlined,
                      suffix: Container(
                        width: 54,
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark ? HakimColors.bgPrefix : HakimColors.bgPrefixLight,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Theme.of(context).dividerColor),
                        ),
                        alignment: Alignment.center,
                        child: const Text('+962',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: HakimColors.accent)),
                      ),
                    ),
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

            Column(
              children: [
                SignupLockedStepRow(number: '2', title: l10n.contactAndLocation),
                const SizedBox(height: HakimSpacing.sm),
                SignupLockedStepRow(number: '3', title: l10n.healthProfile),
                const SizedBox(height: HakimSpacing.sm),
                SignupLockedStepRow(number: '4', title: l10n.consentAndTerms),
              ],
            ),
            const SizedBox(height: HakimSpacing.xl),
          ],
        ),
      ),
    );
  }
}
