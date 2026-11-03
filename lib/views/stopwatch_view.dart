import 'package:flutter/material.dart';

import '../logic/time_logic.dart';
import 'display_style.dart';

/// Millisecond-precision stopwatch with a last-lap summary.
class StopwatchView extends StatelessWidget {
  const StopwatchView({
    super.key,
    required this.style,
    required this.controller,
  });

  final DisplayStyle style;
  final StopwatchController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        controller.elapsedMs,
        controller.running,
        controller.laps,
      ]),
      builder: (context, _) => _build(),
    );
  }

  Widget _build() {
    final theme = style.theme;
    final isLandscape = style.isLandscape;
    final running = controller.running.value;
    final laps = controller.laps.value;
    final parts = splitStopwatch(controller.elapsedMs.value);

    final numStyle = style.text(
      TextStyle(
        color: theme.primary,
        fontSize: isLandscape ? 160 : 110,
        fontWeight: FontWeight.w900,
        height: 1.0,
        shadows: style.glow(),
      ),
    );
    final millisStyle = style.text(
      TextStyle(
        color: theme.accent,
        fontSize: isLandscape ? 70 : 48,
        fontWeight: FontWeight.w700,
        height: 1.0,
        shadows: style.glow(),
      ),
    );

    return Semantics(
      container: true,
      label:
          'Stopwatch. ${parts.full}, ${running ? 'running' : 'stopped'}. '
          '${laps.length} laps recorded.',
      onTap: controller.toggle,
      child: ExcludeSemantics(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                running ? 'PRECISION STOPWATCH' : 'STOPWATCH (TAP TO RUN)',
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
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(parts.minutesSeconds, style: numStyle),
                    Text('.${parts.hundredths}', style: millisStyle),
                  ],
                ),
              ),
              if (laps.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'LAST LAP: ${splitStopwatch(laps.first).full}',
                        style: TextStyle(
                          color: theme.secondary,
                          fontSize: 13,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '(${laps.length} LAPS)',
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
        ),
      ),
    );
  }
}
