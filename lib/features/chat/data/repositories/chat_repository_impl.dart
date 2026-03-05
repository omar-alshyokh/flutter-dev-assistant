import 'package:flutter_chatbot/features/chat/domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/openai_chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._remote);

  final OpenAiChatRemoteDataSource _remote;

  @override
  Future<String> sendMessage(List<ChatMessage> history) {
    return _remote.sendChat(history);
  }
}
