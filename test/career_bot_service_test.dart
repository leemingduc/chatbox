import 'package:flutter_test/flutter_test.dart';
import 'package:chatbox/services/career_bot_service.dart';

void main() {
  test('CareerBotService handles subject weakness challenge (yếu lý)', () {
    final result = CareerBotService.getResponse('mình rất yếu môn lý thì học ngành gì', 'vi');
    expect(result.text, contains('tổ hợp môn khác'));
  });

  test('CareerBotService handles geographical preference challenge (TPHCM)', () {
    final result = CareerBotService.getResponse('tôi chỉ muốn học ở tphcm', 'vi');
    expect(result.text, contains('TP.HCM'));
  });
}
