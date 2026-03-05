import '../../../chat/domain/entities/chat_message.dart';
import '../../../../core/config/env.dart';
import '../../../../core/network/openai_client.dart';

class OpenAiChatRemoteDataSource {
  final OpenAiClient _client;

  OpenAiChatRemoteDataSource(this._client);

  Future<String> sendChat(List<ChatMessage> history) async {
    final input = _buildInput(history);

    final json = await _client.createResponse(
      model: Env.openAiModel,
      input: input,
      instructions: "You are a helpful, concise assistant.",
      maxOutputTokens: 600,
      temperature: 0.7,
    );

    return _extractAssistantText(json) ??
        "I couldn't parse the model response (no output_text found).";
  }

  List<Map<String, dynamic>> _buildInput(List<ChatMessage> history) {
    // Cost safety: cap messages sent to API
    final capped = history.length <= 12
        ? history
        : history.sublist(history.length - 12);

    // Keep the SAME shape you already use in sendChat()
    return capped
        .map(
          (m) => {"role": m.isUser ? "user" : "assistant", "content": m.text},
        )
        .toList();
  }

  String? _extractAssistantText(Map<String, dynamic> json) {
    final output = json["output"];
    if (output is! List) return null;

    final buffer = StringBuffer();

    for (final item in output) {
      if (item is! Map) continue;
      if (item["type"] != "message") continue;
      if (item["role"] != "assistant") continue;

      final content = item["content"];
      if (content is! List) continue;

      for (final c in content) {
        if (c is! Map) continue;
        if (c["type"] == "output_text") {
          final t = c["text"];
          if (t is String && t.isNotEmpty) {
            if (buffer.isNotEmpty) buffer.writeln();
            buffer.write(t);
          }
        }
      }
    }

    final text = buffer.toString().trim();
    return text.isEmpty ? null : text;
  }
}
