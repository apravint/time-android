import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'logic/time_logic.dart';
import 'models/time_mode.dart';
import 'services/device_services.dart';
import 'services/settings_store.dart';
import 'theme/clock_font.dart';
import 'theme/clock_theme.dart';
import 'views/clock_view.dart';
import 'views/countdown_view.dart';
import 'views/display_style.dart';
import 'views/stopwatch_view.dart';
import 'views/timer_view.dart';
import 'widgets/design_studio_sheet.dart';
import 'widgets/hud.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SettingsStore? store;
  try {
    store = await SettingsStore.open();
  } catch (_) {
    // Run with defaults if storage is unavailable.
  }
  runApp(ChronoCraftApp(store: store, initialSettings: store?.load()));
}

class ChronoCraftApp extends StatefulWidget {
  const ChronoCraftApp({super.key, this.store, this.initialSettings});

  /// Where settings are persisted; null disables persistence.
  final SettingsStore? store;
  final AppSettings? initialSettings;

  @override
  State<ChronoCraftApp> createState() => _ChronoCraftAppState();
}

class _ChronoCraftAppState extends State<ChronoCraftApp>
    with WidgetsBindingObserver {
  static const _burnInInterval = Duration(minutes: 3);

  late final ValueNotifier<AppSettings> _settings;
  late final FocusTimerController _timer;
  late final StopwatchController _stopwatch;
  final ValueNotifier<DateTime> _now = ValueNotifier<DateTime>(DateTime.now());

  bool _controlsVisible = false;
  Timer? _hideTimer;
  Timer? _clockTicker;
  Duration? _clockInterval;

  // Burn-in micro-shift offsets
  double _burnInX = 0;
  double _burnInY = 0;
  int _burnInStep = 0;
  DateTime _lastBurnInShift = DateTime.now();

  AppSettings get _s => _settings.value;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final initial = widget.initialSettings ?? AppSettings.defaults();
    _settings = ValueNotifier<AppSettings>(initial);
    _timer = FocusTimerController(
      totalSeconds: initial.timerTotalSeconds,
      onFinished: Alerts.timerFinished,
    );
    _stopwatch = StopwatchController();
    _syncClockTicker();
    ScreenAwake.set(initial.keepAwake);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _clockTicker?.cancel();
    _hideTimer?.cancel();
    _timer.dispose();
    _stopwatch.dispose();
    _now.dispose();
    _settings.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _now.value = DateTime.now();
      _timer.tick();
      ScreenAwake.set(_s.keepAwake);
    }
  }

  // --- Settings -----------------------------------------------------------

  void _update(AppSettings Function(AppSettings current) change) {
    final before = _s;
    final after = change(before);
    setState(() => _settings.value = after);
    widget.store?.save(after);
    if (after.keepAwake != before.keepAwake) ScreenAwake.set(after.keepAwake);
    if (after.mode != before.mode || after.colonBlink != before.colonBlink) {
      _syncClockTicker();
    }
  }

  /// Ticks fast enough for the blinking colon only when it is visible;
  /// otherwise a slower tick is enough for seconds and countdowns.
  void _syncClockTicker() {
    final interval = (_s.mode == TimeMode.clock && _s.colonBlink)
        ? const Duration(milliseconds: 100)
        : const Duration(milliseconds: 250);
    if (_clockInterval == interval) return;
    _clockInterval = interval;
    _clockTicker?.cancel();
    _clockTicker = Timer.periodic(interval, (_) => _onClockTick());
  }

  void _onClockTick() {
    final now = DateTime.now();
    _now.value = now;
    if (_s.burnInProtection &&
        now.difference(_lastBurnInShift) >= _burnInInterval) {
      _lastBurnInShift = now;
      _burnInStep++;
      setState(() {
        // Micro-shift by 1.5px periodically to protect OLED displays
        _burnInX = (_burnInStep % 3 - 1) * 1.5;
        _burnInY = ((_burnInStep ~/ 3) % 3 - 1) * 1.5;
      });
    }
  }

  // --- Controls -----------------------------------------------------------

  void _showControls() {
    setState(() => _controlsVisible = true);
    _resetHideTimer();
  }

  void _hideControls() {
    _hideTimer?.cancel();
    setState(() => _controlsVisible = false);
  }

  void _toggleControls() {
    Alerts.tap();
    _controlsVisible ? _hideControls() : _showControls();
  }

  void _resetHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _controlsVisible) {
        setState(() => _controlsVisible = false);
      }
    });
  }

  void _cycleTheme(int delta) {
    Alerts.tap();
    _update(
      (s) => s.copyWith(
        themeIndex: (s.themeIndex + delta + kThemes.length) % kThemes.length,
      ),
    );
    _resetHideTimer();
  }

  void _nextFont() {
    Alerts.tap();
    _update((s) => s.copyWith(fontIndex: (s.fontIndex + 1) % kFonts.length));
    _resetHideTimer();
  }

  void _setMode(TimeMode mode) {
    Alerts.tap();
    _update((s) => s.copyWith(mode: mode));
    _resetHideTimer();
  }

  void _cycleMode(int delta) {
    final n = TimeMode.values.length;
    _setMode(TimeMode.values[(_s.mode.index + delta + n) % n]);
  }

  void _setTimerDuration(int seconds) {
    Alerts.tap();
    _timer.reset(seconds);
    _update((s) => s.copyWith(timerTotalSeconds: seconds));
  }

  void _openDesignStudio() {
    Alerts.tap();
    _hideControls();
    showModalBottomSheet<void>(
      context: _navigatorContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DesignStudioSheet(
        settings: _settings,
        onUpdate: _update,
        onSetCountdownTarget: (dt, title) => _update(
          (s) => s.copyWith(countdownTarget: dt, countdownTitle: title),
        ),
        onSetTimerDuration: _setTimerDuration,
      ),
    );
  }

  /// Context below the MaterialApp's Navigator (needed to show sheets).
  BuildContext? _navigatorContext;

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.keyT) {
      _cycleTheme(HardwareKeyboard.instance.isShiftPressed ? -1 : 1);
    } else if (key == LogicalKeyboardKey.keyF) {
      _nextFont();
    } else if (key == LogicalKeyboardKey.space) {
      if (_s.mode == TimeMode.timer) _timer.toggle();
      if (_s.mode == TimeMode.stopwatch) _stopwatch.toggle();
    } else if (key == LogicalKeyboardKey.keyM) {
      _cycleMode(1);
    } else if (key == LogicalKeyboardKey.keyS) {
      _update((s) => s.copyWith(showSeconds: !s.showSeconds));
    } else if (key == LogicalKeyboardKey.escape) {
      _toggleControls();
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  // --- Build --------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final s = _s;
    final theme = kThemes[s.themeIndex];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: theme.background,
      ),
      home: Builder(
        builder: (context) {
          _navigatorContext = context;
          final isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;
          final style = DisplayStyle(
            theme: theme,
            font: kFonts[s.fontIndex],
            isLandscape: isLandscape,
            enableGlow: s.enableGlow,
          );

          return Scaffold(
            backgroundColor: theme.background,
            body: Focus(
              autofocus: true,
              onKeyEvent: _onKey,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggleControls,
                onDoubleTap: () => _cycleTheme(1),
                onLongPress: _openDesignStudio,
                onVerticalDragEnd: (d) {
                  final v = d.primaryVelocity;
                  if (v == null) return;
                  if (v < -200) _cycleTheme(1);
                  if (v > 200) _cycleTheme(-1);
                },
                onHorizontalDragEnd: (d) {
                  final v = d.primaryVelocity;
                  if (v == null) return;
                  if (v < -200) _cycleMode(1);
                  if (v > 200) _cycleMode(-1);
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Transform.translate(
                        offset: Offset(_burnInX, _burnInY),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isLandscape ? 16 : 8,
                            vertical: isLandscape ? 8 : 16,
                          ),
                          child: Center(child: _buildContent(style, s)),
                        ),
                      ),
                    ),
                    HudTopBar(
                      visible: _controlsVisible,
                      theme: theme,
                      mode: s.mode,
                      fontName: kFonts[s.fontIndex].name,
                      onOpenStudio: _openDesignStudio,
                      onNextTheme: () => _cycleTheme(1),
                      onHide: _hideControls,
                    ),
                    HudBottomBar(
                      visible: _controlsVisible,
                      theme: theme,
                      mode: s.mode,
                      timer: _timer,
                      stopwatch: _stopwatch,
                      onSetMode: _setMode,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(DisplayStyle style, AppSettings s) {
    switch (s.mode) {
      case TimeMode.clock:
        return ClockView(
          style: style,
          now: _now,
          is12Hour: s.is12Hour,
          showSeconds: s.showSeconds,
          showDate: s.showDate,
          colonBlink: s.colonBlink,
        );
      case TimeMode.countdown:
        return CountdownView(
          style: style,
          now: _now,
          target: s.countdownTarget,
          title: s.countdownTitle,
        );
      case TimeMode.timer:
        return TimerView(style: style, controller: _timer);
      case TimeMode.stopwatch:
        return StopwatchView(style: style, controller: _stopwatch);
    }
  }
}
