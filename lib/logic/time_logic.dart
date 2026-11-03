import 'dart:async';

import 'package:flutter/foundation.dart';

/// Injectable wall clock so controllers can be tested deterministically.
typedef NowProvider = DateTime Function();

/// Remaining time to a countdown target, split into display units.
class CountdownParts {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final bool expired;

  const CountdownParts({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.expired,
  });
}

CountdownParts countdownParts(DateTime target, DateTime now) {
  final diff = target.difference(now);
  if (diff.isNegative || diff == Duration.zero) {
    return const CountdownParts(
      days: 0,
      hours: 0,
      minutes: 0,
      seconds: 0,
      expired: true,
    );
  }
  return CountdownParts(
    days: diff.inDays,
    hours: diff.inHours % 24,
    minutes: diff.inMinutes % 60,
    seconds: diff.inSeconds % 60,
    expired: false,
  );
}

/// Fraction of the local day that has elapsed (0.0 - 1.0).
double dayProgress(DateTime now) =>
    (now.hour * 3600 + now.minute * 60 + now.second) / 86400;

String two(int v) => v.toString().padLeft(2, '0');

/// `MM:SS` for the focus timer.
String formatTimer(int seconds) => '${two(seconds ~/ 60)}:${two(seconds % 60)}';

/// Stopwatch milliseconds split as `MM:SS` and hundredths.
class StopwatchParts {
  final String minutesSeconds;
  final String hundredths;

  const StopwatchParts(this.minutesSeconds, this.hundredths);

  String get full => '$minutesSeconds.$hundredths';
}

StopwatchParts splitStopwatch(int milliseconds) {
  final totalSeconds = milliseconds ~/ 1000;
  return StopwatchParts(
    '${two(totalSeconds ~/ 60)}:${two(totalSeconds % 60)}',
    two((milliseconds % 1000) ~/ 10),
  );
}

/// Countdown timer anchored to an absolute end time, so it stays accurate
/// when the app is backgrounded or the event loop is delayed.
class FocusTimerController {
  FocusTimerController({
    int totalSeconds = 25 * 60,
    NowProvider? now,
    this.onFinished,
  }) : _now = now ?? DateTime.now,
       _totalSeconds = totalSeconds,
       remaining = ValueNotifier<int>(totalSeconds);

  final NowProvider _now;
  final VoidCallback? onFinished;

  /// Whole seconds left on the clock.
  final ValueNotifier<int> remaining;
  final ValueNotifier<bool> running = ValueNotifier<bool>(false);

  int _totalSeconds;
  DateTime? _endsAt;
  Timer? _ticker;

  int get totalSeconds => _totalSeconds;

  double get progress =>
      _totalSeconds > 0 ? remaining.value / _totalSeconds : 0.0;

  void toggle() {
    if (running.value) {
      _stop();
      return;
    }
    if (remaining.value <= 0) remaining.value = _totalSeconds;
    _endsAt = _now().add(Duration(seconds: remaining.value));
    running.value = true;
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) => tick());
  }

  void reset([int? seconds]) {
    _stop();
    if (seconds != null) _totalSeconds = seconds;
    remaining.value = _totalSeconds;
  }

  /// Recomputes the remaining time from the wall clock (also called on resume).
  void tick() {
    final endsAt = _endsAt;
    if (endsAt == null) return;
    final ms = endsAt.difference(_now()).inMilliseconds;
    final secs = ms <= 0 ? 0 : (ms + 999) ~/ 1000;
    remaining.value = secs;
    if (secs == 0) {
      _stop();
      onFinished?.call();
    }
  }

  void _stop() {
    _ticker?.cancel();
    _ticker = null;
    _endsAt = null;
    running.value = false;
  }

  void dispose() {
    _ticker?.cancel();
    remaining.dispose();
    running.dispose();
  }
}

/// Stopwatch with lap recording, driven by the wall clock.
class StopwatchController {
  StopwatchController({NowProvider? now}) : _now = now ?? DateTime.now;

  final NowProvider _now;

  final ValueNotifier<int> elapsedMs = ValueNotifier<int>(0);
  final ValueNotifier<bool> running = ValueNotifier<bool>(false);

  /// Laps, newest first.
  final ValueNotifier<List<int>> laps = ValueNotifier<List<int>>(const []);

  DateTime? _startedAt;
  Timer? _ticker;

  void toggle() {
    if (running.value) {
      tick();
      _ticker?.cancel();
      _ticker = null;
      running.value = false;
      return;
    }
    _startedAt = _now().subtract(Duration(milliseconds: elapsedMs.value));
    running.value = true;
    _ticker = Timer.periodic(const Duration(milliseconds: 16), (_) => tick());
  }

  void lap() {
    if (!running.value) return;
    laps.value = [elapsedMs.value, ...laps.value];
  }

  void reset() {
    _ticker?.cancel();
    _ticker = null;
    running.value = false;
    elapsedMs.value = 0;
    laps.value = const [];
  }

  void tick() {
    final start = _startedAt;
    if (start == null) return;
    elapsedMs.value = _now().difference(start).inMilliseconds;
  }

  void dispose() {
    _ticker?.cancel();
    elapsedMs.dispose();
    running.dispose();
    laps.dispose();
  }
}
