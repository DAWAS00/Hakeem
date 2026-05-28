import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import 'package:hakeem/core/constants/hakim_icons.dart';
import 'package:hakeem/shared/widgets/hakim_icon.dart';
import 'package:hakeem/core/l10n/app_localizations.dart';
import '../signup_cta_button.dart';
import '../signup_locked_step_row.dart';
import '../signup_step_card.dart';
import '../signup_card_header.dart';
import '../signup_terms_footer.dart';
import '../signup_field_dec.dart';
import '../../field_label.dart';

class Step2Contact extends StatefulWidget {
  const Step2Contact({
    super.key,
    required this.emailCtrl,
    required this.governorate,
    required this.city,
    required this.onGovernorateChanged,
    required this.onCityChanged,
    required this.onNext,
  });
  final TextEditingController emailCtrl;
  final String? governorate;
  final String? city;
  final ValueChanged<String?> onGovernorateChanged;
  final ValueChanged<String?> onCityChanged;
  final VoidCallback onNext;

  @override
  State<Step2Contact> createState() => _Step2ContactState();
}

class _Step2ContactState extends State<Step2Contact> {
  final _formKey = GlobalKey<FormState>();
  
  static const _governorates = [
    'عمّان', 'إربد', 'الزرقاء', 'البلقاء', 'المفرق',
    'الكرك', 'معان', 'جرش', 'عجلون', 'العقبة', 'الطفيلة', 'مادبا'
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(HakimSpacing.xl),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SignupStepCard(
              child: Column(
                children: [
                  SignupCardHeader(
                    icon: HakimIcons.locationOnOutlined,
                    title: l10n.contactInfo,
                    subtitle: l10n.contactSubtitle,
                  ),
                  const SizedBox(height: HakimSpacing.sm),

                  FieldLabel(l10n.email),
                  TextFormField(
                    controller: widget.emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColorScheme.of(context).textPrimary, 
                        fontSize: 14),
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.requiredField;
                      if (!v.contains('@')) return 'Invalid email';
                      return null;
                    },
                    decoration: signupFieldDec(context,
                        hint: 'example@domain.com',
                        prefixIcon: HakimIcons.emailOutlined),
                  ),
                  const SizedBox(height: HakimSpacing.md),

                  FieldLabel(l10n.governorate),
                  DropdownButtonFormField<String>(
                    initialValue: widget.governorate,
                    decoration: signupFieldDec(context,
                        hint: l10n.governorateHint,
                        prefixIcon: HakimIcons.mapOutlined),
                    dropdownColor: Theme.of(context).cardColor,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColorScheme.of(context).textPrimary, 
                        fontSize: 14),
                    icon: HakimIcon(HakimIcons.keyboardArrowDownRounded,
                        color: HakimColorScheme.of(context).textHint),
                    validator: (v) =>
                        v == null ? l10n.requiredField : null,
                    onChanged: (v) {
                      widget.onGovernorateChanged(v);
                      widget.onCityChanged(null);
                    },
                    items: _governorates
                        .map((g) => DropdownMenuItem(
                              value: g,
                              child: Text(g),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: HakimSpacing.md),

                  FieldLabel(l10n.city),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColorScheme.of(context).textPrimary, 
                        fontSize: 14),
                    validator: (v) => (v == null || v.isEmpty)
                        ? l10n.requiredField
                        : null,
                    decoration: signupFieldDec(context,
                        hint: l10n.cityHint,
                        prefixIcon: HakimIcons.homeOutlined),
                  ),
                ],
              ),
            ),
            const SizedBox(height: HakimSpacing.lg),

            SignupCtaButton(
                label: l10n.next,
                icon: HakimIcons.arrowForwardRounded,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onNext();
                  }
                }),
            const SizedBox(height: HakimSpacing.sm),
            const SignupTermsFooter(),
            const SizedBox(height: HakimSpacing.lg),

            SignupLockedStepRow(number: '3', title: l10n.healthProfile),
            const SizedBox(height: HakimSpacing.sm),
            SignupLockedStepRow(number: '4', title: l10n.consentAndTerms),
            const SizedBox(height: HakimSpacing.xl),
          ],
        ),
      ),
    );
  }
}

