enum MessageRole {
  user,
  assistant,
  system,
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.sourceTag,
    this.isVoiceInput = false,
    this.containsSymptomKeywords = false,
  });

  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final String? sourceTag; // e.g., 'من مواعيدك', 'من أدويتك'
  final bool isVoiceInput;
  final bool containsSymptomKeywords;

  ChatMessage copyWith({
    String? content,
    bool? containsSymptomKeywords,
  }) {
    return ChatMessage(
      id: id,
      role: role,
      content: content ?? this.content,
      timestamp: timestamp,
      sourceTag: sourceTag,
      isVoiceInput: isVoiceInput,
      containsSymptomKeywords: containsSymptomKeywords ?? this.containsSymptomKeywords,
    );
  }
}
