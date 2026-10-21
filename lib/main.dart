import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const ChronoCraftApp());
}

/// Available clock operating modes
enum TimeMode { clock, countdown, timer, stopwatch }

/// Curated high-performance horology themes
class ClockTheme {
  final String name;
  final String category;
  final Color background;
  final Color primary;
  final Color accent;
  final Color secondary;
  final Color surface;
  final Color border;
  final Color glow;
  final bool isDark;

  const ClockTheme({
    required this.name,
    required this.category,
    required this.background,
    required this.primary,
    required this.accent,
    required this.secondary,
    required this.surface,
    required this.border,
    required this.glow,
    required this.isDark,
  });
}

const List<ClockTheme> kThemes = [
  // 1. OLED Pitch Black
  ClockTheme(
    name: 'OLED Void',
    category: 'OLED Minimal',
    background: Color(0xFF000000),
    primary: Color(0xFFFFFFFF),
    accent: Color(0xFF9E9E9E),
    secondary: Color(0xFF424242),
    surface: Color(0xFF121212),
    border: Color(0xFF262626),
    glow: Color(0x33FFFFFF),
    isDark: true,
  ),
  // 2. Cyberpunk Electric Cyan & Magenta
  ClockTheme(
    name: 'Cyberpunk Neon',
    category: 'Cyberpunk',
    background: Color(0xFF05050A),
    primary: Color(0xFF00F0FF),
    accent: Color(0xFFFF0055),
    secondary: Color(0xFF7000FF),
    surface: Color(0xFF0F0F1A),
    border: Color(0xFF00F0FF),
    glow: Color(0x8000F0FF),
    isDark: true,
  ),
  // 3. Tokyo Midnight Slate
  ClockTheme(
    name: 'Tokyo Midnight',
    category: 'Dark Studio',
    background: Color(0xFF1A1B26),
    primary: Color(0xFF7AA2F7),
    accent: Color(0xFFBB9AF7),
    secondary: Color(0xFF73DACA),
    surface: Color(0xFF24283B),
    border: Color(0xFF414868),
    glow: Color(0x407AA2F7),
    isDark: true,
  ),
  // 4. Solar Amber Cockpit
  ClockTheme(
    name: 'Solar Amber',
    category: 'Aviation',
    background: Color(0xFF070500),
    primary: Color(0xFFFFB000),
    accent: Color(0xFFFF5500),
    secondary: Color(0xFFFFCC33),
    surface: Color(0xFF140D00),
    border: Color(0xFFFFB000),
    glow: Color(0x66FFB000),
    isDark: true,
  ),
  // 5. Matrix CRT Terminal
  ClockTheme(
    name: 'Matrix CRT',
    category: 'Terminal',
    background: Color(0xFF000F04),
    primary: Color(0xFF00FF66),
    accent: Color(0xFF33FF99),
    secondary: Color(0xFF008833),
    surface: Color(0xFF051C0A),
    border: Color(0xFF00FF66),
    glow: Color(0x7700FF66),
    isDark: true,
  ),
  // 6. Synthwave 1984
  ClockTheme(
    name: 'Synthwave 84',
    category: 'Retro',
    background: Color(0xFF150026),
    primary: Color(0xFFFF2A85),
    accent: Color(0xFF00FFF0),
    secondary: Color(0xFFFFB800),
    surface: Color(0xFF240040),
    border: Color(0xFFFF2A85),
    glow: Color(0x66FF2A85),
    isDark: true,
  ),
  // 7. Nordic Frost Glacier
  ClockTheme(
    name: 'Nordic Frost',
    category: 'Minimal',
    background: Color(0xFF0B1017),
    primary: Color(0xFF58A6FF),
    accent: Color(0xFF79C0FF),
    secondary: Color(0xFF388BFD),
    surface: Color(0xFF161F2C),
    border: Color(0xFF303E54),
    glow: Color(0x4058A6FF),
    isDark: true,
  ),
  // 8. Dieter Rams / Braun Bauhaus
  ClockTheme(
    name: 'Braun Bauhaus',
    category: 'Industrial',
    background: Color(0xFFECE8E1),
    primary: Color(0xFF161616),
    accent: Color(0xFFFF5500),
    secondary: Color(0xFF5E5E5E),
    surface: Color(0xFFDDD8D0),
    border: Color(0xFF161616),
    glow: Color(0x00000000),
    isDark: false,
  ),
  // 9. Ferrari Scuderia Corsa
  ClockTheme(
    name: 'Ferrari Corsa',
    category: 'Motorsport',
    background: Color(0xFF080808),
    primary: Color(0xFFFF1801),
    accent: Color(0xFFFFFFFF),
    secondary: Color(0xFFFF8000),
    surface: Color(0xFF1A1A1A),
    border: Color(0xFFFF1801),
    glow: Color(0x66FF1801),
    isDark: true,
  ),
  // 10. Royal Emerald & Brass
  ClockTheme(
    name: 'Emerald Royale',
    category: 'Horology',
    background: Color(0xFF04140C),
    primary: Color(0xFFF3C761),
    accent: Color(0xFF4ECCA3),
    secondary: Color(0xFF2E8B57),
    surface: Color(0xFF0C2417),
    border: Color(0xFFF3C761),
    glow: Color(0x40F3C761),
    isDark: true,
  ),
  // 11. Dracula Twilight
  ClockTheme(
    name: 'Dracula',
    category: 'Dark Studio',
    background: Color(0xFF1E1F29),
    primary: Color(0xFFBD93F9),
    accent: Color(0xFFFF79C6),
    secondary: Color(0xFF8BE9FD),
    surface: Color(0xFF282A36),
    border: Color(0xFF6272A4),
    glow: Color(0x55BD93F9),
    isDark: true,
  ),
  // 12. Monokai Pro
  ClockTheme(
    name: 'Monokai Pro',
    category: 'Developer',
    background: Color(0xFF222222),
    primary: Color(0xFFFFD866),
    accent: Color(0xFFA9DC76),
    secondary: Color(0xFFFF6188),
    surface: Color(0xFF2D2A2E),
    border: Color(0xFF403E41),
    glow: Color(0x40FFD866),
    isDark: true,
  ),
  // 13. Japanese Sumi & Washi Paper
  ClockTheme(
    name: 'Sumi Paper',
    category: 'Organic',
    background: Color(0xFFF6F4EB),
    primary: Color(0xFF1C1C1C),
    accent: Color(0xFFBA1B1D),
    secondary: Color(0xFF555555),
    surface: Color(0xFFEBE7DB),
    border: Color(0xFF1C1C1C),
    glow: Color(0x00000000),
    isDark: false,
  ),
  // 14. Deep Abyss Cobalt
  ClockTheme(
    name: 'Abyss Cobalt',
    category: 'Sci-Fi',
    background: Color(0xFF020B1A),
    primary: Color(0xFF00D2FF),
    accent: Color(0xFF3A7BD5),
    secondary: Color(0xFF64FFDA),
    surface: Color(0xFF0B1930),
    border: Color(0xFF00D2FF),
    glow: Color(0x6000D2FF),
    isDark: true,
  ),
  // 15. Lilac Dusk
  ClockTheme(
    name: 'Lilac Dusk',
    category: 'Dreamscape',
    background: Color(0xFF13111C),
    primary: Color(0xFFD8B4FE),
    accent: Color(0xFFF472B6),
    secondary: Color(0xFFA78BFA),
    surface: Color(0xFF201B30),
    border: Color(0xFFD8B4FE),
    glow: Color(0x50D8B4FE),
    isDark: true,
  ),
  // 16. Sunset Horizons
  ClockTheme(
    name: 'Sunset Horizons',
    category: 'Atmospheric',
    background: Color(0xFF0F0814),
    primary: Color(0xFFFB923C),
    accent: Color(0xFFF43F5E),
    secondary: Color(0xFFFBBF24),
    surface: Color(0xFF21132C),
    border: Color(0xFFFB923C),
    glow: Color(0x55FB923C),
    isDark: true,
  ),
  // 17. Gruvbox Retro Basalt
  ClockTheme(
    name: 'Gruvbox Dark',
    category: 'Retro',
    background: Color(0xFF1D2021),
    primary: Color(0xFFFABD2F),
    accent: Color(0xFFFE8019),
    secondary: Color(0xFFB8BB26),
    surface: Color(0xFF282828),
    border: Color(0xFF504945),
    glow: Color(0x40FABD2F),
    isDark: true,
  ),
  // 18. Acid Techno Radioactive
  ClockTheme(
    name: 'Acid Techno',
    category: 'Brutalist',
    background: Color(0xFF000000),
    primary: Color(0xFFCCFF00),
    accent: Color(0xFF00FFA3),
    secondary: Color(0xFFFFFFFF),
    surface: Color(0xFF12140A),
    border: Color(0xFFCCFF00),
    glow: Color(0x77CCFF00),
    isDark: true,
  ),
  // 19. Arctic Clean Modern
  ClockTheme(
    name: 'Arctic Snow',
    category: 'Minimal Light',
    background: Color(0xFFF8FAFC),
    primary: Color(0xFF0F172A),
    accent: Color(0xFF0284C7),
    secondary: Color(0xFF64748B),
    surface: Color(0xFFE2E8F0),
    border: Color(0xFF0F172A),
    glow: Color(0x00000000),
    isDark: false,
  ),
  // 20. Vaporwave Pastel Glow
  ClockTheme(
    name: 'Vaporwave',
    category: 'Retro',
    background: Color(0xFF1D0E36),
    primary: Color(0xFFFF71CE),
    accent: Color(0xFF01CDFE),
    secondary: Color(0xFF05FFA1),
    surface: Color(0xFF2D1850),
    border: Color(0xFFFF71CE),
    glow: Color(0x66FF71CE),
    isDark: true,
  ),
  // 21. Zen Bamboo Garden
  ClockTheme(
    name: 'Zen Bamboo',
    category: 'Organic',
    background: Color(0xFF0C140E),
    primary: Color(0xFFA3E635),
    accent: Color(0xFF4ADE80),
    secondary: Color(0xFF22C55E),
    surface: Color(0xFF17241A),
    border: Color(0xFFA3E635),
    glow: Color(0x40A3E635),
    isDark: true,
  ),
  // 22. Stealth Bomber Graphite
  ClockTheme(
    name: 'Stealth Bomber',
    category: 'Tactical',
    background: Color(0xFF121214),
    primary: Color(0xFFEF4444),
    accent: Color(0xFFF97316),
    secondary: Color(0xFF71717A),
    surface: Color(0xFF1C1C20),
    border: Color(0xFFEF4444),
    glow: Color(0x55EF4444),
    isDark: true,
  ),
  // 23. Tiffany Diamond
  ClockTheme(
    name: 'Tiffany Cyan',
    category: 'Luxury',
    background: Color(0xFF060909),
    primary: Color(0xFF0ABAB5),
    accent: Color(0xFFE2F8F7),
    secondary: Color(0xFF56DFDB),
    surface: Color(0xFF0F1818),
    border: Color(0xFF0ABAB5),
    glow: Color(0x500ABAB5),
    isDark: true,
  ),
  // 24. Vintage Gold Pocketwatch
  ClockTheme(
    name: 'Chronograph Gold',
    category: 'Horology',
    background: Color(0xFF110E0A),
    primary: Color(0xFFFFD700),
    accent: Color(0xFFFFA500),
    secondary: Color(0xFFE6C280),
    surface: Color(0xFF241C14),
    border: Color(0xFFFFD700),
    glow: Color(0x50FFD700),
    isDark: true,
  ),
];

