import 'package:flutter_test/flutter_test.dart';
import 'package:capstone_cometa/main.dart';

void main() {
  testWidgets('Home screen shows the start button', (WidgetTester tester) async {
    await tester.pumpWidget(const AttendanceApp());

    expect(find.text('Start new session'), findsOneWidget);
    expect(find.text('Attendance Checker'), findsOneWidget);
  });
}