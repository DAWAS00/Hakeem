import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hakeem/features/assistant/domain/models/chat_message.dart';
import 'package:hakeem/features/assistant/domain/repositories/ai_chat_repository.dart';
import 'package:hakeem/features/assistant/data/repositories/mock_ai_chat_repository.dart';
import 'package:hakeem/features/home/domain/models/home_models.dart' show MascotState;
import 'package:hakeem/features/home/presentation/providers/home_provider.dart' show mascotStateProvider;

final aiChatRepositoryProvider = Provider<AiChatRepository>((ref) {
  return const MockAiChatRepository();
});

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  @override
  ChatState build() {
    return ChatState(
      messages: [
        ChatMessage(
          id: 'initial',
          text: 'مرحباً! أنا حكيم، مساعدك الطبي الذكي. كيف يمكنني مساعدتك اليوم؟',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ],
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    // Update mascot to thinking state
    ref.read(mascotStateProvider.notifier).set(MascotState.thinking);

    try {
      final repository = ref.read(aiChatRepositoryProvider);
      final response = await repository.sendMessage(text);
      state = state.copyWith(
        messages: [...state.messages, response],
        isLoading: false,
      );
      // Update mascot to happy state
      ref.read(mascotStateProvider.notifier).set(MascotState.happy);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      ref.read(mascotStateProvider.notifier).set(MascotState.sad);
    }
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