/// Curated designer typography styles
class ClockFont {
  final String name;
  final String style;
  final TextStyle Function(TextStyle base) builder;

  const ClockFont({
    required this.name,
    required this.style,
    required this.builder,
  });
}

final List<ClockFont> kFonts = [
  ClockFont(
    name: 'Bebas Neue',
    style: 'Bold Condensed Horology',
    builder: (b) => GoogleFonts.bebasNeue(textStyle: b),
  ),
  ClockFont(
    name: 'Orbitron',
    style: 'Sci-Fi Cyberpunk',
    builder: (b) => GoogleFonts.orbitron(textStyle: b),
  ),
  ClockFont(
    name: 'Space Mono',
    style: 'Hacker Terminal Monospace',
    builder: (b) => GoogleFonts.spaceMono(textStyle: b),
  ),
  ClockFont(
    name: 'Oswald',
    style: 'Industrial Architecture',
    builder: (b) => GoogleFonts.oswald(textStyle: b),
  ),
  ClockFont(
    name: 'Montserrat',
    style: 'Clean Geometric Bauhaus',
    builder: (b) => GoogleFonts.montserrat(textStyle: b),
  ),
  ClockFont(
    name: 'Playfair Display',
    style: 'Luxury Swiss Horology Serif',
    builder: (b) => GoogleFonts.playfairDisplay(textStyle: b),
  ),
  ClockFont(
    name: 'Syne',
    style: 'Radical Avant-Garde',
    builder: (b) => GoogleFonts.syne(textStyle: b),
  ),
  ClockFont(
    name: 'JetBrains Mono',
    style: 'Precision Engineering',
    builder: (b) => GoogleFonts.jetBrainsMono(textStyle: b),
  ),
  ClockFont(
    name: 'Anton',
    style: 'Ultra-Heavy Headline',
    builder: (b) => GoogleFonts.anton(textStyle: b),
  ),
  ClockFont(
    name: 'Cinzel',
    style: 'Imperial Chiseled Stone',
    builder: (b) => GoogleFonts.cinzel(textStyle: b),
  ),
  ClockFont(
    name: 'Audiowide',
    style: 'Digital Hypercar Dashboard',
    builder: (b) => GoogleFonts.audiowide(textStyle: b),
  ),
  ClockFont(
    name: 'Comfortaa',
    style: 'Smooth Futuristic Rounded',
    builder: (b) => GoogleFonts.comfortaa(textStyle: b),
  ),
  ClockFont(
    name: 'Righteous',
    style: 'Electric Art Deco',
    builder: (b) => GoogleFonts.righteous(textStyle: b),
  ),
  ClockFont(
    name: 'Silkscreen',
    style: '8-Bit Retro Arcade',
    builder: (b) => GoogleFonts.silkscreen(textStyle: b),
  ),
  ClockFont(
    name: 'Major Mono',
    style: 'Minimalist Abstract Mono',
    builder: (b) => GoogleFonts.majorMonoDisplay(textStyle: b),
  ),
  ClockFont(
    name: 'System Monospace',
    style: 'Offline Hardware Terminal',
    builder: (b) => b.copyWith(fontFamily: 'monospace'),
  ),
];

