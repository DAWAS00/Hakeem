import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/constants/hakim_colors.dart';
import '../../../../../core/constants/hakim_spacing.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/utils/validators.dart';
import '../field_label.dart';
import '../input_decoration_factory.dart';
import 'step_section_header.dart';

// Jordan governorates
const _governorates = [
  'عمان',
  'إربد',
  'الزرقاء',
  'البلقاء',
  'الكرك',
  'المفرق',
  'جرش',
  'عجلون',
  'معان',
  'الطفيلة',
  'العقبة',
  'مادبا',
];

class ContactStep extends StatelessWidget {
  const ContactStep({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.emailController,
    required this.selectedGovernorate,
    required this.selectedCity,
    required this.onGovernorateChanged,
    required this.onCityChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final String selectedGovernorate;
  final String selectedCity;
  final ValueChanged<String?> onGovernorateChanged;
  final ValueChanged<String?> onCityChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final inputStyle = TextStyle(
      color: Theme.of(context).textTheme.bodyLarge?.color,
      fontSize: 15,
    );

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StepSectionHeader(
            title: l10n.contactInfo,
            subtitle: l10n.contactSubtitle,
          ),

          const SizedBox(height: HakimSpacing.lg),

          // Phone
          FieldLabel(l10n.phone),
          TextFormField(
            controller: phoneController,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            style: inputStyle,
            validator: (v) => Validators.phone(v, l10n),
            decoration: InputDecorationFactory.build(
              context: context,
              hint: '7X XXX XXXX',
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
                child: Icon(Icons.phone_outlined, size: 20, color: HakimColors.accent),
              ),
              suffixIcon: Container(
                width: 56,
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HakimColors.bgPrefix
                      : HakimColors.bgPrefixLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: HakimColors.border),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '+962',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: HakimColors.accent,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: HakimSpacing.md),

          // Email (optional)
          FieldLabel('${l10n.email} (${l10n.requiredField.replaceAll('مطلوب', 'اختياري')})'),
          TextFormField(
            controller: emailController,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: inputStyle,
            validator: Validators.emailOptional,
            decoration: InputDecorationFactory.build(
              context: context,
              hint: 'example@email.com',
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
                child: Icon(Icons.email_outlined, size: 20, color: HakimColors.accent),
              ),
            ),
          ),

          const SizedBox(height: HakimSpacing.md),

          // Governorate
          FieldLabel(l10n.governorate),
          DropdownButtonFormField<String>(
            initialValue: selectedGovernorate.isEmpty ? null : selectedGovernorate,
            hint: Text(
              l10n.governorateHint,
              style: const TextStyle(color: HakimColors.textHint, fontSize: 14),
            ),
            style: inputStyle,
            dropdownColor: Theme.of(context).brightness == Brightness.dark
                ? HakimColors.bgCard
                : HakimColors.bgCardLight,
            decoration: InputDecorationFactory.build(
              context: context,
              hint: '',
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
                child: Icon(Icons.location_city_outlined,
                    size: 20, color: HakimColors.accent),
              ),
            ),
            items: _governorates
                .map(
                  (g) => DropdownMenuItem(
                    value: g,
                    child: Text(g),
                  ),
                )
                .toList(),
            validator: (v) => (v == null || v.isEmpty) ? l10n.requiredField : null,
            onChanged: onGovernorateChanged,
          ),

          const SizedBox(height: HakimSpacing.md),

          // City (free text for now)
          FieldLabel(l10n.city),
          TextFormField(
            initialValue: selectedCity.isEmpty ? null : selectedCity,
            textInputAction: TextInputAction.done,
            style: inputStyle,
            validator: (v) => Validators.requiredText(v, l10n),
            onChanged: onCityChanged,
            decoration: InputDecorationFactory.build(
              context: context,
              hint: l10n.cityHint,
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
                child: Icon(Icons.map_outlined, size: 20, color: HakimColors.accent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
