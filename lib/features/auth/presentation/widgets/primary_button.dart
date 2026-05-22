import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: HakimColorScheme.of(context).primary,
          disabledBackgroundColor: HakimColorScheme.of(context).primary.withValues(alpha: 0.35),
          foregroundColor: HakimColorScheme.of(context).primaryText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: HakimColorScheme.of(context).primaryText,
                ),
              )
            : Text(
                label,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