class ChronoCraftApp extends StatefulWidget {
  const ChronoCraftApp({super.key});

  @override
  State<ChronoCraftApp> createState() => _ChronoCraftAppState();
}

class _ChronoCraftAppState extends State<ChronoCraftApp> {
  // App state
  TimeMode _mode = TimeMode.clock;
  int _themeIndex = 0;
  int _fontIndex = 0;
  bool _is12Hour = false;
  bool _showSeconds = true;
  bool _showDate = true;
  bool _enableGlow = true;
  bool _colonBlink = true;
  bool _burnInProtection = true;
  bool _controlsVisible = false;

  // Auto-hide controls timer
  Timer? _hideTimer;

  // Real-time ticker
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  // Burn-in micro-shift offsets
  double _burnInX = 0;
  double _burnInY = 0;
  int _burnInTicks = 0;

  // Countdown mode state
  DateTime _countdownTarget = DateTime.now().add(const Duration(days: 7, hours: 14));
  String _countdownTitle = 'PROJECT LAUNCH';

  // Focus Timer state
  int _timerTotalSeconds = 25 * 60;
  int _timerRemainingSeconds = 25 * 60;
  bool _isTimerRunning = false;
  Timer? _focusTimerTicker;

  // Precision Stopwatch state
  int _stopwatchMilliseconds = 0;
  bool _isStopwatchRunning = false;
  Timer? _stopwatchTicker;
  final List<int> _laps = [];

