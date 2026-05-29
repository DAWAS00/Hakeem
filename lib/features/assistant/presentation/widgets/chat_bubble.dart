import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/features/assistant/domain/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: message.isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? c.primary
              : (isDark ? c.bgCard : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 4 : 16),
            bottomRight: Radius.circular(message.isUser ? 16 : 4),
          ),
        ),
        child: Text(
          message.text,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: message.isUser
                ? Colors.white
                : (isDark ? Colors.white : const Color(0xFF0F172A)),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
