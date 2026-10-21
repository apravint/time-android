import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Enable edge-to-edge full-screen immersion
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const ChronoCraftApp());
}

class ChronoCraftApp extends StatefulWidget {
  const ChronoCraftApp({super.key});

  @override
  State<ChronoCraftApp> createState() => _ChronoCraftAppState();
}

class _ChronoCraftAppState extends State<ChronoCraftApp> {
  // Theme selection: 0 = Cyan Neon, 1 = Amber Studio, 2 = Cyber Green, 3 = Monochrome White
  int _activeThemeIndex = 0;

  static const List<Map<String, dynamic>> _themes = [
    {
      'name': 'Cyan Neon',
      'clockAccent': Color(0xFF00E5FF),
      'countdownAccent': Color(0xFFFFB000),
      'timerAccent': Color(0xFF00FF66),
    },
    {
      'name': 'Amber Studio',
      'clockAccent': Color(0xFFFFB000),
      'countdownAccent': Color(0xFFFF8800),
      'timerAccent': Color(0xFFFFCC00),
    },
    {
      'name': 'Cyber Green',
      'clockAccent': Color(0xFF00FF66),
      'countdownAccent': Color(0xFF00E5FF),
      'timerAccent': Color(0xFF00FF66),
    },
    {
      'name': 'Monochrome',
      'clockAccent': Color(0xFFFFFFFF),
      'countdownAccent': Color(0xFFCCCCCC),
      'timerAccent': Color(0xFFFFFFFF),
    },
  ];

  void _cycleTheme() {
    setState(() {
      _activeThemeIndex = (_activeThemeIndex + 1) % _themes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _themes[_activeThemeIndex];
    return MaterialApp(
      title: 'Time',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        fontFamily: 'monospace',
      ),
      home: TimeMasterScreen(
        clockAccent: theme['clockAccent'] as Color,
        countdownAccent: theme['countdownAccent'] as Color,
        timerAccent: theme['timerAccent'] as Color,
        onCycleTheme: _cycleTheme,
        themeName: theme['name'] as String,
      ),
    );
  }
}

class TimeMasterScreen extends StatefulWidget {
  final Color clockAccent;
  final Color countdownAccent;
  final Color timerAccent;
  final VoidCallback onCycleTheme;
  final String themeName;

  const TimeMasterScreen({
    super.key,
    required this.clockAccent,
    required this.countdownAccent,
    required this.timerAccent,
    required this.onCycleTheme,
    required this.themeName,
  });

  @override
  State<TimeMasterScreen> createState() => _TimeMasterScreenState();
}

class _TimeMasterScreenState extends State<TimeMasterScreen> {
  // Navigation: 0 = Clock, 1 = Countdown, 2 = Timer / Stopwatch
  int _activeTab = 0;
  bool _isImmersionMode = false;
  bool _is24Hour = false;

  late Timer _tickerTimer;
  DateTime _currentTime = DateTime.now();

  // Countdown State
  String _eventTitle = 'PRODUCT LAUNCH';
  DateTime _targetEventDate = DateTime.now().add(const Duration(days: 25, hours: 14));
  DateTime _eventStartDate = DateTime.now().subtract(const Duration(days: 5));

  // Focus Timer State
  int _timerTotalSeconds = 25 * 60;
  int _timerRemainingSeconds = 25 * 60;
  Timer? _countdownTimer;
  bool _isTimerRunning = false;
  String _timerRoutineLabel = 'POMODORO FOCUS';

  // Stopwatch State
  bool _isStopwatchMode = false;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _stopwatchTimer;
  final List<String> _laps = [];

  @override
  void initState() {
    super.initState();
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _tickerTimer.cancel();
    _countdownTimer?.cancel();
    _stopwatchTimer?.cancel();
    super.dispose();
  }

