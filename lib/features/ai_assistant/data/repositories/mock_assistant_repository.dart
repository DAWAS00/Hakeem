import '../../domain/models/chat_message.dart';
import '../../domain/repositories/assistant_repository.dart';

class MockAssistantRepository implements AssistantRepository {
  const MockAssistantRepository();

  @override
  Stream<String> sendMessageStream(String query, List<ChatMessage> history) async* {
    final response = _getMockResponse(query);
    
    // Simulate streaming by yielding words one by one
    final words = response.split(' ');
    for (final word in words) {
      await Future.delayed(const Duration(milliseconds: 50));
      yield '$word ';
    }
  }

  @override
  Future<ChatMessage> sendMessage(String query, List<ChatMessage> history) async {
    await Future.delayed(const Duration(seconds: 1));
    final content = _getMockResponse(query);
    
    return ChatMessage(
      id: DateTime.now().toIso8601String(),
      role: MessageRole.assistant,
      content: content,
      timestamp: DateTime.now(),
      sourceTag: _getSourceTag(query),
      containsSymptomKeywords: _containsSymptomKeywords(query),
    );
  }

  String _getMockResponse(String query) {
    if (query.contains('موعدي')) {
      return 'موعدك القادم مع د. أحمد علي في مستشفى الملك عبد الله المؤسس يوم الاثنين 1 يونيو الساعة 10:00 صباحاً.';
    } else if (query.contains('دوائي') || query.contains('دواء')) {
      return 'عليك أخذ حبة واحدة من أموكسيسيلين (Amoxicillin) ثلاث مرات يومياً بعد الوجبات. جرعتك التالية في تمام الساعة 2:00 ظهراً.';
    } else if (query.contains('السكر')) {
      return 'آخر قراءة للسكر الصائم كانت 126 mg/dL. هذه القراءة مرتفعة قليلاً عن المعدل الطبيعي (70-99). يُنصح بمراقبة السكري يومياً وتقليل تناول السكريات.';
    } else if (query.contains('أشعر') || query.contains('ألم')) {
      return 'أنا متأسف لسماع ذلك. هل يمكنك إخباري بالمزيد عن هذا الألم؟ إذا كان الألم شديداً، يرجى التوجه لأقرب مركز طوارئ فوراً.';
    }
    
    return 'مرحباً! أنا حكيم، مساعدك الصحي الذكي. كيف يمكنني مساعدتك اليوم؟ يمكنك سؤالي عن مواعيدك، أدويتك، أو نتائج تحاليلك.';
  }

  String? _getSourceTag(String query) {
    if (query.contains('موعدي')) return 'من مواعيدك';
    if (query.contains('دوائي') || query.contains('دواء')) return 'من أدويتك';
    if (query.contains('السكر')) return 'من نتائجك';
    return null;
  }

  bool _containsSymptomKeywords(String query) {
    final keywords = ['ألم', 'تعب', 'صداع', 'ضيق', 'تنفس', 'أشعر'];
    return keywords.any((k) => query.contains(keywords.toString())); // Basic check
  }
}
