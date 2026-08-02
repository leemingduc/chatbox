import 'package:chatbox/main.dart';
import 'package:chatbox/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('guest login in the app opens the chat screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const CareerGuidanceApp());
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
    }

    expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ChatScreen), findsOneWidget);
  });
}
