import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';

class SignupStepCard extends StatelessWidget {
  const SignupStepCard({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        padding: padding ?? const EdgeInsets.all(HakimSpacing.xl),
        child: child,
      );
}
