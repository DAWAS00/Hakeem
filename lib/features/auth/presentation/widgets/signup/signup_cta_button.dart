import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import '../../../../../shared/widgets/hakim_icon.dart';

class SignupCtaButton extends StatelessWidget {
  const SignupCtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final String? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          else ...[
            Text(label),
            if (icon != null) ...[
              const SizedBox(width: HakimSpacing.sm),
              HakimIcon(icon!, size: 18),
            ],
          ],
        ],
      ),
    );
  }
}
