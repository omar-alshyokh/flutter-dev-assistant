import 'dart:math' as math;

import 'package:flutter/material.dart';

class SuggestedQuestions extends StatelessWidget {
  const SuggestedQuestions({
    super.key,
    required this.questions,
    required this.onTap,
    this.title = "Flutter quick prompts",
  });

  final List<String> questions;
  final ValueChanged<String> onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final visibleQuestions = questions.take(8).toList();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = math.min(math.max(screenWidth * 0.68, 240.0), 340.0);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.55)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.tips_and_updates_rounded,
                  size: 16,
                  color: Color(0xFF1366E8),
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF223152),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 210,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Wrap(
                direction: Axis.vertical,
                spacing: 10,
                runSpacing: 10,
                children: visibleQuestions.map((q) {
                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => onTap(q),
                      child: Container(
                        width: cardWidth,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFF7FAFF),
                              cs.primary.withValues(alpha: 0.06),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: cs.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: cs.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.code_rounded,
                                size: 15,
                                color: cs.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                q,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.25,
                                  color: Color(0xFF1D2A46),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
