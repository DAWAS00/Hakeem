import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';

class SignupCtaButton extends StatelessWidget {
  const SignupCtaButton({super.key, required this.label, required this.onPressed, this.icon});
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: HakimColorScheme.of(context).primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              if (icon != null) ...[
                const SizedBox(width: HakimSpacing.sm),
                Icon(icon, size: 18),
              ],
            ],
          ),
        ),
      );
}
