import '../../domain/entities/chat_message.dart';
import '../datasources/faq_datasource.dart';
import '../models/faq_item.dart';

class FaqChatRepository {
  FaqChatRepository(this._ds);

  final FaqDataSource _ds;

  List<FaqItem> get questions => _ds.getAll();

  ChatMessage? answerFor(String userText) {
    final normalized = _norm(userText);

    final all = _ds.getAll();

    // Exact match on question
    final exact = all.where((f) => _norm(f.question) == normalized).toList();
    if (exact.isNotEmpty) {
      return ChatMessage.assistant(exact.first.answer);
    }

    // keyword match
    final best = _bestKeywordMatch(all, normalized);
    if (best != null) {
      return ChatMessage.assistant(best.answer);
    }

    return null;
  }

  FaqItem? _bestKeywordMatch(List<FaqItem> items, String normalizedUser) {
    int bestScore = 0;
    FaqItem? best;

    for (final item in items) {
      final score = item.keywords
          .map((k) => normalizedUser.contains(_norm(k)) ? 1 : 0)
          .fold<int>(0, (a, b) => a + b);

      if (score > bestScore) {
        bestScore = score;
        best = item;
      }
    }
    return bestScore >= 1 ? best : null;
  }

  String _norm(String s) => s.toLowerCase().trim();
}
