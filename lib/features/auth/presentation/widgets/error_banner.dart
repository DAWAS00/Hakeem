import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/hakim_icons.dart';
import '../../../../shared/widgets/hakim_icon.dart';
import '../../../../core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HakimSpacing.md,
        vertical: HakimSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: const Color(0x1AEF4444),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x4DEF4444)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          HakimIcon(HakimIcons.errorOutline, size: 16, color: HakimColorScheme.of(context).error),
          const SizedBox(width: HakimSpacing.sm),
          Expanded(
            child: Text(
              message,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 13,
                color: HakimColorScheme.of(context).error,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .shake(duration: 400.ms, hz: 3, offset: const Offset(4, 0))
        .fadeIn(duration: 200.ms);
  }
}

