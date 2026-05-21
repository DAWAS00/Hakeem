import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../providers/signup_state.dart';

class SignupStepIndicator extends StatelessWidget {
  const SignupStepIndicator({
    super.key,
    required this.currentStep,
    required this.onStepTap,
  });

  final SignupStep currentStep;
  final ValueChanged<SignupStep> onStepTap;

  static const _steps = [
    (step: SignupStep.identity, icon: Icons.badge_outlined),
    (step: SignupStep.contact, icon: Icons.phone_outlined),
    (step: SignupStep.health, icon: Icons.favorite_outline),
    (step: SignupStep.consent, icon: Icons.verified_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [l10n.identity, l10n.contact, l10n.health, l10n.consent];

    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) return _Connector(isDone: i ~/ 2 < currentStep.index);

        final idx = i ~/ 2;
        final entry = _steps[idx];
        final isDone = idx < currentStep.index;
        final isActive = entry.step == currentStep;

        return Expanded(
          child: GestureDetector(
            onTap: isDone ? () => onStepTap(entry.step) : null,
            child: _StepDot(
              icon: entry.icon,
              label: labels[idx],
              isDone: isDone,
              isActive: isActive,
            ),
          ),
        );
      }),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.icon,
    required this.label,
    required this.isDone,
    required this.isActive,
  });

  final IconData icon;
  final String label;
  final bool isDone;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color iconColor;
    final Color borderColor;

    if (isDone) {
      bg = HakimColors.stepDone;
      iconColor = Colors.white;
      borderColor = HakimColors.stepDone;
    } else if (isActive) {
      bg = HakimColors.stepActive;
      iconColor = Colors.white;
      borderColor = HakimColors.stepActive;
    } else {
      bg = Colors.transparent;
      iconColor = HakimColors.textHint;
      borderColor = Theme.of(context).brightness == Brightness.dark
          ? HakimColors.stepLocked
          : HakimColors.stepLockedLight;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Icon(
            isDone ? Icons.check : icon,
            size: 16,
            color: iconColor,
          ),
        ),
        const SizedBox(height: HakimSpacing.xs),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive
                ? HakimColors.stepActive
                : isDone
                    ? HakimColors.stepDone
                    : HakimColors.textHint,
          ),
        ),
      ],
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector({required this.isDone});

  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 2,
      width: 20,
      margin: const EdgeInsets.only(bottom: HakimSpacing.lg),
      color: isDone ? HakimColors.stepDone : HakimColors.border,
    );
  }
}
