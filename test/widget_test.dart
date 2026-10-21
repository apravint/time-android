import 'package:flutter_test/flutter_test.dart';
import 'package:time_app/main.dart';

void main() {
  testWidgets('ChronoCraft App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ChronoCraftApp());
    expect(find.text('TIME • BRUTALIST'), findsOneWidget);
    expect(find.text('CLOCK'), findsWidgets);
    expect(find.text('COUNTDOWN'), findsOneWidget);
    expect(find.text('TIMER'), findsOneWidget);
  });
}
