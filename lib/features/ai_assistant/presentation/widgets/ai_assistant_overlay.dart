import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../providers/assistant_provider.dart';
import 'chat_bubble.dart';
import 'suggestion_chips_row.dart';
import 'chat_input_row.dart';
import 'triage_modal.dart';

class AiAssistantOverlay extends ConsumerStatefulWidget {
  const AiAssistantOverlay({super.key, this.startWithVoice = false});

  final bool startWithVoice;

  static void show(BuildContext context, {bool startWithVoice = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AiAssistantOverlay(startWithVoice: startWithVoice),
    );
  }

  @override
  ConsumerState<AiAssistantOverlay> createState() => _AiAssistantOverlayState();
}

class _AiAssistantOverlayState extends ConsumerState<AiAssistantOverlay> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.startWithVoice) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(assistantProvider.notifier).startListening();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final state = ref.watch(assistantProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: c.bgBase,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: c.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          _buildHeader(context, state),
          SuggestionChipsRow(
            onChipTap: (text) {
              if (text == 'احجز موعداً') {
                TriageModal.show(context);
              } else {
                ref.read(assistantProvider.notifier).sendMessage(text);
                _scrollToBottom();
              }
            },
          ),
          const SizedBox(height: HakimSpacing.md),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: state.messages[index]);
              },
            ),
          ),
          ChatInputRow(
            isLoading: state.isLoading,
            isListening: state.isListening,
            onSend: (text) {
              ref.read(assistantProvider.notifier).sendMessage(text);
              _scrollToBottom();
            },
            onMicPressed: () {
              final notifier = ref.read(assistantProvider.notifier);
              if (state.isListening) {
                notifier.stopListening();
              } else {
                notifier.startListening();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AssistantState state) {
    final c = HakimColorScheme.of(context);
    return Padding(
      padding: const EdgeInsets.all(HakimSpacing.xl),
      child: Row(
        children: [
          Hero(
            tag: 'mascot-fab',
            child: SvgPicture.asset(
              state.mascotMood.assetPath,
              width: 48,
              height: 48,
            ),
          ),
          const SizedBox(width: HakimSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حكيم AI',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                Text(
                  state.isLoading ? 'يفكر...' : (state.isListening ? 'يستمع إليك...' : 'مساعدك الصحي الذكي'),
                  style: TextStyle(
                    fontSize: 12,
                    color: state.isLoading || state.isListening ? c.primary : c.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close_rounded, color: c.textHint),
          ),
        ],
      ),
    );
  }
}
