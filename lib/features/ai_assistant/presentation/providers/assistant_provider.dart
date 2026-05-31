import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/repositories/assistant_repository.dart';
import '../../data/repositories/mock_assistant_repository.dart';
import '../../../../features/home/domain/models/home_models.dart' show MascotState;

class AssistantState {
  const AssistantState({
    this.messages = const [],
    this.isLoading = false,
    this.isListening = false,
    this.mascotMood = MascotState.idle,
    this.lastError,
  });

  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isListening;
  final MascotState mascotMood;
  final String? lastError;

  AssistantState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isListening,
    MascotState? mascotMood,
    String? lastError,
  }) {
    return AssistantState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isListening: isListening ?? this.isListening,
      mascotMood: mascotMood ?? this.mascotMood,
      lastError: lastError,
    );
  }
}

final assistantRepositoryProvider = Provider<AssistantRepository>((ref) {
  return const MockAssistantRepository();
});

class AssistantNotifier extends Notifier<AssistantState> {
  @override
  AssistantState build() {
    return AssistantState(
      messages: [
        ChatMessage(
          id: 'welcome',
          role: MessageRole.assistant,
          content: 'مرحباً! أنا حكيم، مساعدك الصحي الذكي. كيف يمكنني مساعدتك اليوم؟',
          timestamp: DateTime(2026, 5, 30),
        ),
      ],
      mascotMood: MascotState.idle,
    );
  }

  Future<void> sendMessage(String content, {bool isVoice = false}) async {
    if (content.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().toIso8601String(),
      role: MessageRole.user,
      content: content,
      timestamp: DateTime.now(),
      isVoiceInput: isVoice,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      mascotMood: MascotState.thinking,
    );

    try {
      final repository = ref.read(assistantRepositoryProvider);
      final response = await repository.sendMessage(content, state.messages);
      
      state = state.copyWith(
        messages: [...state.messages, response],
        isLoading: false,
        mascotMood: MascotState.happy,
      );

      // Return to idle after a delay
      Future.delayed(const Duration(seconds: 3), () {
        if (state.mascotMood == MascotState.happy) {
          state = state.copyWith(mascotMood: MascotState.idle);
        }
      });
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        mascotMood: MascotState.sad,
        lastError: e.toString(),
      );
    }
  }

  void startListening() {
    state = state.copyWith(
      isListening: true,
      mascotMood: MascotState.listening,
    );
  }

  void stopListening() {
    state = state.copyWith(
      isListening: false,
      mascotMood: MascotState.idle,
    );
  }

  void clearHistory() {
    state = build();
  }
}

final assistantProvider = NotifierProvider<AssistantNotifier, AssistantState>(
  AssistantNotifier.new,
);
