import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/validators.dart';
import 'field_label.dart';
import 'input_decoration_factory.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.obscureText,
    required this.onToggle,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final VoidCallback onToggle;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel(l10n.password),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          textInputAction: TextInputAction.done,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColorScheme.of(context).textPrimary,
            fontSize: 15,
            letterSpacing: 2,
          ),
          onFieldSubmitted: (_) => onSubmit(),
          validator: (val) => Validators.password(val, l10n),
          decoration: InputDecorationFactory.build(
            context: context,
            hint: '••••••••',
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedLockPassword, 
                size: 20, 
                color: HakimColorScheme.of(context).accent,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: HugeIcon(
                icon: obscureText
                    ? HugeIcons.strokeRoundedView
                    : HugeIcons.strokeRoundedViewOffSlash,
                size: 20,
                color: HakimColorScheme.of(context).textHint,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
