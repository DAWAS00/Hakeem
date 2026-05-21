import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/constants/hakim_colors.dart';
import '../../../../../core/constants/hakim_spacing.dart';
import '../../../../../core/l10n/app_localizations.dart';

class SignupStepperBar extends StatelessWidget {
  const SignupStepperBar({super.key, required this.currentStep});
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [l10n.identity, l10n.contact, l10n.health, l10n.consent];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: List.generate(4, (i) {
        final isDone   = i < currentStep;
        final isActive = i == currentStep;
        final stepLockedColor = isDark ? HakimColors.stepLocked : HakimColors.stepLockedLight;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  // connector line before (except first)
                  if (i > 0)
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 2,
                        decoration: BoxDecoration(
                          color: isDone || isActive
                              ? HakimColors.stepDone
                              : stepLockedColor,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  // step circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 28 : 24,
                    height: isActive ? 28 : 24,
                    decoration: BoxDecoration(
                      color: isDone
                          ? HakimColors.stepDone
                          : isActive
                              ? HakimColors.primary
                              : stepLockedColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive
                            ? HakimColors.accent.withValues(alpha: 0.4)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: isDone
                          ? const HugeIcon(
                              icon: HugeIcons.strokeRoundedTick01,
                              size: 14, 
                              color: Colors.white,
                            )
                          : Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: isActive ? 13 : 11,
                                fontWeight: FontWeight.w700,
                                color: isActive
                                    ? Colors.white
                                    : HakimColors.textHint,
                              ),
                            ),
                    ),
                  ),
                  // connector line after (except last)
                  if (i < 3)
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 2,
                        decoration: BoxDecoration(
                          color: isDone
                              ? HakimColors.stepDone
                              : stepLockedColor,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: HakimSpacing.xs),
              Text(
                labels[i],
                style: TextStyle(
                  fontSize: 10,
                  color: isActive
                      ? HakimColors.accent
                      : isDone
                          ? HakimColors.stepDone
                          : HakimColors.textHint,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
