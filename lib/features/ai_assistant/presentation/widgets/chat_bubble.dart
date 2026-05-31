import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../ai_assistant/domain/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message, this.animate = true});

  final ChatMessage message;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final isUser = message.role == MessageRole.user;

    Widget bubble = Padding(
      padding: const EdgeInsets.only(bottom: HakimSpacing.md),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            _AiBubbleAvatar(color: c.primary),
            const SizedBox(width: HakimSpacing.sm),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: HakimSpacing.lg,
                    vertical: HakimSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? c.primary : c.bgCard,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: isUser ? null : Border.all(color: c.borderCard),
                    boxShadow: [
                      BoxShadow(
                        color: (isUser ? c.primary : Colors.black).withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: isUser ? Colors.white : c.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message.sourceTag != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: c.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: c.primary.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          message.sourceTag!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: c.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: HakimSpacing.sm),
                    ],
                    Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(fontSize: 10, color: c.textHint),
                    ),
                  ],
                ),
                if (!isUser && message.containsSymptomKeywords)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 11, color: c.textHint),
                        const SizedBox(width: 3),
                        Text(
                          'للأعراض الطبية راجع طبيبك دائماً',
                          style: TextStyle(fontSize: 10, color: c.textHint),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 4),
        ],
      ),
    );

    if (!animate) return bubble;

    return bubble
        .animate()
        .fadeIn(duration: 250.ms)
        .slideY(
          begin: 0.2,
          end: 0,
          duration: 250.ms,
          curve: Curves.easeOut,
        );
  }

  String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _AiBubbleAvatar extends StatelessWidget {
  const _AiBubbleAvatar({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'ح',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
