import 'package:flutter/material.dart';

import '../logic/time_logic.dart';
import 'display_style.dart';

/// Focus countdown timer (Pomodoro etc.).
class TimerView extends StatelessWidget {
  const TimerView({super.key, required this.style, required this.controller});

  final DisplayStyle style;
  final FocusTimerController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([controller.remaining, controller.running]),
      builder: (context, _) => _build(),
    );
  }

  Widget _build() {
    final theme = style.theme;
    final isLandscape = style.isLandscape;
    final running = controller.running.value;
    final secs = controller.remaining.value;

    final numStyle = style.text(
      TextStyle(
        color: running ? theme.primary : theme.accent,
        fontSize: isLandscape ? 170 : 130,
        fontWeight: FontWeight.w900,
        height: 1.0,
        shadows: style.glow(),
      ),
    );

    final minutesPart = two(secs ~/ 60);
    final secondsPart = two(secs % 60);

    return Semantics(
      container: true,
      label:
          'Focus timer. $minutesPart minutes $secondsPart seconds remaining, '
          '${running ? 'running' : 'paused'}.',
      onTap: controller.toggle,
      child: ExcludeSemantics(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                running ? 'FOCUS SESSION' : 'PAUSED (TAP TO START)',
                style: style.text(
                  TextStyle(
                    color: theme.accent,
                    fontSize: 16,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: controller.toggle,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(minutesPart, style: numStyle),
                    Text(
                      ':',
                      style: numStyle.copyWith(
                        color: running ? theme.accent : theme.secondary,
                      ),
                    ),
                    Text(secondsPart, style: numStyle),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: isLandscape ? 500 : 300,
                height: 4,
                child: LinearProgressIndicator(
                  value: controller.progress,
                  backgroundColor: theme.border.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
