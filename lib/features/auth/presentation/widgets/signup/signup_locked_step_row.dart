import 'package:flutter/material.dart';
import '../../../../../core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import '../../../../../core/constants/hakim_icons.dart';
import '../../../../../shared/widgets/hakim_icon.dart';

class SignupLockedStepRow extends StatelessWidget {
  const SignupLockedStepRow({super.key, required this.number, required this.title});
  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: HakimSpacing.lg, vertical: HakimSpacing.md),
      decoration: BoxDecoration(
        color: HakimColorScheme.of(context).bgInput,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          HakimIcon(HakimIcons.lockOutlineRounded,
              size: 18, color: HakimColorScheme.of(context).textHint),
          const SizedBox(width: HakimSpacing.sm),
          Text(title,
              style: TextStyle(
                  fontSize: 13, color: HakimColorScheme.of(context).textHint)),
          const Spacer(),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: HakimColorScheme.of(context).bgInput,
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Center(
              child: Text(number,
                  style: TextStyle(
                      fontSize: 10,
                      color: HakimColorScheme.of(context).textHint,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

