import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_icons.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import 'package:hakeem/shared/widgets/hakim_icon.dart';
import 'package:hakeem/core/l10n/app_localizations.dart';
import '../field_label.dart';
import '../input_decoration_factory.dart';
import 'step_section_header.dart';

const _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

const _commonDiseases = [
  'السكري',
  'ضغط الدم',
  'أمراض القلب',
  'الربو',
  'الغدة الدرقية',
  'الكلى',
  'الكبد',
];

class HealthStep extends StatelessWidget {
  const HealthStep({
    super.key,
    required this.formKey,
    required this.allergiesController,
    required this.heightController,
    required this.weightController,
    required this.medicationsController,
    required this.selectedBloodType,
    required this.selectedDiseases,
    required this.onBloodTypeChanged,
    required this.onDiseaseToggled,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController allergiesController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController medicationsController;
  final String selectedBloodType;
  final List<String> selectedDiseases;
  final ValueChanged<String?> onBloodTypeChanged;
  final ValueChanged<String> onDiseaseToggled;

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
            title: l10n.healthProfile,
            subtitle: l10n.healthSubtitle,
          ),

          const SizedBox(height: HakimSpacing.lg),

          // Blood type
          FieldLabel(l10n.bloodType),
          DropdownButtonFormField<String>(
            initialValue: selectedBloodType.isEmpty ? null : selectedBloodType,
            hint: Text(
              l10n.bloodTypeHint,
              style: TextStyle(color: HakimColorScheme.of(context).textHint, fontSize: 14),
            ),
            style: inputStyle,
            dropdownColor:
                HakimColorScheme.of(context).bgCard,
            decoration: InputDecorationFactory.build(
              context: context,
              hint: '',
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
                child: HakimIcon(HakimIcons.waterDropOutlined, size: 20, color: HakimColorScheme.of(context).accent),
              ),
            ),
            items: _bloodTypes
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: onBloodTypeChanged,
          ),

          const SizedBox(height: HakimSpacing.md),

          // Chronic diseases (chip multi-select)
          FieldLabel(l10n.chronicDiseases),
          Wrap(
            spacing: HakimSpacing.sm,
            runSpacing: HakimSpacing.sm,
            children: _commonDiseases.map((d) {
              final selected = selectedDiseases.contains(d);
              return FilterChip(
                label: Text(d),
                selected: selected,
                onSelected: (_) => onDiseaseToggled(d),
                selectedColor: HakimColorScheme.of(context).primary.withValues(alpha: 0.2),
                checkmarkColor: HakimColorScheme.of(context).accent,
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: selected ? HakimColorScheme.of(context).accent : HakimColorScheme.of(context).textHint,
                ),
                side: BorderSide(
                  color: selected ? HakimColorScheme.of(context).primary : HakimColorScheme.of(context).border,
                ),
                backgroundColor: Colors.transparent,
              );
            }).toList(),
          ),

          const SizedBox(height: HakimSpacing.md),

          // Allergies
          FieldLabel(l10n.allergies),
          TextFormField(
            controller: allergiesController,
            textInputAction: TextInputAction.next,
            maxLines: 2,
            style: inputStyle,
            decoration: InputDecorationFactory.build(
              context: context,
              hint: l10n.allergiesHint,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: HakimSpacing.md, vertical: HakimSpacing.lg),
                child: HakimIcon(HakimIcons.warningAmberOutlined, size: 20, color: HakimColorScheme.of(context).accent),
              ),
            ),
          ),

          const SizedBox(height: HakimSpacing.md),

          // Height & Weight in a row
          FieldLabel(l10n.heightAndWeight),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: heightController,
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  style: inputStyle,
                  decoration: InputDecorationFactory.build(
              context: context,
                    hint: l10n.height,
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
                      child: HakimIcon(HakimIcons.height, size: 20, color: HakimColorScheme.of(context).accent),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: HakimSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: weightController,
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  style: inputStyle,
                  decoration: InputDecorationFactory.build(
              context: context,
                    hint: l10n.weight,
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
                      child: HakimIcon(HakimIcons.monitorWeightOutlined, size: 20, color: HakimColorScheme.of(context).accent),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: HakimSpacing.md),

          // Medications
          FieldLabel(l10n.currentMedications),
          TextFormField(
            controller: medicationsController,
            textInputAction: TextInputAction.done,
            maxLines: 2,
            style: inputStyle,
            decoration: InputDecorationFactory.build(
              context: context,
              hint: l10n.medicationsHint,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: HakimSpacing.md, vertical: HakimSpacing.lg),
                child: HakimIcon(HakimIcons.medicationOutlined, size: 20, color: HakimColorScheme.of(context).accent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
