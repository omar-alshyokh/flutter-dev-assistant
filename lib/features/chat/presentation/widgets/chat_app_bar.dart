import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AppBar(
      titleSpacing: 0,
      toolbarHeight: 76,
      title: Row(
        children: [
          const SizedBox(width: 8),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.flutter_dash,
              size: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "WidgetWise",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 2),
                Text(
                  "Flutter mentor is online",
                  style: TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: cs.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: cs.secondary.withValues(alpha: 0.28)),
            ),
            child: const Text(
              "Dev Mode",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: AppColors.text,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz_rounded),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
