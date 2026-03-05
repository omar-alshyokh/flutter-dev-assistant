import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_cubit.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_composer.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/suggested_questions.dart';
import '../../../../core/theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scroll = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const ChatAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [theme.scaffoldBackgroundColor, const Color(0xFFEAF2FF)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: -60,
              child: _AmbientBlob(
                size: 180,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
            Positioned(
              top: 220,
              left: -70,
              child: _AmbientBlob(
                size: 170,
                color: AppColors.accent.withValues(alpha: 0.1),
              ),
            ),
            MultiBlocListener(
              listeners: [
                BlocListener<ChatCubit, ChatState>(
                  listenWhen: (prev, curr) {
                    final messagesChanged =
                        prev.messages.length != curr.messages.length;
                    final typingChanged = prev.isTyping != curr.isTyping;
                    return messagesChanged || typingChanged;
                  },
                  listener: (_, __) => _scrollToBottom(),
                ),
                BlocListener<ChatCubit, ChatState>(
                  listenWhen: (prev, curr) {
                    final newError =
                        prev.error != curr.error &&
                        (curr.error?.isNotEmpty ?? false);
                    return newError;
                  },
                  listener: (context, state) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error!),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
              child: Column(
                children: [
                  // ===== Chat area =====
                  Expanded(
                    child: BlocBuilder<ChatCubit, ChatState>(
                      buildWhen: (p, n) {
                        final messagesChanged = p.messages != n.messages;
                        final typingChanged = p.isTyping != n.isTyping;
                        final errorChanged = p.error != n.error;
                        return messagesChanged || typingChanged || errorChanged;
                      },
                      builder: (context, state) {
                        final itemsCount =
                            state.messages.length + (state.isTyping ? 1 : 0);

                        return Column(
                          children: [
                            if (state.error != null && state.error!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  14,
                                  12,
                                  14,
                                  0,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.35),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.info_outline, size: 18),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          state.error!,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (state.messages.isEmpty && !state.isTyping)
                              Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                            border: Border.all(
                                              color: AppColors.border,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.code_rounded,
                                            size: 28,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          "Ask your first Flutter question",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          "I can help with widgets, clean architecture, performance, and debugging.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            else
                              Expanded(
                                child: ListView.builder(
                                  controller: _scroll,
                                  padding: const EdgeInsets.fromLTRB(
                                    14,
                                    14,
                                    14,
                                    14,
                                  ),
                                  itemCount: itemsCount,
                                  itemBuilder: (context, index) {
                                    final isTypingRow =
                                        state.isTyping &&
                                        index == itemsCount - 1;
                                    if (isTypingRow) {
                                      return const TypingIndicator();
                                    }

                                    final msg = state.messages[index];
                                    return ChatBubble(message: msg);
                                  },
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  BlocBuilder<ChatCubit, ChatState>(
                    buildWhen: (p, n) =>
                        p.isTyping != n.isTyping ||
                        p.suggestedQuestions != n.suggestedQuestions,
                    builder: (context, state) {
                      return Column(
                        children: [
                          SuggestedQuestions(
                            questions: state.suggestedQuestions,
                            onTap: (q) => context.read<ChatCubit>().send(q),
                          ),
                          ChatComposer(
                            isTyping: state.isTyping,
                            onSend: (text) =>
                                context.read<ChatCubit>().send(text),
                            onStop: () =>
                                context.read<ChatCubit>().cancelGeneration(),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmbientBlob extends StatelessWidget {
  const _AmbientBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
