import 'package:flutter_test/flutter_test.dart';
import 'package:chatbox/main.dart';

void main() {
  testWidgets('CareerGuidanceApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger frames
    await tester.pumpWidget(const CareerGuidanceApp());
    await tester.pump(const Duration(seconds: 4));

    // Verify that app title exists
    expect(find.textContaining('Tư Vấn'), findsAtLeastNWidgets(1));
  });
}
