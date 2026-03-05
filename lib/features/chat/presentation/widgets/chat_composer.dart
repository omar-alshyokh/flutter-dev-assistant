import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.isTyping,
    required this.onSend,
    required this.onStop,
  });

  final bool isTyping;
  final ValueChanged<String> onSend;
  final VoidCallback onStop;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final _controller = TextEditingController();

  void _send() {
    if (widget.isTyping) return;
    final text = _controller.text;
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _controller.clear();
    widget.onSend(trimmed);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          border: const Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: !widget.isTyping,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: const InputDecoration(
                  hintText:
                      "Ask about Flutter architecture, state management, widgets...",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: widget.isTyping ? widget.onStop : _send,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(
                        alpha: widget.isTyping ? 0.55 : 1.0,
                      ),
                      AppColors.accent.withValues(
                        alpha: widget.isTyping ? 0.55 : 1.0,
                      ),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  widget.isTyping
                      ? Icons.stop_rounded
                      : Icons.arrow_upward_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
