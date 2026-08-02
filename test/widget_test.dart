import 'package:flutter_test/flutter_test.dart';
import 'package:chatbox/main.dart';

void main() {
  testWidgets('CareerGuidanceApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CareerGuidanceApp());
    await tester.pumpAndSettle();

    // Verify that app title and counselor name elements exist
    expect(find.textContaining('Tư Vấn'), findsAtLeastNWidgets(1));
  });
}
