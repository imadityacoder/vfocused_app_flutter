import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vfocused_app/services/ai_sevices.dart';

final aiReviewProvider = StateNotifierProvider<AIReviewController, String>((
  ref,
) {
  return AIReviewController();
});

class AIReviewController extends StateNotifier<String> {
  AIReviewController() : super("Loading AI review...");

  final _ai = AIService();

  Future<void> fetchReview() async {
    state = "Loading AI review...";
    try {
      final res = await _ai.sendMessage(
        "Give a short focus productivity summary for today. Keep it under 20 words.",
      );
      state = res;
    } catch (e) {
      // Surface useful messages to the UI while keeping error types explicit
      if (e is ApiKeyMissingException) {
        state = "Set your API key to enable AI features.";
      } else if (e is ApiKeyInvalidException) {
        state = "Invalid API key — please check your settings.";
      } else if (e is NetworkException) {
        state = "Network error while contacting AI service.";
      } else if (e is ApiException) {
        state = "AI service error: ${e.message}";
      } else {
        state = "Unexpected error: ${e.toString()}";
      }
    }
  }
}
