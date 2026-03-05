import 'package:equatable/equatable.dart';

enum ChatRole { user, assistant }

class ChatMessage extends Equatable {
  final String id;
  final ChatRole role;
  final String text;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.createdAt,
  });

  factory ChatMessage.user(String text) {
    return ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: ChatRole.user,
      text: text,
      createdAt: DateTime.now(),
    );
  }

  factory ChatMessage.assistant(String text) {
    return ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: ChatRole.assistant,
      text: text,
      createdAt: DateTime.now(),
    );
  }

  ChatMessage copyWith({String? text}) {
    return ChatMessage(
      id: id,
      role: role,
      text: text ?? this.text,
      createdAt: createdAt,
    );
  }

  bool get isUser => role == ChatRole.user;

  @override
  List<Object?> get props => [id, role, text, createdAt];
}