import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';

class SignupGenderButton extends StatelessWidget {
  const SignupGenderButton({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50,
          decoration: BoxDecoration(
            color: selected
                ? HakimColorScheme.of(context).primary
                : (HakimColorScheme.of(context).bgInput.withValues(alpha: 0.05)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? HakimColorScheme.of(context).borderFocus
                  : (isDark ? Theme.of(context).dividerColor : HakimColorScheme.of(context).primary.withValues(alpha: 0.1)),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: selected
                      ? Colors.white
                      : HakimColorScheme.of(context).textHint),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? Colors.white
                      : HakimColorScheme.of(context).textHint,
                ),
              ),
            ],
          ),
        ),
      );
  }
}
