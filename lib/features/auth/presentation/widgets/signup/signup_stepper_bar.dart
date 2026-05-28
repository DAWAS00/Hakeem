import 'package:flutter/material.dart';
import '../../../../../core/constants/hakim_icons.dart';
import '../../../../../shared/widgets/hakim_icon.dart';
import '../../../../../core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import '../../../../../core/l10n/app_localizations.dart';

class SignupStepperBar extends StatelessWidget {
  const SignupStepperBar({super.key, required this.currentStep});
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [l10n.identity, l10n.contact, l10n.health, l10n.consent];
    return Row(
      children: List.generate(4, (i) {
        final isDone   = i < currentStep;
        final isActive = i == currentStep;
        final stepLockedColor = HakimColorScheme.of(context).borderMuted;

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
                              ? HakimColorScheme.of(context).primary
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
                          ? HakimColorScheme.of(context).primary
                          : isActive
                              ? HakimColorScheme.of(context).primary
                              : stepLockedColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive
                            ? HakimColorScheme.of(context).accent.withValues(alpha: 0.4)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: isDone
                          ? const HakimIcon(
                              HakimIcons.tick01,
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
                                    : HakimColorScheme.of(context).textHint,
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
                              ? HakimColorScheme.of(context).primary
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
                      ? HakimColorScheme.of(context).accent
                      : isDone
                          ? HakimColorScheme.of(context).primary
                          : HakimColorScheme.of(context).textHint,
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

