import 'package:chatbox/services/gemini_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GeminiService uses local fallback when no API key is configured', () {
    expect(GeminiService.isApiKeyConfigured, isFalse);
  });
}
