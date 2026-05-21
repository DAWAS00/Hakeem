import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/validators.dart';
import 'field_label.dart';
import 'input_decoration_factory.dart';

class NationalIdField extends StatelessWidget {
  const NationalIdField({
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
        FieldLabel(l10n.nationalId),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
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
            fontSize: 15,
            letterSpacing: 1.5,
          ),
          onFieldSubmitted: (_) => nextFocus.requestFocus(),
          validator: (val) => Validators.nationalId(val, l10n),
          decoration: InputDecorationFactory.build(
            context: context,
            hint: '9XXXXXXXXX',
            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
              child: Icon(Icons.badge_outlined, size: 20, color: HakimColors.accent),
            ),
          ),
        ),
      ],
    );
  }
}
