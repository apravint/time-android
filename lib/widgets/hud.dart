import 'package:flutter/material.dart';

import '../logic/time_logic.dart';
import '../models/time_mode.dart';
import '../theme/clock_theme.dart';

BoxDecoration _chipDecoration(ClockTheme theme) => BoxDecoration(
  color: theme.surface.withValues(alpha: 0.85),
  border: Border.all(color: theme.border.withValues(alpha: 0.5), width: 1),
);

ButtonStyle _squareButton(ClockTheme theme, {bool filled = false}) =>
    IconButton.styleFrom(
      backgroundColor: filled
          ? theme.primary
          : theme.surface.withValues(alpha: 0.85),
      shape: const RoundedRectangleBorder(),
      side: filled
          ? null
          : BorderSide(color: theme.border.withValues(alpha: 0.5)),
    );

/// Header that slides in when the controls are revealed.
class HudTopBar extends StatelessWidget {
  const HudTopBar({
    super.key,
    required this.visible,
    required this.theme,
    required this.mode,
    required this.fontName,
    required this.onOpenStudio,
    required this.onNextTheme,
    required this.onHide,
  });

  final bool visible;
  final ClockTheme theme;
  final TimeMode mode;
  final String fontName;
  final VoidCallback onOpenStudio;
  final VoidCallback onNextTheme;
  final VoidCallback onHide;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      top: visible ? 16 : -80,
      left: 16,
      right: 16,
      child: ExcludeSemantics(
        excluding: !visible,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Semantics(
                  button: true,
                  label:
                      'Open design studio. Mode ${mode.name}, font $fontName',
                  child: GestureDetector(
                    onTap: onOpenStudio,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: _chipDecoration(theme),
                      child: ExcludeSemantics(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              mode.name.toUpperCase(),
                              style: TextStyle(
                                color: theme.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(width: 4, height: 4, color: theme.accent),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                fontName,
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
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    button: true,
                    label: 'Next theme. Current theme ${theme.name}',
                    child: GestureDetector(
                      onTap: onNextTheme,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: _chipDecoration(theme),
                        child: ExcludeSemantics(
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
                    ),
                  ),
                  const SizedBox(width: 6),
                  _iconButton(
                    tooltip: 'Design studio',
                    icon: Icons.tune,
                    color: theme.primary,
                    onPressed: onOpenStudio,
                  ),
                  const SizedBox(width: 4),
                  _iconButton(
                    tooltip: 'Hide controls',
                    icon: Icons.fullscreen_exit,
                    color: theme.accent,
                    onPressed: onHide,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton({
    required String tooltip,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      style: _squareButton(theme),
      icon: Icon(icon, color: color, size: 16),
    );
  }
}

/// Mode switcher and transport buttons at the bottom of the screen.
class HudBottomBar extends StatelessWidget {
  const HudBottomBar({
    super.key,
    required this.visible,
    required this.theme,
    required this.mode,
    required this.timer,
    required this.stopwatch,
    required this.onSetMode,
  });

  final bool visible;
  final ClockTheme theme;
  final TimeMode mode;
  final FocusTimerController timer;
  final StopwatchController stopwatch;
  final ValueChanged<TimeMode> onSetMode;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      bottom: visible ? 20 : -100,
      left: 20,
      right: 20,
      child: ExcludeSemantics(
        excluding: !visible,
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
                    _modeButton(TimeMode.clock, 'CLOCK', Icons.schedule),
                    const SizedBox(width: 4),
                    _modeButton(
                      TimeMode.countdown,
                      'COUNTDOWN',
                      Icons.hourglass_top,
                    ),
                    const SizedBox(width: 4),
                    _modeButton(TimeMode.timer, 'FOCUS', Icons.timer),
                    const SizedBox(width: 4),
                    _modeButton(TimeMode.stopwatch, 'STOPWATCH', Icons.speed),
                    if (mode == TimeMode.timer) ..._timerControls(),
                    if (mode == TimeMode.stopwatch) ..._stopwatchControls(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _divider() => [
    const SizedBox(width: 10),
    Container(width: 1, height: 24, color: theme.border),
    const SizedBox(width: 10),
  ];

  List<Widget> _timerControls() => [
    ..._divider(),
    ValueListenableBuilder<bool>(
      valueListenable: timer.running,
      builder: (context, running, _) => IconButton(
        tooltip: running ? 'Pause timer' : 'Start timer',
        onPressed: timer.toggle,
        style: _squareButton(theme, filled: true),
        icon: Icon(
          running ? Icons.pause : Icons.play_arrow,
          color: theme.background,
          size: 18,
        ),
      ),
    ),
    const SizedBox(width: 6),
    IconButton(
      tooltip: 'Reset timer',
      onPressed: () => timer.reset(),
      style: _squareButton(theme),
      icon: Icon(Icons.refresh, color: theme.primary, size: 18),
    ),
  ];

  List<Widget> _stopwatchControls() => [
    ..._divider(),
    ValueListenableBuilder<bool>(
      valueListenable: stopwatch.running,
      builder: (context, running, _) => IconButton(
        tooltip: running ? 'Pause stopwatch' : 'Start stopwatch',
        onPressed: stopwatch.toggle,
        style: _squareButton(theme, filled: true),
        icon: Icon(
          running ? Icons.pause : Icons.play_arrow,
          color: theme.background,
          size: 18,
        ),
      ),
    ),
    const SizedBox(width: 6),
    IconButton(
      tooltip: 'Record lap',
      onPressed: stopwatch.lap,
      style: _squareButton(theme),
      icon: Icon(Icons.flag, color: theme.primary, size: 18),
    ),
    const SizedBox(width: 6),
    IconButton(
      tooltip: 'Reset stopwatch',
      onPressed: stopwatch.reset,
      style: _squareButton(theme),
      icon: Icon(Icons.refresh, color: theme.primary, size: 18),
    ),
  ];

  Widget _modeButton(TimeMode m, String label, IconData icon) {
    final selected = mode == m;
    return Semantics(
      button: true,
      selected: selected,
      label: '$label mode',
      child: GestureDetector(
        onTap: () => onSetMode(m),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          color: selected ? theme.primary : Colors.transparent,
          child: ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: selected ? theme.background : theme.accent,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? theme.background : theme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
