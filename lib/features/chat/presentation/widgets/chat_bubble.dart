import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/chat_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final textColor = isUser ? Colors.white : AppColors.text;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 160),
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, (1 - v) * 6),
          child: child,
        ),
      ),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser)
                Container(
                  margin: const EdgeInsets.only(bottom: 8, right: 8),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    Icons.smart_toy_outlined,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? AppColors.userBubble
                            : AppColors.botBubble,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(isUser ? 18 : 6),
                          bottomRight: Radius.circular(isUser ? 6 : 18),
                        ),
                        border: Border.all(
                          color: isUser ? Colors.transparent : AppColors.border,
                          width: 1,
                        ),
                        boxShadow: [
                          if (!isUser)
                            BoxShadow(
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                              color: Colors.black.withValues(alpha: 0.03),
                            ),
                        ],
                      ),
                      child: isUser
                          ? Text(
                              message.text,
                              style: TextStyle(height: 1.35, color: textColor),
                            )
                          : _AssistantMessageContent(text: message.text),
                    ),
                    if (!isUser)
                      Padding(
                        padding: const EdgeInsets.only(right: 4, bottom: 2),
                        child: _CopyButton(
                          tooltip: 'Copy reply',
                          onTap: () => _copyToClipboard(context, message.text),
                        ),
                      ),
                  ],
                ),
              ),
              if (isUser) const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssistantMessageContent extends StatelessWidget {
  const _AssistantMessageContent({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final blocks = _parseMessageBlocks(text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...blocks.asMap().entries.map((entry) {
          final index = entry.key;
          final block = entry.value;

          if (block.isCode) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == blocks.length - 1 ? 0 : 10,
              ),
              child: _CodeBlock(code: block.text, language: block.language),
            );
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == blocks.length - 1 ? 0 : 10,
            ),
            child: SelectableText(
              block.text,
              style: const TextStyle(height: 1.35, color: AppColors.text),
            ),
          );
        }),
      ],
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code, this.language});

  final String code;
  final String? language;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E1626),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF101D33),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Text(
                  (language?.trim().isNotEmpty ?? false)
                      ? language!.trim()
                      : 'code',
                  style: const TextStyle(
                    color: Color(0xFFA8B6CF),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: SelectableText(
                code,
                style: const TextStyle(
                  color: Color(0xFFE6EEFF),
                  height: 1.4,
                  fontFamily: 'monospace',
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _copyToClipboard(BuildContext context, String value) {
  Clipboard.setData(ClipboardData(text: value));
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1200),
      ),
    );
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.tooltip, required this.onTap});

  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: const Icon(
            Icons.content_copy_rounded,
            size: 16,
            color: AppColors.muted,
          ),
        ),
      ),
    );
  }
}

class _MessageBlock {
  const _MessageBlock({
    required this.text,
    required this.isCode,
    this.language,
  });

  final String text;
  final bool isCode;
  final String? language;
}

List<_MessageBlock> _parseMessageBlocks(String raw) {
  final blocks = <_MessageBlock>[];
  final regex = RegExp(r'```([a-zA-Z0-9_+#-]*)?\n?([\s\S]*?)```');

  var last = 0;
  for (final match in regex.allMatches(raw)) {
    final start = match.start;
    final end = match.end;

    if (start > last) {
      final text = raw.substring(last, start).trim();
      if (text.isNotEmpty) {
        blocks.add(_MessageBlock(text: text, isCode: false));
      }
    }

    final language = match.group(1);
    final code = (match.group(2) ?? '').trimRight();
    if (code.isNotEmpty) {
      blocks.add(_MessageBlock(text: code, isCode: true, language: language));
    }

    last = end;
  }

  if (last < raw.length) {
    final text = raw.substring(last).trim();
    if (text.isNotEmpty) {
      blocks.add(_MessageBlock(text: text, isCode: false));
    }
  }

  if (blocks.isEmpty) {
    blocks.add(_MessageBlock(text: raw, isCode: false));
  }

  return blocks;
}
