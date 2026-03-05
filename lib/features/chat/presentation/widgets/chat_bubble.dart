import 'package:flutter/material.dart';
import '../../domain/entities/chat_message.dart';
import '../../../../core/theme/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

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
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.userBubble : AppColors.botBubble,
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
                  child: Text(
                    message.text,
                    style: TextStyle(height: 1.35, color: textColor),
                  ),
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
