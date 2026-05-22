import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HakimSpacing.xs + 2),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark 
                ? HakimColorScheme.of(context).textPrimary 
                : HakimColorScheme.of(context).textPrimary,
          ),
        ),
      ),
    );
  }
}
