import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String? error;
  final List<String> suggestedQuestions;

  const ChatState({
    required this.messages,
    required this.isTyping,
    required this.error,
    required this.suggestedQuestions,
  });

  factory ChatState.initial() => const ChatState(
    messages: [],
    isTyping: false,
    error: null,
    suggestedQuestions: [],
  );

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    String? error,
    List<String>? suggestedQuestions,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: error,
      suggestedQuestions: suggestedQuestions ?? this.suggestedQuestions,
    );
  }

  @override
  List<Object?> get props => [messages, isTyping, error, suggestedQuestions];
}