import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/hakim_colors.dart';

class VoiceInputButton extends StatelessWidget {
  const VoiceInputButton({
    super.key,
    required this.isListening,
    this.onPressed,
  });

  final bool isListening;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isListening)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: c.error.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
            ).animate(onPlay: (controller) => controller.repeat())
             .scale(begin: const Offset(1, 1), end: const Offset(1.4, 1.4), duration: 1000.ms, curve: Curves.easeOut)
             .fadeOut(duration: 1000.ms),
          
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isListening ? c.error : c.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isListening ? c.error : c.primary).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              isListening ? Icons.stop_rounded : Icons.mic_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