  @override
  void initState() {
    super.initState();
    // 60fps tick for stopwatch precision, 1s tick for clock/countdown
    _clockTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
          _burnInTicks++;
          if (_burnInProtection && _burnInTicks % 1800 == 0) {
            // Micro-shift by 1-2px periodically to protect OLED displays
            _burnInX = ((_burnInTicks ~/ 1800) % 3 - 1) * 1.5;
            _burnInY = (((_burnInTicks ~/ 1800) ~/ 3) % 3 - 1) * 1.5;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _hideTimer?.cancel();
    _focusTimerTicker?.cancel();
    _stopwatchTicker?.cancel();
    super.dispose();
  }

  void _triggerHaptic() {
    HapticFeedback.selectionClick();
  }

  void _showControls() {
    setState(() => _controlsVisible = true);
    _resetHideTimer();
  }

  void _hideControls() {
    _hideTimer?.cancel();
    setState(() => _controlsVisible = false);
  }

  void _toggleControls() {
    _triggerHaptic();
    if (_controlsVisible) {
      _hideControls();
    } else {
      _showControls();
    }
  }

  void _resetHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _controlsVisible) {
        setState(() => _controlsVisible = false);
      }
    });
  }

  void _nextTheme() {
    _triggerHaptic();
    setState(() {
      _themeIndex = (_themeIndex + 1) % kThemes.length;
    });
    _resetHideTimer();
  }

  void _prevTheme() {
    _triggerHaptic();
    setState(() {
      _themeIndex = (_themeIndex - 1 + kThemes.length) % kThemes.length;
    });
    _resetHideTimer();
  }

  void _nextFont() {
    _triggerHaptic();
    setState(() {
      _fontIndex = (_fontIndex + 1) % kFonts.length;
    });
    _resetHideTimer();
  }

  void _setMode(TimeMode mode) {
    _triggerHaptic();
    setState(() => _mode = mode);
    _resetHideTimer();
  }

  // Timer controls
  void _toggleTimer() {
    _triggerHaptic();
    setState(() {
      _isTimerRunning = !_isTimerRunning;
      if (_isTimerRunning) {
        _focusTimerTicker = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_timerRemainingSeconds > 0) {
            setState(() => _timerRemainingSeconds--);
          } else {
            _focusTimerTicker?.cancel();
            setState(() => _isTimerRunning = false);
            HapticFeedback.vibrate();
          }
        });
      } else {
        _focusTimerTicker?.cancel();
      }
    });
  }

  void _resetTimer([int? seconds]) {
    _triggerHaptic();
    _focusTimerTicker?.cancel();
    setState(() {
      _isTimerRunning = false;
      if (seconds != null) _timerTotalSeconds = seconds;
      _timerRemainingSeconds = _timerTotalSeconds;
    });
  }

  // Stopwatch controls
  void _toggleStopwatch() {
    _triggerHaptic();
    setState(() {
      _isStopwatchRunning = !_isStopwatchRunning;
      if (_isStopwatchRunning) {
        final start = DateTime.now().millisecondsSinceEpoch - _stopwatchMilliseconds;
        _stopwatchTicker = Timer.periodic(const Duration(milliseconds: 16), (timer) {
          setState(() {
            _stopwatchMilliseconds = DateTime.now().millisecondsSinceEpoch - start;
          });
        });
      } else {
        _stopwatchTicker?.cancel();
      }
    });
  }

  void _resetStopwatch() {
    _triggerHaptic();
    _stopwatchTicker?.cancel();
    setState(() {
      _isStopwatchRunning = false;
      _stopwatchMilliseconds = 0;
      _laps.clear();
    });
  }

  void _recordLap() {
    if (_isStopwatchRunning) {
      _triggerHaptic();
      setState(() {
        _laps.insert(0, _stopwatchMilliseconds);
      });
    }
  }

  TextStyle _getFontStyle(TextStyle base) {
    try {
      final styled = kFonts[_fontIndex].builder(base);
      return styled.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      );
    } catch (_) {
      return base.copyWith(fontFamily: 'monospace');
    }
  }

  void _openDesignStudio() {
    _triggerHaptic();
    _hideControls();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DesignStudioSheet(
        currentThemeIndex: _themeIndex,
        currentFontIndex: _fontIndex,
        is12Hour: _is12Hour,
        showSeconds: _showSeconds,
        showDate: _showDate,
        enableGlow: _enableGlow,
        colonBlink: _colonBlink,
        burnInProtection: _burnInProtection,
        onThemeSelected: (i) => setState(() => _themeIndex = i),
        onFontSelected: (i) => setState(() => _fontIndex = i),
        on12HourChanged: (v) => setState(() => _is12Hour = v),
        onShowSecondsChanged: (v) => setState(() => _showSeconds = v),
        onShowDateChanged: (v) => setState(() => _showDate = v),
        onEnableGlowChanged: (v) => setState(() => _enableGlow = v),
        onColonBlinkChanged: (v) => setState(() => _colonBlink = v),
        onBurnInProtectionChanged: (v) => setState(() => _burnInProtection = v),
        onSetCountdownTarget: (dt, title) {
          setState(() {
            _countdownTarget = dt;
            _countdownTitle = title;
          });
        },
        onSetTimerDuration: (secs) => _resetTimer(secs),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = kThemes[_themeIndex];
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: theme.background,
      ),
      home: Scaffold(
        backgroundColor: theme.background,
        body: Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.keyT) {
                if (HardwareKeyboard.instance.isShiftPressed) {
                  _prevTheme();
                } else {
                  _nextTheme();
                }
                return KeyEventResult.handled;
              } else if (event.logicalKey == LogicalKeyboardKey.keyF) {
                _nextFont();
                return KeyEventResult.handled;
              } else if (event.logicalKey == LogicalKeyboardKey.space) {
                if (_mode == TimeMode.timer) _toggleTimer();
                if (_mode == TimeMode.stopwatch) _toggleStopwatch();
                return KeyEventResult.handled;
              } else if (event.logicalKey == LogicalKeyboardKey.keyM) {
                final nextIdx = (_mode.index + 1) % TimeMode.values.length;
                _setMode(TimeMode.values[nextIdx]);
                return KeyEventResult.handled;
              } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
                setState(() => _showSeconds = !_showSeconds);
                return KeyEventResult.handled;
              } else if (event.logicalKey == LogicalKeyboardKey.escape) {
                _toggleControls();
                return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _toggleControls,
            onDoubleTap: _nextTheme,
            onLongPress: _openDesignStudio,
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < -200) {
                  _nextTheme();
                } else if (details.primaryVelocity! > 200) {
                  _prevTheme();
                }
              }
            },
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < -200) {
                  final nextIdx = (_mode.index + 1) % TimeMode.values.length;
                  _setMode(TimeMode.values[nextIdx]);
                } else if (details.primaryVelocity! > 200) {
                  final prevIdx = (_mode.index - 1 + TimeMode.values.length) % TimeMode.values.length;
                  _setMode(TimeMode.values[prevIdx]);
                }
              }
            },
            child: Stack(
              children: [
                // 1. PURE FULLSCREEN TIME CONTENT (100% viewport)
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(_burnInX, _burnInY),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isLandscape ? 16 : 8,
                        vertical: isLandscape ? 8 : 16,
                      ),
                      child: Center(
                        child: _buildPureFullscreenContent(theme, isLandscape),
                      ),
                    ),
                  ),
                ),

                // 2. FLOATING MINIMAL HEADER (Reveals on tap)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  top: _controlsVisible ? 16 : -80,
                  left: 16,
                  right: 16,
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: Current Mode & Font Badge
                        Flexible(
                          child: GestureDetector(
                            onTap: _openDesignStudio,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.surface.withValues(alpha: 0.85),
                                border: Border.all(color: theme.border.withValues(alpha: 0.5), width: 1),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _mode.name.toUpperCase(),
                                    style: TextStyle(
                                      color: theme.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 4,
                                    height: 4,
                                    color: theme.accent,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      kFonts[_fontIndex].name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: theme.accent,
                                        fontSize: 11,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Right: Quick Theme Button & Hide HUD
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: _nextTheme,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: theme.surface.withValues(alpha: 0.85),
                                  border: Border.all(color: theme.border.withValues(alpha: 0.5), width: 1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      color: theme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 80),
                                      child: Text(
                                        theme.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: theme.primary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Design Studio Button
                            IconButton(
                              onPressed: _openDesignStudio,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              style: IconButton.styleFrom(
                                backgroundColor: theme.surface.withValues(alpha: 0.85),
                                shape: const RoundedRectangleBorder(),
                                side: BorderSide(color: theme.border.withValues(alpha: 0.5)),
                              ),
                              icon: Icon(Icons.tune, color: theme.primary, size: 16),
                            ),
                            const SizedBox(width: 4),
                            // Hide Button
                            IconButton(
                              onPressed: _hideControls,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              style: IconButton.styleFrom(
                                backgroundColor: theme.surface.withValues(alpha: 0.85),
                                shape: const RoundedRectangleBorder(),
                                side: BorderSide(color: theme.border.withValues(alpha: 0.5)),
                              ),
                              icon: Icon(Icons.fullscreen_exit, color: theme.accent, size: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. FLOATING ACTION CONTROLS HUD (Reveals on tap at bottom)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  bottom: _controlsVisible ? 20 : -100,
                  left: 20,
                  right: 20,
                  child: SafeArea(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: theme.surface.withValues(alpha: 0.92),
                          border: Border.all(color: theme.border, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: theme.background.withValues(alpha: 0.7),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Mode Switchers
                              _buildModeButton(TimeMode.clock, 'CLOCK', Icons.schedule, theme),
                              const SizedBox(width: 4),
                              _buildModeButton(TimeMode.countdown, 'COUNTDOWN', Icons.hourglass_top, theme),
                              const SizedBox(width: 4),
                              _buildModeButton(TimeMode.timer, 'FOCUS', Icons.timer, theme),
                              const SizedBox(width: 4),
                              _buildModeButton(TimeMode.stopwatch, 'STOPWATCH', Icons.speed, theme),

                              // Extra Action Controls for Timer / Stopwatch
                              if (_mode == TimeMode.timer) ...[
                                const SizedBox(width: 10),
                                Container(width: 1, height: 24, color: theme.border),
                                const SizedBox(width: 10),
                                IconButton(
                                  onPressed: _toggleTimer,
                                  style: IconButton.styleFrom(
                                    backgroundColor: theme.primary,
                                    shape: const RoundedRectangleBorder(),
                                  ),
                                  icon: Icon(
                                    _isTimerRunning ? Icons.pause : Icons.play_arrow,
                                    color: theme.background,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                IconButton(
                                  onPressed: () => _resetTimer(),
                                  style: IconButton.styleFrom(
                                    backgroundColor: theme.surface,
                                    side: BorderSide(color: theme.border),
                                    shape: const RoundedRectangleBorder(),
                                  ),
                                  icon: Icon(Icons.refresh, color: theme.primary, size: 18),
                                ),
                              ],

                              if (_mode == TimeMode.stopwatch) ...[
                                const SizedBox(width: 10),
                                Container(width: 1, height: 24, color: theme.border),
                                const SizedBox(width: 10),
                                IconButton(
                                  onPressed: _toggleStopwatch,
                                  style: IconButton.styleFrom(
                                    backgroundColor: theme.primary,
                                    shape: const RoundedRectangleBorder(),
                                  ),
                                  icon: Icon(
                                    _isStopwatchRunning ? Icons.pause : Icons.play_arrow,
                                    color: theme.background,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                IconButton(
                                  onPressed: _recordLap,
                                  style: IconButton.styleFrom(
                                    backgroundColor: theme.surface,
                                    side: BorderSide(color: theme.border),
                                    shape: const RoundedRectangleBorder(),
                                  ),
                                  icon: Icon(Icons.flag, color: theme.primary, size: 18),
                                ),
                                const SizedBox(width: 6),
                                IconButton(
                                  onPressed: _resetStopwatch,
                                  style: IconButton.styleFrom(
                                    backgroundColor: theme.surface,
                                    side: BorderSide(color: theme.border),
                                    shape: const RoundedRectangleBorder(),
                                  ),
                                  icon: Icon(Icons.refresh, color: theme.primary, size: 18),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(TimeMode mode, String label, IconData icon, ClockTheme theme) {
    final isSelected = _mode == mode;
    return GestureDetector(
      onTap: () => _setMode(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        color: isSelected ? theme.primary : Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? theme.background : theme.accent,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? theme.background : theme.primary,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// PURE FULLSCREEN TIME CONTENT BUILDER (Edge-to-Edge)
  Widget _buildPureFullscreenContent(ClockTheme theme, bool isLandscape) {
    switch (_mode) {
      case TimeMode.clock:
        return _buildGiantClock(theme, isLandscape);
      case TimeMode.countdown:
        return _buildGiantCountdown(theme, isLandscape);
      case TimeMode.timer:
        return _buildGiantFocusTimer(theme, isLandscape);
      case TimeMode.stopwatch:
        return _buildGiantStopwatch(theme, isLandscape);
    }
  }

  /// 1. CLOCK VIEW: Pure Giant Digits filling the display
  Widget _buildGiantClock(ClockTheme theme, bool isLandscape) {
    final hourFormat = _is12Hour ? 'hh' : 'HH';
    final hours = DateFormat(hourFormat).format(_now);
    final minutes = DateFormat('mm').format(_now);
    final seconds = DateFormat('ss').format(_now);
    final ampm = _is12Hour ? DateFormat('a').format(_now) : '';
    final dateStr = DateFormat('EEE, MMM d, yyyy').format(_now).toUpperCase();

    final showColon = !_colonBlink || (_now.millisecond < 500);

    final glowEffects = _enableGlow && theme.glow.a > 0
        ? [
            Shadow(color: theme.glow, blurRadius: 25),
            Shadow(color: theme.glow.withValues(alpha: 0.5), blurRadius: 50),
          ]
        : null;

    final primaryStyle = _getFontStyle(
      TextStyle(
        color: theme.primary,
        fontSize: 180,
        fontWeight: FontWeight.w900,
        letterSpacing: isLandscape ? 2 : 0,
        height: 1.0,
        shadows: glowEffects,
      ),
    );

    final accentStyle = _getFontStyle(
      TextStyle(
        color: theme.accent,
        fontSize: isLandscape ? 60 : 48,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        height: 1.0,
        shadows: glowEffects,
      ),
    );

    return FittedBox(
      fit: BoxFit.contain,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Optional Date header
          if (_showDate)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                dateStr,
                style: _getFontStyle(
                  TextStyle(
                    color: theme.accent,
                    fontSize: isLandscape ? 18 : 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),

          // Main Time Row
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(hours, style: primaryStyle),
              Text(
                ':',
                style: primaryStyle.copyWith(
                  color: showColon ? theme.accent : Colors.transparent,
                ),
              ),
              Text(minutes, style: primaryStyle),

              // Seconds & AM/PM
              if (_showSeconds) ...[
                const SizedBox(width: 8),
                Text(
                  ':$seconds',
                  style: accentStyle,
                ),
              ],

              if (_is12Hour && ampm.isNotEmpty) ...[
                const SizedBox(width: 12),
                Text(
                  ampm,
                  style: accentStyle.copyWith(
                    color: theme.secondary,
                    fontSize: isLandscape ? 40 : 32,
                  ),
                ),
              ],
            ],
          ),

          // Progress line: percentage of day passed
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: SizedBox(
              width: isLandscape ? 600 : 320,
              height: 3,
              child: LinearProgressIndicator(
                value: (_now.hour * 3600 + _now.minute * 60 + _now.second) / 86400,
                backgroundColor: theme.border.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(theme.accent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 2. COUNTDOWN VIEW: Giant Horizon Counter
  Widget _buildGiantCountdown(ClockTheme theme, bool isLandscape) {
    final diff = _countdownTarget.difference(_now);
    final isExpired = diff.isNegative;

    final days = isExpired ? 0 : diff.inDays;
    final hours = isExpired ? 0 : diff.inHours % 24;
    final mins = isExpired ? 0 : diff.inMinutes % 60;
    final secs = isExpired ? 0 : diff.inSeconds % 60;

    final glowEffects = _enableGlow && theme.glow.a > 0
        ? [Shadow(color: theme.glow, blurRadius: 25)]
        : null;

    final numStyle = _getFontStyle(
      TextStyle(
        color: theme.primary,
        fontSize: isLandscape ? 120 : 96,
        fontWeight: FontWeight.w900,
        height: 1.0,
        shadows: glowEffects,
      ),
    );

    final labelStyle = _getFontStyle(
      TextStyle(
        color: theme.accent,
        fontSize: isLandscape ? 14 : 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
      ),
    );

    return FittedBox(
      fit: BoxFit.contain,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Target Event Title
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              _countdownTitle.toUpperCase(),
              style: _getFontStyle(
                TextStyle(
                  color: theme.accent,
                  fontSize: isLandscape ? 20 : 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
            ),
          ),

          // 4-Block Split
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCountdownBlock('$days'.padLeft(2, '0'), 'DAYS', numStyle, labelStyle, theme),
              _buildCountdownSeparator(theme),
              _buildCountdownBlock('$hours'.padLeft(2, '0'), 'HOURS', numStyle, labelStyle, theme),
              _buildCountdownSeparator(theme),
              _buildCountdownBlock('$mins'.padLeft(2, '0'), 'MINS', numStyle, labelStyle, theme),
              _buildCountdownSeparator(theme),
              _buildCountdownBlock('$secs'.padLeft(2, '0'), 'SECS', numStyle, labelStyle, theme),
            ],
          ),

          const SizedBox(height: 16),
          Text(
            isExpired ? 'HORIZON REACHED' : 'TARGET: ${DateFormat('yyyy-MM-dd HH:mm').format(_countdownTarget)}',
            style: TextStyle(
              color: theme.secondary,
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownBlock(
    String val,
    String label,
    TextStyle numStyle,
    TextStyle labelStyle,
    ClockTheme theme,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(val, style: numStyle),
        const SizedBox(height: 4),
        Text(label, style: labelStyle),
      ],
    );
  }

  Widget _buildCountdownSeparator(ClockTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        ':',
        style: _getFontStyle(
          TextStyle(
            color: theme.accent,
            fontSize: 70,
            fontWeight: FontWeight.w300,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  /// 3. FOCUS TIMER VIEW: Pure Massive Timer Numbers
  Widget _buildGiantFocusTimer(ClockTheme theme, bool isLandscape) {
    final mins = (_timerRemainingSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_timerRemainingSeconds % 60).toString().padLeft(2, '0');
    final progress = _timerTotalSeconds > 0 ? (_timerRemainingSeconds / _timerTotalSeconds) : 0.0;

    final glowEffects = _enableGlow && theme.glow.a > 0
        ? [Shadow(color: theme.glow, blurRadius: 25)]
        : null;

    final numStyle = _getFontStyle(
      TextStyle(
        color: _isTimerRunning ? theme.primary : theme.accent,
        fontSize: isLandscape ? 170 : 130,
        fontWeight: FontWeight.w900,
        height: 1.0,
        shadows: glowEffects,
      ),
    );

    return FittedBox(
      fit: BoxFit.contain,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isTimerRunning ? 'FOCUS SESSION' : 'PAUSED (TAP TO START)',
            style: _getFontStyle(
              TextStyle(
                color: theme.accent,
                fontSize: 16,
                letterSpacing: 4,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Giant Numerals
          GestureDetector(
            onTap: _toggleTimer,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(mins, style: numStyle),
                Text(
                  ':',
                  style: numStyle.copyWith(
                    color: _isTimerRunning ? theme.accent : theme.secondary,
                  ),
                ),
                Text(secs, style: numStyle),
              ],
            ),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: isLandscape ? 500 : 300,
            height: 4,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: theme.border.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
            ),
          ),
        ],
      ),
    );
  }

  /// 4. STOPWATCH VIEW: Precision Millisecond Display
  Widget _buildGiantStopwatch(ClockTheme theme, bool isLandscape) {
    final totalSeconds = _stopwatchMilliseconds ~/ 1000;
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    final millis = ((_stopwatchMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0');

    final glowEffects = _enableGlow && theme.glow.a > 0
        ? [Shadow(color: theme.glow, blurRadius: 25)]
        : null;

    final numStyle = _getFontStyle(
      TextStyle(
        color: theme.primary,
        fontSize: isLandscape ? 160 : 110,
        fontWeight: FontWeight.w900,
        height: 1.0,
        shadows: glowEffects,
      ),
    );

    final millisStyle = _getFontStyle(
      TextStyle(
        color: theme.accent,
        fontSize: isLandscape ? 70 : 48,
        fontWeight: FontWeight.w700,
        height: 1.0,
        shadows: glowEffects,
      ),
    );

    return FittedBox(
      fit: BoxFit.contain,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isStopwatchRunning ? 'PRECISION STOPWATCH' : 'STOPWATCH (TAP TO RUN)',
            style: _getFontStyle(
              TextStyle(
                color: theme.accent,
                fontSize: 16,
                letterSpacing: 4,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Main Display
          GestureDetector(
            onTap: _toggleStopwatch,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('$mins:$secs', style: numStyle),
                Text('.$millis', style: millisStyle),
              ],
            ),
          ),

          // Laps preview
          if (_laps.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'LAST LAP: ${(_laps.first ~/ 1000 ~/ 60).toString().padLeft(2, '0')}:${((_laps.first ~/ 1000) % 60).toString().padLeft(2, '0')}.${((_laps.first % 1000) ~/ 10).toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: theme.secondary,
                      fontSize: 13,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '(${_laps.length} LAPS)',
                    style: TextStyle(
                      color: theme.accent,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// DESIGN STUDIO MODAL SHEET
class _DesignStudioSheet extends StatefulWidget {
  final int currentThemeIndex;
  final int currentFontIndex;
  final bool is12Hour;
  final bool showSeconds;
  final bool showDate;
  final bool enableGlow;
  final bool colonBlink;
  final bool burnInProtection;

  final ValueChanged<int> onThemeSelected;
  final ValueChanged<int> onFontSelected;
  final ValueChanged<bool> on12HourChanged;
  final ValueChanged<bool> onShowSecondsChanged;
  final ValueChanged<bool> onShowDateChanged;
  final ValueChanged<bool> onEnableGlowChanged;
  final ValueChanged<bool> onColonBlinkChanged;
  final ValueChanged<bool> onBurnInProtectionChanged;
  final void Function(DateTime dt, String title) onSetCountdownTarget;
  final ValueChanged<int> onSetTimerDuration;

  const _DesignStudioSheet({
    required this.currentThemeIndex,
    required this.currentFontIndex,
    required this.is12Hour,
    required this.showSeconds,
    required this.showDate,
    required this.enableGlow,
    required this.colonBlink,
    required this.burnInProtection,
    required this.onThemeSelected,
    required this.onFontSelected,
    required this.on12HourChanged,
    required this.onShowSecondsChanged,
    required this.onShowDateChanged,
    required this.onEnableGlowChanged,
    required this.onColonBlinkChanged,
    required this.onBurnInProtectionChanged,
    required this.onSetCountdownTarget,
    required this.onSetTimerDuration,
  });

  @override
  State<_DesignStudioSheet> createState() => _DesignStudioSheetState();
}

class _DesignStudioSheetState extends State<_DesignStudioSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTheme = kThemes[widget.currentThemeIndex];

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: activeTheme.surface,
        border: Border(top: BorderSide(color: activeTheme.border, width: 2)),
      ),
      child: Column(
        children: [
          // Drag handle & Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DESIGN STUDIO',
                      style: TextStyle(
                        color: activeTheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'CUSTOMIZE PALETTE, TYPOGRAPHY & BEHAVIOR',
                      style: TextStyle(
                        color: activeTheme.accent,
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: activeTheme.primary),
                ),
              ],
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            indicatorColor: activeTheme.primary,
            indicatorWeight: 3,
            labelColor: activeTheme.primary,
            unselectedLabelColor: activeTheme.secondary,
            labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1),
            tabs: const [
              Tab(text: 'PALETTES'),
              Tab(text: 'TYPOGRAPHY'),
              Tab(text: 'DISPLAY'),
              Tab(text: 'PRESETS'),
            ],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. PALETTES GRID
                _buildPalettesTab(activeTheme),

                // 2. TYPOGRAPHY LIST
                _buildTypographyTab(activeTheme),

                // 3. DISPLAY TOGGLES
                _buildDisplayTab(activeTheme),

                // 4. PRESETS
                _buildPresetsTab(activeTheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPalettesTab(ClockTheme activeTheme) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: kThemes.length,
      itemBuilder: (context, index) {
        final t = kThemes[index];
        final isSelected = index == widget.currentThemeIndex;

        return GestureDetector(
          onTap: () {
            widget.onThemeSelected(index);
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: t.background,
              border: Border.all(
                color: isSelected ? t.primary : t.border.withValues(alpha: 0.5),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: double.infinity,
                  color: t.primary,
                ),
                const SizedBox(width: 4),
                Container(
                  width: 6,
                  height: double.infinity,
                  color: t.accent,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: t.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        t.category.toUpperCase(),
                        style: TextStyle(
                          color: t.accent,
                          fontSize: 8,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: t.primary, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypographyTab(ClockTheme activeTheme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: kFonts.length,
      itemBuilder: (context, index) {
        final font = kFonts[index];
        final isSelected = index == widget.currentFontIndex;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: GestureDetector(
            onTap: () {
              widget.onFontSelected(index);
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? activeTheme.border.withValues(alpha: 0.3) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? activeTheme.primary : activeTheme.border.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          font.name,
                          style: TextStyle(
                            color: activeTheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          font.style,
                          style: TextStyle(
                            color: activeTheme.accent,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '10:45:00',
                    style: font.builder(
                      TextStyle(
                        color: activeTheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (isSelected)
                    Icon(Icons.check, color: activeTheme.primary, size: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDisplayTab(ClockTheme activeTheme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSwitchTile('12-HOUR FORMAT', 'Display AM/PM instead of 24h military time', widget.is12Hour, widget.on12HourChanged, activeTheme),
        _buildSwitchTile('SHOW SECONDS', 'High-frequency seconds indicator', widget.showSeconds, widget.onShowSecondsChanged, activeTheme),
        _buildSwitchTile('SHOW DATE', 'Full date & day of week above time', widget.showDate, widget.onShowDateChanged, activeTheme),
        _buildSwitchTile('TEXT GLOW EFFECT', 'Atmospheric neon glow halo around numerals', widget.enableGlow, widget.onEnableGlowChanged, activeTheme),
        _buildSwitchTile('PULSE COLON', 'Subtle 1Hz blinking colon separator', widget.colonBlink, widget.onColonBlinkChanged, activeTheme),
        _buildSwitchTile('OLED BURN-IN GUARD', 'Imperceptible 1.5px micro-shift every 30 mins', widget.burnInProtection, widget.onBurnInProtectionChanged, activeTheme),
      ],
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool val, ValueChanged<bool> onChanged, ClockTheme theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.border.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: theme.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: theme.accent,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: val,
            onChanged: (v) {
              onChanged(v);
              setState(() {});
            },
            activeThumbColor: theme.primary,
            activeTrackColor: theme.primary.withValues(alpha: 0.3),
            inactiveThumbColor: theme.secondary,
            inactiveTrackColor: theme.surface,
          ),
        ],
      ),
    );
  }

  Widget _buildPresetsTab(ClockTheme activeTheme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'TIMER PRESETS',
          style: TextStyle(
            color: activeTheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPresetChip('5m Break', 5 * 60, activeTheme),
            _buildPresetChip('15m Recess', 15 * 60, activeTheme),
            _buildPresetChip('25m Pomodoro', 25 * 60, activeTheme),
            _buildPresetChip('45m Deep Work', 45 * 60, activeTheme),
            _buildPresetChip('60m Sprint', 60 * 60, activeTheme),
            _buildPresetChip('90m Ultradian', 90 * 60, activeTheme),
          ],
        ),

        const SizedBox(height: 24),
        Text(
          'COUNTDOWN HORIZONS',
          style: TextStyle(
            color: activeTheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildCountdownChip('+24 Hours', DateTime.now().add(const Duration(hours: 24)), 'TOMORROW', activeTheme),
            _buildCountdownChip('+7 Days', DateTime.now().add(const Duration(days: 7)), 'NEXT WEEK', activeTheme),
            _buildCountdownChip('+30 Days', DateTime.now().add(const Duration(days: 30)), 'ONE MONTH', activeTheme),
            _buildCountdownChip('New Year', DateTime(DateTime.now().year + 1, 1, 1), 'NEW YEAR', activeTheme),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetChip(String label, int seconds, ClockTheme theme) {
    return ActionChip(
      label: Text(label),
      backgroundColor: theme.surface,
      side: BorderSide(color: theme.border),
      labelStyle: TextStyle(color: theme.primary, fontWeight: FontWeight.bold, fontSize: 11),
      onPressed: () {
        widget.onSetTimerDuration(seconds);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildCountdownChip(String label, DateTime dt, String title, ClockTheme theme) {
    return ActionChip(
      label: Text(label),
      backgroundColor: theme.surface,
      side: BorderSide(color: theme.border),
      labelStyle: TextStyle(color: theme.primary, fontWeight: FontWeight.bold, fontSize: 11),
      onPressed: () {
        widget.onSetCountdownTarget(dt, title);
        Navigator.pop(context);
      },
    );
  }
}
