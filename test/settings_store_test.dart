import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_app/models/time_mode.dart';
import 'package:time_app/services/settings_store.dart';
import 'package:time_app/theme/clock_theme.dart';

void main() {
  Future<SettingsStore> storeWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return SettingsStore.open();
  }

  test('returns defaults when nothing is saved', () async {
    final now = DateTime(2026, 1, 1);
    final s = (await storeWith({})).load(now);
    final d = AppSettings.defaults(now);
    expect(s.mode, d.mode);
    expect(s.themeIndex, 0);
    expect(s.keepAwake, isTrue);
    expect(s.countdownTarget, d.countdownTarget);
    expect(s.timerTotalSeconds, 25 * 60);
  });

  test('round-trips every field', () async {
    final store = await storeWith({});
    final saved = AppSettings.defaults().copyWith(
      mode: TimeMode.stopwatch,
      themeIndex: 3,
      fontIndex: 2,
      is12Hour: true,
      showSeconds: false,
      showDate: false,
      enableGlow: false,
      colonBlink: false,
      burnInProtection: false,
      keepAwake: false,
      countdownTarget: DateTime(2030, 5, 6, 7, 8),
      countdownTitle: 'EXAM',
      timerTotalSeconds: 45 * 60,
    );
    await store.save(saved);
    final loaded = store.load();
    expect(loaded.mode, TimeMode.stopwatch);
    expect(loaded.themeIndex, 3);
    expect(loaded.fontIndex, 2);
    expect(loaded.is12Hour, isTrue);
    expect(loaded.showSeconds, isFalse);
    expect(loaded.showDate, isFalse);
    expect(loaded.enableGlow, isFalse);
    expect(loaded.colonBlink, isFalse);
    expect(loaded.burnInProtection, isFalse);
    expect(loaded.keepAwake, isFalse);
    expect(loaded.countdownTarget, DateTime(2030, 5, 6, 7, 8));
    expect(loaded.countdownTitle, 'EXAM');
    expect(loaded.timerTotalSeconds, 45 * 60);
  });

  test('ignores out-of-range indices and bad durations', () async {
    final s = (await storeWith({
      'themeIndex': kThemes.length + 5,
      'fontIndex': -1,
      'mode': 99,
      'timerTotalSeconds': 0,
    })).load();
    expect(s.themeIndex, 0);
    expect(s.fontIndex, 0);
    expect(s.mode, TimeMode.clock);
    expect(s.timerTotalSeconds, 25 * 60);
  });
}
