import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AIService {
  final String model;
  final String systemPrompt;

  AIService({
    this.model = "gpt-4o-mini",
    this.systemPrompt =
        "You are a time and focus manager. Reply like a young energetic AI assistant.",
  });

  /// 🔑 Fetch API key from SharedPreferences
  Future<String?> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_api_key");
  }

  Future<String> sendMessage(String userMessage) async {
    final uri = Uri.parse("https://api.openai.com/v1/chat/completions");

    // 🔥 Parse/Load the key here
    final apiKey = await _loadApiKey();

    if (apiKey == null || apiKey.trim().isEmpty) {
      throw ApiKeyMissingException(
        'No API key set. Please add your API key in settings.',
      );
    }

    try {
      final response = await http
          .post(
            uri,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $apiKey",
            },
            body: jsonEncode({
              "model": model,
              "messages": [
                {"role": "system", "content": systemPrompt},
                {"role": "user", "content": userMessage},
              ],
              "temperature": 1.3,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final content =
            data["choices"]?[0]?["message"]?["content"]?.trim() ?? "";

        if (content.isEmpty) {
          return "⚠️ Got an empty response from the AI.";
        }

        return content;
      } else {
        // Map certain status codes to typed exceptions
        if (response.statusCode == 401 || response.statusCode == 403) {
          final msg =
              _tryExtractErrorMessage(response) ??
              'Invalid or unauthorized API key.';
          throw ApiKeyInvalidException(msg);
        }

        throw ApiException(
          _tryExtractErrorMessage(response) ??
              'API Error (${response.statusCode})',
        );
      }
    } catch (e) {
      // Re-throw typed exceptions, wrap others as network issues
      if (e is ApiException ||
          e is ApiKeyMissingException ||
          e is ApiKeyInvalidException)
        rethrow;
      throw NetworkException(e.toString());
    }
  }

  String? _tryExtractErrorMessage(http.Response response) {
    try {
      final errorData = jsonDecode(response.body);
      return errorData["error"]?["message"]?.toString();
    } catch (_) {
      return null;
    }
  }
}

// --- Exceptions for clearer handling ---
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => 'ApiException: $message';
}

class ApiKeyMissingException implements Exception {
  final String message;
  ApiKeyMissingException([this.message = 'API key is missing']);
  @override
  String toString() => 'ApiKeyMissingException: $message';
}

class ApiKeyInvalidException implements Exception {
  final String message;
  ApiKeyInvalidException([this.message = 'API key is invalid']);
  @override
  String toString() => 'ApiKeyInvalidException: $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error']);
  @override
  String toString() => 'NetworkException: $message';
}

class ApiKeyStorage {
  static const _key = "user_api_key";

  static Future<void> saveKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, key);
  }

  static Future<String?> getKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
