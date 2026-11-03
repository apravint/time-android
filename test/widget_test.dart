import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_app/main.dart';
import 'package:time_app/models/time_mode.dart';
import 'package:time_app/services/settings_store.dart';
import 'package:time_app/theme/clock_theme.dart';

void main() {
  void usePhoneScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('ChronoCraft App smoke test and mode cycling', (tester) async {
    usePhoneScreen(tester);

    await tester.pumpWidget(const ChronoCraftApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Initially in pure fullscreen mode - FittedBox is present
    expect(find.byType(FittedBox), findsWidgets);

    // Switch mode via keyboard shortcut 'M'
    await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('PROJECT LAUNCH'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('FOCUS'), findsWidgets);

    await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('STOPWATCH'), findsWidgets);
  });

  testWidgets('focus timer starts and pauses from the keyboard', (
    tester,
  ) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const ChronoCraftApp());
    await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
    await tester.pump();
    expect(find.text('PAUSED (TAP TO START)'), findsOneWidget);
    expect(find.text('25'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(find.text('FOCUS SESSION'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(find.text('PAUSED (TAP TO START)'), findsOneWidget);
  });

  testWidgets('exposes the time to screen readers', (tester) async {
    usePhoneScreen(tester);
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(const ChronoCraftApp());
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.bySemanticsLabel(RegExp(r'^Clock\. ')), findsOneWidget);
    handle.dispose();
  });

  testWidgets('long press opens the design studio and selection updates live', (
    tester,
  ) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(const ChronoCraftApp());
    await tester.longPress(find.byType(FittedBox).first);
    await tester.pumpAndSettle();
    expect(find.text('DESIGN STUDIO'), findsOneWidget);

    // First palette is selected; choose the second and see the check move.
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    await tester.tap(find.text(kThemes[1].name));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    final checkedTile = find.ancestor(
      of: find.byIcon(Icons.check_circle),
      matching: find.byType(Row),
    );
    expect(
      find.descendant(
        of: checkedTile.first,
        matching: find.text(kThemes[1].name),
      ),
      findsOneWidget,
    );
  });

  testWidgets('settings are restored on launch and saved on change', (
    tester,
  ) async {
    usePhoneScreen(tester);
    SharedPreferences.setMockInitialValues({
      'mode': TimeMode.countdown.index,
      'countdownTitle': 'EXAM DAY',
      'themeIndex': 2,
    });
    final store = await SettingsStore.open();

    await tester.pumpWidget(
      ChronoCraftApp(store: store, initialSettings: store.load()),
    );
    await tester.pump();
    expect(find.text('EXAM DAY'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.keyT);
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    expect(store.load().themeIndex, 3);
  });
}
