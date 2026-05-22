import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: HakimColorScheme.of(context).border, thickness: 0.5)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: HakimSpacing.md),
          child: Text(
            'أو',
            style: TextStyle(fontSize: 12, color: HakimColorScheme.of(context).textHint),
          ),
        ),
        Expanded(child: Divider(color: HakimColorScheme.of(context).border, thickness: 0.5)),
      ],
    );
  }
}
