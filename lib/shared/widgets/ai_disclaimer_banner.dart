import 'package:flutter/material.dart';
import '../../core/constants/hakim_colors.dart';
import '../../core/constants/hakim_spacing.dart';

class AiDisclaimerBanner extends StatelessWidget {
  const AiDisclaimerBanner({
    super.key,
    this.message = 'اقتراح الذكاء الاصطناعي — لم يؤكده الطبيب بعد',
    this.isVisible = true,
  });

  final String message;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final c = HakimColorScheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: HakimSpacing.md,
        vertical: HakimSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: c.warningBg,
        borderRadius: const BorderRadius.vertical(
          top: HakimRadius.md,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 14,
            color: c.warning,
          ),
          const SizedBox(width: HakimSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: c.warningText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
