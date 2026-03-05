import 'package:flutter_chatbot/features/chat/domain/entities/chat_message.dart';

abstract class ChatRepository {
  Future<String> sendMessage(List<ChatMessage> history);
}
