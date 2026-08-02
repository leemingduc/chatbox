import 'package:flutter_test/flutter_test.dart';
import 'package:chatbox/services/gemini_service.dart';

void main() {
  test('GeminiService isApiKeyConfigured evaluates to true with default key', () {
    expect(GeminiService.isApiKeyConfigured, isTrue);
  });
}
