import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import 'voice_input_button.dart';

class ChatInputRow extends StatefulWidget {
  const ChatInputRow({
    super.key,
    required this.onSend,
    required this.isListening,
    required this.onMicPressed,
    this.isLoading = false,
  });

  final Function(String) onSend;
  final bool isListening;
  final VoidCallback onMicPressed;
  final bool isLoading;

  @override
  State<ChatInputRow> createState() => _ChatInputRowState();
}

class _ChatInputRowState extends State<ChatInputRow> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_controller.text.trim().isEmpty) return;
    widget.onSend(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);

    return Container(
      padding: const EdgeInsets.all(HakimSpacing.lg),
      decoration: BoxDecoration(
        color: c.bgCard,
        border: Border(top: BorderSide(color: c.borderCard)),
      ),
      child: Row(
        children: [
          VoiceInputButton(
            isListening: widget.isListening,
            onPressed: widget.onMicPressed,
          ),
          const SizedBox(width: HakimSpacing.md),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: c.bgInput,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  const SizedBox(width: HakimSpacing.lg),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'اسألني أي شيء...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  if (widget.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else
                    IconButton(
                      onPressed: _handleSend,
                      icon: Icon(Icons.send_rounded, color: c.primary),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
