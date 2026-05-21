import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../../core/constants/hakim_colors.dart';
import '../../../../../core/constants/hakim_spacing.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/utils/validators.dart';
import '../field_label.dart';
import '../input_decoration_factory.dart';
import 'step_section_header.dart';

class IdentityStep extends StatefulWidget {
  const IdentityStep({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.nationalIdController,
    required this.selectedGender,
    required this.selectedDob,
    required this.onGenderChanged,
    required this.onDobChanged,
    required this.onSanadTap,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController nationalIdController;
  final String selectedGender;
  final DateTime? selectedDob;
  final ValueChanged<String> onGenderChanged;
  final ValueChanged<DateTime> onDobChanged;
  final VoidCallback onSanadTap;

  @override
  State<IdentityStep> createState() => _IdentityStepState();
}

class _IdentityStepState extends State<IdentityStep> {
  final _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.selectedDob != null) {
      _dobController.text =
          intl.DateFormat('dd / MM / yyyy').format(widget.selectedDob!);
    }
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(AppLocalizations l10n) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDob ??
          DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1920),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      locale: Localizations.localeOf(context),
    );
    if (picked != null) {
      widget.onDobChanged(picked);
      _dobController.text = intl.DateFormat('dd / MM / yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StepSectionHeader(
            title: l10n.personalInfo,
            subtitle: l10n.personalInfoSubtitle,
          ),

          const SizedBox(height: HakimSpacing.lg),

          // Sanad quick-fill
          OutlinedButton.icon(
            onPressed: widget.onSanadTap,
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedUser,
              size: 18,
              color: HakimColors.sanad,
            ),
            label: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.registerWithSanad,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: HakimColors.sanad,
                  ),
                ),
                Text(
                  l10n.sanadFillHint,
                  style: const TextStyle(
                    fontSize: 11,
                    color: HakimColors.textHint,
                  ),
                ),
              ],
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: HakimSpacing.lg,
                vertical: HakimSpacing.sm,
              ),
              side: const BorderSide(color: HakimColors.sanad),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerRight,
            ),
          ),

          const SizedBox(height: HakimSpacing.lg),

          // Full name
          FieldLabel(l10n.fullName),
          TextFormField(
            controller: widget.fullNameController,
            textInputAction: TextInputAction.next,
            style: _inputStyle(context),
            validator: (v) => Validators.requiredText(v, l10n),
            decoration: InputDecorationFactory.build(
              context: context,
              hint: l10n.fullNameHint,
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedUser, 
                  size: 20, 
                  color: HakimColors.accent,
                ),
              ),
            ),
          ),

          const SizedBox(height: HakimSpacing.md),

          // National ID
          FieldLabel(l10n.nationalId),
          TextFormField(
            controller: widget.nationalIdController,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            style: _inputStyle(context),
            validator: (v) => Validators.nationalId(v, l10n),
            decoration: InputDecorationFactory.build(
              context: context,
              hint: '9XXXXXXXXX',
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedIdentityCard, 
                  size: 20, 
                  color: HakimColors.accent,
                ),
              ),
            ),
          ),

          const SizedBox(height: HakimSpacing.md),

          // Date of birth
          FieldLabel(l10n.dob),
          TextFormField(
            controller: _dobController,
            readOnly: true,
            onTap: () => _pickDate(l10n),
            style: _inputStyle(context),
            validator: (_) =>
                widget.selectedDob == null ? l10n.requiredField : null,
            decoration: InputDecorationFactory.build(
              context: context,
              hint: l10n.dobHint,
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedCalendar03,
                  size: 20, 
                  color: HakimColors.accent,
                ),
              ),
            ),
          ),

          const SizedBox(height: HakimSpacing.md),

          // Gender
          FieldLabel(l10n.gender),
          _GenderSelector(
            selected: widget.selectedGender,
            maleLabel: l10n.male,
            femaleLabel: l10n.female,
            onChanged: widget.onGenderChanged,
          ),
        ],
      ),
    );
  }

  TextStyle _inputStyle(BuildContext context) => TextStyle(
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontSize: 15,
      );
}

class _GenderSelector extends StatelessWidget {
  const _GenderSelector({
    required this.selected,
    required this.maleLabel,
    required this.femaleLabel,
    required this.onChanged,
  });

  final String selected;
  final String maleLabel;
  final String femaleLabel;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GenderChip(
            label: maleLabel,
            icon: HugeIcons.strokeRoundedUser,
            isSelected: selected == 'male',
            onTap: () => onChanged('male'),
          ),
        ),
        const SizedBox(width: HakimSpacing.md),
        Expanded(
          child: _GenderChip(
            label: femaleLabel,
            icon: HugeIcons.strokeRoundedUser,
            isSelected: selected == 'female',
            onTap: () => onChanged('female'),
          ),
        ),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final dynamic icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 48,
        decoration: BoxDecoration(
          color: isSelected
              ? HakimColors.primary.withValues(alpha: 0.15)
              : (Theme.of(context).brightness == Brightness.dark 
                  ? Colors.transparent 
                  : HakimColors.primary.withValues(alpha: 0.04)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected 
                ? HakimColors.primary 
                : (Theme.of(context).brightness == Brightness.dark 
                    ? HakimColors.border 
                    : HakimColors.primary.withValues(alpha: 0.12)),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: icon,
              size: 20,
              color: isSelected ? HakimColors.primary : HakimColors.textHint,
            ),
            const SizedBox(width: HakimSpacing.xs),
            Text(
              label,
              style: TextStyle(
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? HakimColors.primary : HakimColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
