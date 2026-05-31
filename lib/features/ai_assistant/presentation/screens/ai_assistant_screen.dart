import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../providers/assistant_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/typing_indicator_bubble.dart';
import '../widgets/suggestion_chips_row.dart';
import '../widgets/chat_input_row.dart';
import '../widgets/triage_modal.dart';

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleChipTap(String text) {
    if (text == 'احجز موعداً') {
      TriageModal.show(context);
    } else {
      ref.read(assistantProvider.notifier).sendMessage(text);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final c = HakimColorScheme.of(context);
    final state = ref.watch(assistantProvider);

    // Only the welcome message → treat as empty
    final hasMessages = state.messages.length > 1;

    return Scaffold(
      backgroundColor: c.bgBase,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: c.bgBase,
        elevation: 0,
        centerTitle: true,
        leading: hasMessages
            ? IconButton(
                onPressed: () => ref.read(assistantProvider.notifier).clearHistory(),
                icon: Icon(Icons.refresh_rounded, color: c.textHint, size: 20),
                tooltip: 'محادثة جديدة',
              )
            : null,
        title: AnimatedSwitcher(
          duration: 300.ms,
          child: hasMessages
              ? Row(
                  key: const ValueKey('with-mascot'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: 'mascot-appbar',
                      child: SvgPicture.asset(
                        state.mascotMood.assetPath,
                        width: 32,
                        height: 32,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'حكيم AI',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: c.textPrimary,
                          ),
                        ),
                        _StatusSubtitle(state: state),
                      ],
                    ),
                  ],
                )
              : Column(
                  key: const ValueKey('title-only'),
                  children: [
                    Text(
                      'حكيم AI',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    _StatusSubtitle(state: state),
                  ],
                ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ─── Empty state ───────────────────────────────────────────────
            if (!hasMessages)
              Expanded(child: _EmptyState(mascotPath: state.mascotMood.assetPath)),

            // ─── Chat list ─────────────────────────────────────────────────
            if (hasMessages)
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    HakimSpacing.xl,
                    HakimSpacing.md,
                    HakimSpacing.xl,
                    HakimSpacing.md,
                  ),
                  itemCount: state.messages.length + (state.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (state.isLoading && index == state.messages.length) {
                      return const TypingIndicatorBubble();
                    }
                    return ChatBubble(message: state.messages[index]);
                  },
                ),
              ),

            // ─── Chips ─────────────────────────────────────────────────────
            const SizedBox(height: HakimSpacing.sm),
            SuggestionChipsRow(onChipTap: _handleChipTap),
            const SizedBox(height: HakimSpacing.sm),

            // ─── Input ─────────────────────────────────────────────────────
            ChatInputRow(
              isLoading: state.isLoading,
              isListening: state.isListening,
              onSend: (text) {
                ref.read(assistantProvider.notifier).sendMessage(text);
                _scrollToBottom();
              },
              onMicPressed: () {
                final n = ref.read(assistantProvider.notifier);
                if (state.isListening) {
                  n.stopListening();
                } else {
                  n.startListening();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.mascotPath});

  final String mascotPath;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Ambient glow behind mascot
        Positioned(
          top: 80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  c.primary.withValues(alpha: 0.12),
                  c.primary.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating mascot
            Hero(
              tag: 'mascot-appbar',
              child: SvgPicture.asset(mascotPath, width: 130, height: 130),
            )
                .animate(onPlay: (ctrl) => ctrl.repeat(reverse: true))
                .moveY(
                  begin: 0,
                  end: -12,
                  duration: 2200.ms,
                  curve: Curves.easeInOut,
                ),
            const SizedBox(height: HakimSpacing.xl),
            Text(
              'أهلاً! أنا حكيم',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: c.textPrimary,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: HakimSpacing.sm),
            Text(
              'اسألني عن صحتك، دوائك، أو مواعيدك',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: c.textSecondary, height: 1.4),
            ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
            const SizedBox(height: HakimSpacing.lg),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: c.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: c.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline_rounded, size: 12, color: c.primary),
                  const SizedBox(width: 5),
                  Text(
                    'محادثتك خاصة ومحمية',
                    style: TextStyle(
                      fontSize: 11,
                      color: c.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
          ],
        ),
      ],
    );
  }
}

// ── Status subtitle ──────────────────────────────────────────────────────────

class _StatusSubtitle extends StatelessWidget {
  const _StatusSubtitle({required this.state});

  final AssistantState state;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final String label;
    final Color color;

    if (state.isListening) {
      label = 'يستمع إليك...';
      color = c.error;
    } else if (state.isLoading) {
      label = 'يفكر...';
      color = c.primary;
    } else {
      label = 'مساعدك الصحي';
      color = c.textHint;
    }

    return Text(
      label,
      style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500),
    ).animate(key: ValueKey(label)).fadeIn(duration: 200.ms);
  }
}
