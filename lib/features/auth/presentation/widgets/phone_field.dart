import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/hakim_icons.dart';
import '../../../../shared/widgets/hakim_icon.dart';
import '../../../../core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
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
            color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColorScheme.of(context).textPrimary,
            fontSize: 15,
            letterSpacing: 1.2,
          ),
          onFieldSubmitted: (_) => nextFocus.requestFocus(),
          validator: (val) => Validators.phone(val, l10n),
          decoration: InputDecorationFactory.build(
            context: context,
            hint: '7X XXX XXXX',
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
              child: HakimIcon(
                HakimIcons.smartPhone01,
                size: 20,
                color: HakimColorScheme.of(context).accent,
              ),
            ),
            suffixIcon: Builder(
              builder: (context) {
                final c = HakimColorScheme.of(context);
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: isDark ? c.bgDeep : c.infoBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDark
                          ? c.info.withValues(alpha: 0.3)
                          : c.borderFocus.withValues(alpha: 0.25),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🇯🇴', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        '+962',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: c.info,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

