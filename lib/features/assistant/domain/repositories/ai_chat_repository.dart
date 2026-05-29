import '../models/chat_message.dart';

abstract interface class AiChatRepository {
  Future<ChatMessage> sendMessage(String text);
}
