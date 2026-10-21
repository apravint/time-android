import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_app/main.dart';

void main() {
  testWidgets('ChronoCraft App smoke test and HUD toggle test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const ChronoCraftApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Initially in pure fullscreen mode - FittedBox is present
    expect(find.byType(FittedBox), findsWidgets);

    // Switch mode via keyboard shortcut 'M'
    await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('PROJECT LAUNCH'), findsOneWidget);

    // Switch to TIMER mode
    await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('FOCUS'), findsWidgets);

    // Switch to STOPWATCH mode
    await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('STOPWATCH'), findsWidgets);

    // Reset physical size
    addTearDown(tester.view.resetPhysicalSize);
  });
}
