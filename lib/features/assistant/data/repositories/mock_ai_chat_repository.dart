import 'dart:math';
import 'package:hakeem/features/assistant/domain/models/chat_message.dart';
import 'package:hakeem/features/assistant/domain/repositories/ai_chat_repository.dart';

class MockAiChatRepository implements AiChatRepository {
  const MockAiChatRepository();

  @override
  Future<ChatMessage> sendMessage(String text) async {
    // Simulate network delay to trigger the "thinking" mascot state
    await Future.delayed(const Duration(milliseconds: 1500));

    final responses = [
      'أهلاً بك! أنا حكيم، مساعدك الطبي الشخصي. كيف يمكنني مساعدتك اليوم؟',
      'بناءً على أعراضك، أنصحك بشرب الكثير من السوائل والراحة. إذا استمر الألم، يرجى حجز موعد مع الطبيب.',
      'لقد قمت بمراجعة سجلك الطبي، وضغط دمك مستقر حالياً. هل تشعر بأي دوار؟',
      'يمكنني مساعدتك في فهم نتائج تحاليلك المخبرية. أي تحليل تود أن نبدأ به؟',
      'تذكر دائماً أنني ذكاء اصطناعي، وفي الحالات الطارئة يجب عليك الاتصال بالإسعاف فوراً.',
    ];

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: responses[Random().nextInt(responses.length)],
      isUser: false,
      timestamp: DateTime.now(),
    );
  }
}