  void _toggleImmersion() {
    setState(() {
      _isImmersionMode = !_isImmersionMode;
    });
    if (_isImmersionMode) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  // Timer Controls
  void _toggleTimer() {
    if (_isTimerRunning) {
      _countdownTimer?.cancel();
      setState(() {
        _isTimerRunning = false;
      });
      HapticFeedback.lightImpact();
    } else {
      setState(() {
        _isTimerRunning = true;
      });
      HapticFeedback.mediumImpact();
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timerRemainingSeconds > 0) {
          setState(() {
            _timerRemainingSeconds--;
          });
        } else {
          _countdownTimer?.cancel();
          setState(() {
            _isTimerRunning = false;
          });
          HapticFeedback.heavyImpact();
          SystemSound.play(SystemSoundType.alert);
        }
      });
    }
  }

  void _resetTimer() {
    _countdownTimer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _timerRemainingSeconds = _timerTotalSeconds;
    });
    HapticFeedback.selectionClick();
  }

  void _setTimerDuration(int minutes, String label) {
    _resetTimer();
    setState(() {
      _timerTotalSeconds = minutes * 60;
      _timerRemainingSeconds = _timerTotalSeconds;
      _timerRoutineLabel = label;
    });
  }

  // Stopwatch Controls
  void _toggleStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _stopwatchTimer?.cancel();
      HapticFeedback.lightImpact();
    } else {
      _stopwatch.start();
      HapticFeedback.mediumImpact();
      _stopwatchTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
        if (mounted) setState(() {});
      });
    }
    setState(() {});
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    _stopwatchTimer?.cancel();
    setState(() {
      _laps.clear();
    });
    HapticFeedback.selectionClick();
  }

  void _recordLap() {
    if (_stopwatch.isRunning) {
      final elapsed = _formatStopwatch(_stopwatch.elapsedMilliseconds);
      setState(() {
        _laps.insert(0, 'LAP ${_laps.length + 1} • $elapsed');
      });
      HapticFeedback.lightImpact();
    }
  }

  String _formatStopwatch(int ms) {
    final minutes = (ms ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((ms % 60000) ~/ 1000).toString().padLeft(2, '0');
    final hundredths = ((ms % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds.$hundredths';
  }

  // Date selection
  Future<void> _pickCustomDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _targetEventDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            dialogTheme: const DialogThemeData(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _targetEventDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          9,
          0,
        );
        _eventStartDate = DateTime.now();
      });
    }
  }

  void _editEventTitle() {
    final controller = TextEditingController(text: _eventTitle);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F0F0F),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('EDIT COUNTDOWN EVENT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: widget.countdownAccent)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide(color: widget.countdownAccent, width: 2)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.countdownAccent,
              foregroundColor: Colors.black,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _eventTitle = controller.text.trim().toUpperCase();
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('SAVE', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isLandscape = orientation == Orientation.landscape;
          return SafeArea(
            child: Column(
              children: [
                // Top Status Header (Hides in immersion mode)
                if (!_isImmersionMode)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFF222222))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TIME • BRUTALIST',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.white),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: widget.onCycleTheme,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF111111),
                                  border: Border.all(color: const Color(0xFF333333)),
                                ),
                                child: Text(
                                  'THEME: ${widget.themeName.toUpperCase()}',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: widget.clockAccent),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _toggleImmersion,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF111111),
                                  border: Border.all(color: const Color(0xFF333333)),
                                ),
                                child: const Text(
                                  'IMMERSION',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // Main Interactive Viewport
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _toggleImmersion,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: _buildActiveTabContent(isLandscape),
                      ),
                    ),
                  ),
                ),

                // Bottom Navigation Bar (Hides in immersion mode)
                if (!_isImmersionMode)
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF080808),
                      border: Border(top: BorderSide(color: Color(0xFF222222))),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        _buildNavButton(0, 'CLOCK', widget.clockAccent),
                        _buildNavButton(1, 'COUNTDOWN', widget.countdownAccent),
                        _buildNavButton(2, 'TIMER', widget.timerAccent),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavButton(int index, String label, Color accent) {
    final isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeTab = index;
          });
          HapticFeedback.selectionClick();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            border: Border.all(color: isActive ? Colors.white : Colors.transparent),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent(bool isLandscape) {
    switch (_activeTab) {
      case 0:
        return _buildClockView(isLandscape);
      case 1:
        return _buildCountdownView(isLandscape);
      case 2:
        return _buildTimerView(isLandscape);
      default:
        return _buildClockView(isLandscape);
    }
  }

  // ---------------------------------------------------------------------------
  // 1. CLOCK VIEW
  // ---------------------------------------------------------------------------
  Widget _buildClockView(bool isLandscape) {
    final now = _currentTime;
    final hourFormat = _is24Hour ? 'HH' : 'hh';
    final hourMinutes = DateFormat('$hourFormat:mm').format(now);
    final seconds = DateFormat('ss').format(now);
    final meridiem = _is24Hour ? '' : DateFormat('a').format(now);
    final dateStr = DateFormat('EEEE • MMM d, yyyy').format(now).toUpperCase();

    // Calculate day percent elapsed
    final midnight = DateTime(now.year, now.month, now.day);
    final dayElapsedSeconds = now.difference(midnight).inSeconds;
    final dayPct = (dayElapsedSeconds / 86400 * 100).toStringAsFixed(1);

    if (isLandscape) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Left: Giant Clock
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF050505),
                border: Border.all(color: widget.clockAccent, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hourMinutes,
                    style: const TextStyle(fontSize: 104, fontWeight: FontWeight.w800, letterSpacing: -3, color: Colors.white, height: 1.0),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111111),
                          border: Border.all(color: const Color(0xFF333333)),
                        ),
                        child: Text(
                          ': $seconds $meridiem',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: widget.clockAccent, letterSpacing: 2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Right: Telemetry
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatCard('DATE', dateStr, null),
                const SizedBox(height: 10),
                _buildStatCard('DAY ELAPSED', '$dayPct%', double.tryParse(dayPct) ?? 0),
              ],
            ),
          ),
        ],
      );
    }

    // Portrait Mode
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Date chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            border: Border.all(color: const Color(0xFF333333)),
          ),
          child: Text(
            dateStr,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 2, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 20),

        // Hero Clock Frame
        GestureDetector(
          onTap: () {
            setState(() {
              _is24Hour = !_is24Hour;
            });
            HapticFeedback.selectionClick();
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF050505),
              border: Border.all(color: widget.clockAccent, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  hourMinutes,
                  style: const TextStyle(
                    fontSize: 88,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -2,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    border: Border.all(color: const Color(0xFF333333)),
                  ),
                  child: Text(
                    ': $seconds $meridiem',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.clockAccent,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'TAP TO TOGGLE 12H / 24H',
                  style: TextStyle(fontSize: 10, color: Color(0xFF555555), letterSpacing: 1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Day Progress Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            border: Border.all(color: const Color(0xFF222222)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('DAY PROGRESS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 1)),
                  Text('$dayPct%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 6,
                width: double.infinity,
                color: const Color(0xFF222222),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: ((double.tryParse(dayPct) ?? 0) / 100).clamp(0.0, 1.0),
                  child: Container(color: widget.clockAccent),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, double? progressPct) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        border: Border.all(color: const Color(0xFF222222)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 1)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          if (progressPct != null) ...[
            const SizedBox(height: 8),
            Container(
              height: 4,
              width: double.infinity,
              color: const Color(0xFF222222),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: (progressPct / 100).clamp(0.0, 1.0),
                child: Container(color: widget.clockAccent),
              ),
            ),
          ]
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. COUNTDOWN VIEW
  // ---------------------------------------------------------------------------
  Widget _buildCountdownView(bool isLandscape) {
    final diff = _targetEventDate.difference(_currentTime);
    final isExpired = diff.isNegative;

    final days = isExpired ? 0 : diff.inDays;
    final hours = isExpired ? 0 : diff.inHours % 24;
    final minutes = isExpired ? 0 : diff.inMinutes % 60;
    final seconds = isExpired ? 0 : diff.inSeconds % 60;

    // Total completion %
    final totalDuration = _targetEventDate.difference(_eventStartDate).inSeconds;
    final elapsedDuration = _currentTime.difference(_eventStartDate).inSeconds;
    final completionPct = totalDuration > 0
        ? ((elapsedDuration / totalDuration) * 100).clamp(0.0, 100.0).toStringAsFixed(0)
        : '100';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event title header
        GestureDetector(
          onTap: _editEventTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('COUNTDOWN TARGET', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.grey)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _eventTitle,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: Colors.white),
                    ),
                  ),
                  const Text(' ✎', style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('MMM dd, yyyy • hh:mm a').format(_targetEventDate).toUpperCase(),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: widget.countdownAccent),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 4-Box Split Grid
        Row(
          children: [
            Expanded(child: _buildCountdownBox(days.toString().padLeft(2, '0'), 'DAYS', true)),
            const SizedBox(width: 10),
            Expanded(child: _buildCountdownBox(hours.toString().padLeft(2, '0'), 'HOURS', false)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildCountdownBox(minutes.toString().padLeft(2, '0'), 'MINUTES', false)),
            const SizedBox(width: 10),
            Expanded(child: _buildCountdownBox(seconds.toString().padLeft(2, '0'), 'SECONDS', true)),
          ],
        ),
        const SizedBox(height: 20),

        // Progress Completion Bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            border: Border.all(color: const Color(0xFF222222)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('HORIZON COMPLETION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 1)),
                  Text('$completionPct% COMPLETE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: widget.countdownAccent)),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 6,
                width: double.infinity,
                color: const Color(0xFF222222),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: ((double.tryParse(completionPct) ?? 0) / 100).clamp(0.0, 1.0),
                  child: Container(color: widget.countdownAccent),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Quick Presets Row
        Row(
          children: [
            Expanded(
              child: _buildActionButton('+7 DAYS', () {
                setState(() {
                  _targetEventDate = DateTime.now().add(const Duration(days: 7));
                  _eventStartDate = DateTime.now();
                });
                HapticFeedback.lightImpact();
              }, false),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton('+30 DAYS', () {
                setState(() {
                  _targetEventDate = DateTime.now().add(const Duration(days: 30));
                  _eventStartDate = DateTime.now();
                });
                HapticFeedback.lightImpact();
              }, false),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton('SET DATE', _pickCustomDate, true),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCountdownBox(String value, String label, bool isHighlight) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        border: Border.all(
          color: isHighlight ? widget.countdownAccent : const Color(0xFF333333),
          width: isHighlight ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white, height: 1.0),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2, color: widget.countdownAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap, bool isPrimary) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isPrimary ? widget.countdownAccent : const Color(0xFF111111),
          border: Border.all(color: isPrimary ? widget.countdownAccent : const Color(0xFF333333)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: isPrimary ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. FOCUS TIMER & STOPWATCH VIEW
  // ---------------------------------------------------------------------------
  Widget _buildTimerView(bool isLandscape) {
    if (_isStopwatchMode) {
      return _buildStopwatchView();
    }

    final minutes = (_timerRemainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timerRemainingSeconds % 60).toString().padLeft(2, '0');
    final pctRemaining = _timerTotalSeconds > 0
        ? ((_timerRemainingSeconds / _timerTotalSeconds) * 100).round()
        : 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Sub-Mode Toggle: Timer vs Stopwatch
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isStopwatchMode = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    border: Border.all(color: widget.timerAccent),
                  ),
                  child: Text(
                    'FOCUS TIMER',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: widget.timerAccent, letterSpacing: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isStopwatchMode = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A),
                    border: Border.all(color: const Color(0xFF222222)),
                  ),
                  child: const Text(
                    'STOPWATCH',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Presets Row
        Row(
          children: [
            _buildPresetChip(25, 'POMODORO'),
            const SizedBox(width: 6),
            _buildPresetChip(5, 'SHORT BREAK'),
            const SizedBox(width: 6),
            _buildPresetChip(45, 'DEEP WORK'),
            const SizedBox(width: 6),
            _buildPresetChip(20, 'POWER NAP'),
          ],
        ),
        const SizedBox(height: 20),

        // Timer Frame Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF050505),
            border: Border.all(color: widget.timerAccent, width: 2),
          ),
          child: Column(
            children: [
              Text(
                _timerRoutineLabel,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                '$minutes:$seconds',
                style: const TextStyle(fontSize: 84, fontWeight: FontWeight.w800, letterSpacing: -2, color: Colors.white, height: 1.0),
              ),
              const SizedBox(height: 16),
              Text(
                '$pctRemaining% REMAINING • ${_timerTotalSeconds ~/ 60} MIN TOTAL',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: widget.timerAccent),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Action Buttons Row (START / PAUSE / RESET)
        Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: _toggleTimer,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: _isTimerRunning ? const Color(0xFFFFB000) : widget.timerAccent,
                  ),
                  child: Text(
                    _isTimerRunning ? '❚❚  PAUSE' : '▶  START',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 2, color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: _resetTimer,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    border: Border.all(color: const Color(0xFF333333)),
                  ),
                  child: const Text(
                    'RESET',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetChip(int minutes, String label) {
    final isSelected = _timerTotalSeconds == minutes * 60;
    return Expanded(
      child: GestureDetector(
        onTap: () => _setTimerDuration(minutes, label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF141414) : const Color(0xFF0A0A0A),
            border: Border.all(color: isSelected ? widget.timerAccent : const Color(0xFF222222)),
          ),
          child: Text(
            '${minutes}M',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? widget.timerAccent : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3B. STOPWATCH SUB-VIEW
  // ---------------------------------------------------------------------------
  Widget _buildStopwatchView() {
    final formattedTime = _formatStopwatch(_stopwatch.elapsedMilliseconds);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Sub-Mode Toggle
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isStopwatchMode = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A),
                    border: Border.all(color: const Color(0xFF222222)),
                  ),
                  child: const Text(
                    'FOCUS TIMER',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isStopwatchMode = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    border: Border.all(color: widget.timerAccent),
                  ),
                  child: Text(
                    'STOPWATCH',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: widget.timerAccent, letterSpacing: 1),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Stopwatch Frame
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF050505),
            border: Border.all(color: widget.timerAccent, width: 2),
          ),
          child: Column(
            children: [
              const Text(
                'PRECISION CHRONOGRAPH',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                formattedTime,
                style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w800, letterSpacing: -1, color: Colors.white, height: 1.0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Stopwatch Action Buttons
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _toggleStopwatch,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: _stopwatch.isRunning ? const Color(0xFFFFB000) : widget.timerAccent,
                  ),
                  child: Text(
                    _stopwatch.isRunning ? '❚❚  STOP' : '▶  START',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1, color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: _recordLap,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    border: Border.all(color: const Color(0xFF333333)),
                  ),
                  child: const Text(
                    'LAP',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: _resetStopwatch,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    border: Border.all(color: const Color(0xFF333333)),
                  ),
                  child: const Text(
                    'RESET',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Laps List
        if (_laps.isNotEmpty) ...[
          const SizedBox(height: 20),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              border: Border.all(color: const Color(0xFF222222)),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _laps.length,
              separatorBuilder: (context, index) => const Divider(color: Color(0xFF1A1A1A)),
              itemBuilder: (context, index) {
                return Text(
                  _laps[index],
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
