import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import '../../../../core/constants/hakim_icons.dart';
import '../../../../shared/widgets/hakim_icon.dart';

class HomeErrorView extends StatelessWidget {
  const HomeErrorView({
    super.key,
    required this.onRetry,
    required this.errorMessage,
    required this.retryLabel,
  });

  final VoidCallback onRetry;
  final String errorMessage;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(HakimSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HakimIcon(
              HakimIcons.errorOutlineRounded,
              size: 64,
              color: HakimColorScheme.of(context).error,
            ),
            const SizedBox(height: HakimSpacing.lg),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color ?? HakimColorScheme.of(context).textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: HakimSpacing.xl),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: HakimColorScheme.of(context).primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}

