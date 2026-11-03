import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Keeps the display on while the clock is in the foreground.
class ScreenAwake {
  static Future<void> set(bool enabled) async {
    try {
      await WakelockPlus.toggle(enable: enabled);
    } catch (_) {
      // Platform channel unavailable (tests, unsupported platform).
    }
  }
}

/// Audible and tactile alerts.
class Alerts {
  static void tap() => HapticFeedback.selectionClick();

  /// Plays the system alert sound and vibrates three times.
  static Future<void> timerFinished() async {
    for (var i = 0; i < 3; i++) {
      await SystemSound.play(SystemSoundType.alert);
      await HapticFeedback.vibrate();
      await Future<void>.delayed(const Duration(milliseconds: 700));
    }
  }
}
