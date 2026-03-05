import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatbot/features/chat/data/repositories/faq_chat_repository.dart';
import 'package:flutter_chatbot/features/chat/domain/entities/chat_message.dart';
import 'package:flutter_chatbot/features/chat/domain/repositories/chat_repository.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required this.faqRepo, required this.chatRepo})
    : super(ChatState.initial()) {
    final list = faqRepo.questions.map((e) => e.question).toList();

    emit(
      state.copyWith(
        suggestedQuestions: list,
        messages: [
          ChatMessage.assistant(
            "Hi, I am your Flutter development assistant. Ask a question or choose a quick prompt below.",
          ),
        ],
      ),
    );
  }

  final FaqChatRepository faqRepo;
  final ChatRepository chatRepo;

  bool _inFlight = false;

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _inFlight) return;
    _inFlight = true;

    final msgs = List<ChatMessage>.from(state.messages)
      ..add(ChatMessage.user(trimmed));

    emit(state.copyWith(messages: msgs, isTyping: true, error: null));

    final localReply = faqRepo.answerFor(trimmed);
    if (localReply != null) {
      emit(state.copyWith(messages: [...msgs, localReply], isTyping: false));
      _inFlight = false;
      return;
    }

    if (_isFlutterQuestion(trimmed)) {
      try {
        final aiText = await chatRepo.sendMessage(msgs);
        emit(
          state.copyWith(
            messages: [...msgs, ChatMessage.assistant(aiText)],
            isTyping: false,
          ),
        );
      } catch (_) {
        emit(
          state.copyWith(
            messages: [
              ...msgs,
              ChatMessage.assistant(
                "I couldn't reach AI right now. Ask another Flutter question or try again in a moment.",
              ),
            ],
            isTyping: false,
            error: "AI is temporarily unavailable.",
          ),
        );
      }
      _inFlight = false;
      return;
    }

    emit(
      state.copyWith(
        messages: [
          ...msgs,
          ChatMessage.assistant(
            "Nice one 😄 I stay focused on Flutter dev only. Ask me about widgets, Dart, architecture, state management, or performance.",
          ),
        ],
        isTyping: false,
      ),
    );

    _inFlight = false;
  }

  bool _isFlutterQuestion(String text) {
    final normalized = text.toLowerCase();
    return _flutterKeywords.any(normalized.contains);
  }

  static const Set<String> _flutterKeywords = {
    "flutter",
    "dart",
    "widget",
    "widgets",
    "stateful",
    "stateless",
    "provider",
    "riverpod",
    "bloc",
    "cubit",
    "go_router",
    "buildcontext",
    "build context",
    "hot reload",
    "pubspec",
    "materialapp",
    "cupertino",
    "crossplatform",
    "cross platform",
    "ios",
    "android",
    "flutter web",
    "devtools",
    "isolate",
    "animationcontroller",
    "setstate",
  };

  Future<void> cancelGeneration() async {
    emit(state.copyWith(isTyping: false));
    _inFlight = false;
  }
}
