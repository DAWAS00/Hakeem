import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: HakimColorScheme.of(context).textHint,
          ),
        ),
      ),
    );
  }
}
