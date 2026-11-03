import 'package:shared_preferences/shared_preferences.dart';

import '../models/time_mode.dart';
import '../theme/clock_font.dart';
import '../theme/clock_theme.dart';

/// User preferences and last-used values that survive app restarts.
class AppSettings {
  final TimeMode mode;
  final int themeIndex;
  final int fontIndex;
  final bool is12Hour;
  final bool showSeconds;
  final bool showDate;
  final bool enableGlow;
  final bool colonBlink;
  final bool burnInProtection;
  final bool keepAwake;
  final DateTime countdownTarget;
  final String countdownTitle;
  final int timerTotalSeconds;

  const AppSettings({
    required this.mode,
    required this.themeIndex,
    required this.fontIndex,
    required this.is12Hour,
    required this.showSeconds,
    required this.showDate,
    required this.enableGlow,
    required this.colonBlink,
    required this.burnInProtection,
    required this.keepAwake,
    required this.countdownTarget,
    required this.countdownTitle,
    required this.timerTotalSeconds,
  });

  factory AppSettings.defaults([DateTime? now]) => AppSettings(
    mode: TimeMode.clock,
    themeIndex: 0,
    fontIndex: 0,
    is12Hour: false,
    showSeconds: true,
    showDate: true,
    enableGlow: true,
    colonBlink: true,
    burnInProtection: true,
    keepAwake: true,
    countdownTarget: (now ?? DateTime.now()).add(
      const Duration(days: 7, hours: 14),
    ),
    countdownTitle: 'PROJECT LAUNCH',
    timerTotalSeconds: 25 * 60,
  );

  AppSettings copyWith({
    TimeMode? mode,
    int? themeIndex,
    int? fontIndex,
    bool? is12Hour,
    bool? showSeconds,
    bool? showDate,
    bool? enableGlow,
    bool? colonBlink,
    bool? burnInProtection,
    bool? keepAwake,
    DateTime? countdownTarget,
    String? countdownTitle,
    int? timerTotalSeconds,
  }) => AppSettings(
    mode: mode ?? this.mode,
    themeIndex: themeIndex ?? this.themeIndex,
    fontIndex: fontIndex ?? this.fontIndex,
    is12Hour: is12Hour ?? this.is12Hour,
    showSeconds: showSeconds ?? this.showSeconds,
    showDate: showDate ?? this.showDate,
    enableGlow: enableGlow ?? this.enableGlow,
    colonBlink: colonBlink ?? this.colonBlink,
    burnInProtection: burnInProtection ?? this.burnInProtection,
    keepAwake: keepAwake ?? this.keepAwake,
    countdownTarget: countdownTarget ?? this.countdownTarget,
    countdownTitle: countdownTitle ?? this.countdownTitle,
    timerTotalSeconds: timerTotalSeconds ?? this.timerTotalSeconds,
  );
}

/// Reads and writes [AppSettings] through `shared_preferences`.
class SettingsStore {
  SettingsStore(this._prefs);

  final SharedPreferences _prefs;

  static Future<SettingsStore> open() async =>
      SettingsStore(await SharedPreferences.getInstance());

  /// Loads saved settings; missing or out-of-range values fall back to defaults.
  AppSettings load([DateTime? now]) {
    final d = AppSettings.defaults(now);
    final modeIndex = _prefs.getInt('mode') ?? d.mode.index;
    final targetMs = _prefs.getInt('countdownTarget');
    final timerSecs = _prefs.getInt('timerTotalSeconds') ?? d.timerTotalSeconds;

    return AppSettings(
      mode: modeIndex >= 0 && modeIndex < TimeMode.values.length
          ? TimeMode.values[modeIndex]
          : d.mode,
      themeIndex: _index('themeIndex', kThemes.length, d.themeIndex),
      fontIndex: _index('fontIndex', kFonts.length, d.fontIndex),
      is12Hour: _prefs.getBool('is12Hour') ?? d.is12Hour,
      showSeconds: _prefs.getBool('showSeconds') ?? d.showSeconds,
      showDate: _prefs.getBool('showDate') ?? d.showDate,
      enableGlow: _prefs.getBool('enableGlow') ?? d.enableGlow,
      colonBlink: _prefs.getBool('colonBlink') ?? d.colonBlink,
      burnInProtection:
          _prefs.getBool('burnInProtection') ?? d.burnInProtection,
      keepAwake: _prefs.getBool('keepAwake') ?? d.keepAwake,
      countdownTarget: targetMs == null
          ? d.countdownTarget
          : DateTime.fromMillisecondsSinceEpoch(targetMs),
      countdownTitle: _prefs.getString('countdownTitle') ?? d.countdownTitle,
      timerTotalSeconds: timerSecs > 0 ? timerSecs : d.timerTotalSeconds,
    );
  }

  Future<void> save(AppSettings s) async {
    await Future.wait([
      _prefs.setInt('mode', s.mode.index),
      _prefs.setInt('themeIndex', s.themeIndex),
      _prefs.setInt('fontIndex', s.fontIndex),
      _prefs.setBool('is12Hour', s.is12Hour),
      _prefs.setBool('showSeconds', s.showSeconds),
      _prefs.setBool('showDate', s.showDate),
      _prefs.setBool('enableGlow', s.enableGlow),
      _prefs.setBool('colonBlink', s.colonBlink),
      _prefs.setBool('burnInProtection', s.burnInProtection),
      _prefs.setBool('keepAwake', s.keepAwake),
      _prefs.setInt(
        'countdownTarget',
        s.countdownTarget.millisecondsSinceEpoch,
      ),
      _prefs.setString('countdownTitle', s.countdownTitle),
      _prefs.setInt('timerTotalSeconds', s.timerTotalSeconds),
    ]);
  }

  int _index(String key, int length, int fallback) {
    final v = _prefs.getInt(key);
    return v != null && v >= 0 && v < length ? v : fallback;
  }
}
