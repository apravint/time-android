import 'package:flutter_test/flutter_test.dart';
import 'package:time_app/logic/time_logic.dart';

void main() {
  group('countdownParts', () {
    final now = DateTime(2026, 1, 1, 12);

    test('splits a future target into units', () {
      final p = countdownParts(
        now.add(const Duration(days: 3, hours: 4, minutes: 5, seconds: 6)),
        now,
      );
      expect([p.days, p.hours, p.minutes, p.seconds], [3, 4, 5, 6]);
      expect(p.expired, isFalse);
    });

    test('reports expired at and after the target', () {
      expect(countdownParts(now, now).expired, isTrue);
      final past = countdownParts(now.subtract(const Duration(hours: 1)), now);
      expect(past.expired, isTrue);
      expect([past.days, past.hours, past.minutes, past.seconds], [0, 0, 0, 0]);
    });
  });

  group('formatting', () {
    test('formatTimer pads minutes and seconds', () {
      expect(formatTimer(0), '00:00');
      expect(formatTimer(25 * 60), '25:00');
      expect(formatTimer(61), '01:01');
    });

    test('splitStopwatch shows hundredths', () {
      final p = splitStopwatch(61 * 1000 + 450);
      expect(p.minutesSeconds, '01:01');
      expect(p.hundredths, '45');
      expect(p.full, '01:01.45');
    });

    test('dayProgress spans the local day', () {
      expect(dayProgress(DateTime(2026, 1, 1)), 0);
      expect(dayProgress(DateTime(2026, 1, 1, 12)), 0.5);
    });
  });

  group('FocusTimerController', () {
    late DateTime clock;
    late int finished;
    late FocusTimerController c;

    setUp(() {
      clock = DateTime(2026, 1, 1, 9);
      finished = 0;
      c = FocusTimerController(
        totalSeconds: 60,
        now: () => clock,
        onFinished: () => finished++,
      );
    });
    tearDown(() => c.dispose());

    test('counts down from the wall clock, not from tick count', () {
      c.toggle();
      expect(c.running.value, isTrue);
      clock = clock.add(const Duration(seconds: 10, milliseconds: 100));
      c.tick();
      expect(c.remaining.value, 50);
    });

    test('catches up after a long gap (app was backgrounded)', () {
      c.toggle();
      clock = clock.add(const Duration(seconds: 45));
      c.tick();
      expect(c.remaining.value, 15);
    });

    test('pause keeps remaining time and resume continues from it', () {
      c.toggle();
      clock = clock.add(const Duration(seconds: 20));
      c.tick();
      c.toggle();
      expect(c.running.value, isFalse);
      clock = clock.add(const Duration(minutes: 5));
      c.tick();
      expect(c.remaining.value, 40);
      c.toggle();
      clock = clock.add(const Duration(seconds: 10));
      c.tick();
      expect(c.remaining.value, 30);
    });

    test('finishes exactly once and stops', () {
      c.toggle();
      clock = clock.add(const Duration(seconds: 61));
      c.tick();
      expect(c.remaining.value, 0);
      expect(c.running.value, isFalse);
      expect(finished, 1);
      c.tick();
      expect(finished, 1);
    });

    test('starting a finished timer restarts from the full duration', () {
      c.toggle();
      clock = clock.add(const Duration(seconds: 60));
      c.tick();
      c.toggle();
      expect(c.remaining.value, 60);
      expect(c.running.value, isTrue);
    });

    test('reset with a new duration', () {
      c.reset(300);
      expect(c.totalSeconds, 300);
      expect(c.remaining.value, 300);
      expect(c.running.value, isFalse);
      expect(c.progress, 1.0);
    });
  });

  group('StopwatchController', () {
    late DateTime clock;
    late StopwatchController c;

    setUp(() {
      clock = DateTime(2026, 1, 1);
      c = StopwatchController(now: () => clock);
    });
    tearDown(() => c.dispose());

    test('measures elapsed time and resumes after pause', () {
      c.toggle();
      clock = clock.add(const Duration(milliseconds: 1500));
      c.tick();
      expect(c.elapsedMs.value, 1500);
      c.toggle();
      clock = clock.add(const Duration(seconds: 30));
      c.toggle();
      clock = clock.add(const Duration(milliseconds: 500));
      c.tick();
      expect(c.elapsedMs.value, 2000);
    });

    test('records laps newest first, only while running', () {
      c.lap();
      expect(c.laps.value, isEmpty);
      c.toggle();
      clock = clock.add(const Duration(seconds: 1));
      c.tick();
      c.lap();
      clock = clock.add(const Duration(seconds: 1));
      c.tick();
      c.lap();
      expect(c.laps.value, [2000, 1000]);
    });

    test('reset clears time and laps', () {
      c.toggle();
      clock = clock.add(const Duration(seconds: 1));
      c.tick();
      c.lap();
      c.reset();
      expect(c.running.value, isFalse);
      expect(c.elapsedMs.value, 0);
      expect(c.laps.value, isEmpty);
    });
  });
}
