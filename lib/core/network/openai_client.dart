import 'package:dio/dio.dart';

import '../config/env.dart';

class OpenAiException implements Exception {
  final String message;
  final int? statusCode;

  OpenAiException(this.message, {this.statusCode});

  @override
  String toString() => statusCode == null ? message : "($statusCode) $message";
}

class OpenAiClient {
  OpenAiClient(this._dio);

  final Dio _dio;

  static const _baseUrl = "https://api.openai.com/v1";

  /// Non-streaming: returns full JSON response
  Future<Map<String, dynamic>> createResponse({
    required String model,
    required List<Map<String, dynamic>> input,
    String? instructions,
    int? maxOutputTokens,
    double? temperature,
  }) async {
    final apiKey = Env.openAiApiKey;
    if (apiKey.isEmpty) {
      throw OpenAiException(
        "Missing OPENAI_API_KEY. Add it to .env (and keep .env out of git).",
      );
    }

    try {
      final res = await _dio.post(
        "$_baseUrl/responses",
        data: {
          "model": model,
          "input": input,
          if (instructions != null) "instructions": instructions,
          if (maxOutputTokens != null) "max_output_tokens": maxOutputTokens,
          if (temperature != null) "temperature": temperature,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $apiKey",
            "Content-Type": "application/json",
          },
        ),
      );

      final data = res.data;
      if (data is Map<String, dynamic>) return data;

      throw OpenAiException("Unexpected response format from OpenAI.");
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final msg =
          _extractErrorMessage(e.response?.data) ??
          (e.message ?? "Request failed");
      throw OpenAiException(msg, statusCode: status);
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final err = data["error"];
      if (err is Map<String, dynamic>) {
        final msg = err["message"];
        if (msg is String && msg.isNotEmpty) return msg;
      }
    }
    return null;
  }
}
