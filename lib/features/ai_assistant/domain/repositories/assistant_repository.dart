import '../models/chat_message.dart';

abstract class AssistantRepository {
  /// Sends a query to the AI and returns a stream of message chunks.
  Stream<String> sendMessageStream(String query, List<ChatMessage> history);
  
  /// High-level method to send a query and get a full response (mock implementation convenience).
  Future<ChatMessage> sendMessage(String query, List<ChatMessage> history);
}
