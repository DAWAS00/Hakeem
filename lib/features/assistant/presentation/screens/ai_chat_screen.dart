import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import 'package:hakeem/core/constants/hakim_icons.dart';
import 'package:hakeem/features/home/domain/models/home_models.dart' show MascotState;
import 'package:hakeem/features/home/presentation/providers/home_provider.dart' show mascotStateProvider;
import 'package:hakeem/features/assistant/presentation/providers/chat_provider.dart';
import 'package:hakeem/features/assistant/presentation/widgets/chat_bubble.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final mascotState = ref.watch(mascotStateProvider);
    final c = HakimColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Scroll to bottom when new messages arrive
    ref.listen(chatProvider, (prev, next) {
      if (prev?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: c.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'حكيم الذكي',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                Text(
                  chatState.isLoading ? 'يفكر...' : 'متصل حالياً',
                  style: TextStyle(
                    fontSize: 10,
                    color: chatState.isLoading ? c.primary : Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Hero(
              tag: 'mascot-hero',
              child: Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  _getMascotIcon(mascotState),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: chatState.messages.length,
              itemBuilder: (context, i) {
                return ChatBubble(message: chatState.messages[i]);
              },
            ),
          ),
          if (chatState.isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: _ThinkingIndicator(),
            ),
          _InputArea(
            controller: _controller,
            isLoading: chatState.isLoading,
            onSend: (text) {
              ref.read(chatProvider.notifier).sendMessage(text);
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }

  String _getMascotIcon(MascotState state) {
    switch (state) {
      case MascotState.thinking:
        return HakimIcons.mascotThinking;
      case MascotState.happy:
        return HakimIcons.mascotHappy;
      case MascotState.sad:
        return HakimIcons.mascotSad;
      default:
        return HakimIcons.mascotIdle;
    }
  }
}

class _ThinkingIndicator extends StatelessWidget {
  const _ThinkingIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) => _Dot(delay: i * 200)),
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot({required this.delay});
  final int delay;

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _controller.reverse();
        if (status == AnimationStatus.dismissed) _controller.forward();
      });

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: HakimColorScheme.of(context).primary.withValues(
                  alpha: 0.3 + (0.7 * _controller.value),
                ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

class _InputArea extends StatelessWidget {
  const _InputArea({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isLoading;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(
        HakimSpacing.xl,
        12,
        HakimSpacing.xl,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: isLoading ? null : () => onSend(controller.text),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isLoading ? Colors.grey : c.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'اسأل حكيم...',
                hintTextDirection: TextDirection.rtl,
                filled: true,
                fillColor: isDark ? Colors.white10 : const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
