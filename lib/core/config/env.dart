import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static bool _loaded = false;

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: ".env");
      _loaded = true;
    } catch (_) {
      // .env not found (public repo / CI). That's OK.
      _loaded = false;
    }
  }

  static String get openAiApiKey {
    if (!_loaded) return '';
    return dotenv.maybeGet('OPENAI_API_KEY') ?? '';
  }

  static String get openAiModel {
    if (!_loaded) return 'gpt-4.1-mini';
    return dotenv.maybeGet('OPENAI_MODEL') ?? 'gpt-4.1-mini';
  }
}