import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/validators.dart';
import 'field_label.dart';
import 'input_decoration_factory.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.nextFocus,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel(l10n.phone),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColors.textPrimary,
            fontSize: 15,
            letterSpacing: 1.2,
          ),
          onFieldSubmitted: (_) => nextFocus.requestFocus(),
          validator: (val) => Validators.phone(val, l10n),
          decoration: InputDecorationFactory.build(
            context: context,
            hint: '7X XXX XXXX',
            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedSmartPhone01, 
                size: 20, 
                color: HakimColors.accent,
              ),
            ),
            suffixIcon: Container(
              width: 56,
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HakimColors.bgPrefix
                    : HakimColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              alignment: Alignment.center,
              child: const Text(
                '+962',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: HakimColors.accent,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
