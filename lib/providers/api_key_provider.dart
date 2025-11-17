import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vfocused_app/services/ai_sevices.dart';

final apiKeyProvider = FutureProvider<String?>((ref) async {
  return await ApiKeyStorage.getKey();
});
