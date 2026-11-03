import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../logic/time_logic.dart';
import 'display_style.dart';

/// Giant digital clock filling the display.
class ClockView extends StatelessWidget {
  const ClockView({
    super.key,
    required this.style,
    required this.now,
    required this.is12Hour,
    required this.showSeconds,
    required this.showDate,
    required this.colonBlink,
  });

  final DisplayStyle style;
  final ValueListenable<DateTime> now;
  final bool is12Hour;
  final bool showSeconds;
  final bool showDate;
  final bool colonBlink;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: now,
      builder: (context, t, _) => _build(t),
    );
  }

  Widget _build(DateTime t) {
    final theme = style.theme;
    final isLandscape = style.isLandscape;
    final hours = DateFormat(is12Hour ? 'hh' : 'HH').format(t);
    final minutes = DateFormat('mm').format(t);
    final seconds = DateFormat('ss').format(t);
    final ampm = is12Hour ? DateFormat('a').format(t) : '';
    final dateStr = DateFormat('EEE, MMM d, yyyy').format(t).toUpperCase();
    final showColon = !colonBlink || t.millisecond < 500;
    final glow = style.glow(strong: true);

    final primaryStyle = style.text(
      TextStyle(
        color: theme.primary,
        fontSize: 180,
        fontWeight: FontWeight.w900,
        letterSpacing: isLandscape ? 2 : 0,
        height: 1.0,
        shadows: glow,
      ),
    );
    final accentStyle = style.text(
      TextStyle(
        color: theme.accent,
        fontSize: isLandscape ? 60 : 48,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        height: 1.0,
        shadows: glow,
      ),
    );

    final spoken =
        '${DateFormat(is12Hour ? 'h:mm' : 'HH:mm').format(t)}'
        '${showSeconds ? ' and $seconds seconds' : ''}'
        '${is12Hour ? ' $ampm' : ''}'
        '${showDate ? ', ${DateFormat('EEEE, MMMM d, y').format(t)}' : ''}';

    return Semantics(
      container: true,
      label: 'Clock. $spoken',
      child: ExcludeSemantics(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDate)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    dateStr,
                    style: style.text(
                      TextStyle(
                        color: theme.accent,
                        fontSize: isLandscape ? 18 : 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
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
                  if (showSeconds) ...[
                    const SizedBox(width: 8),
                    Text(':$seconds', style: accentStyle),
                  ],
                  if (is12Hour && ampm.isNotEmpty) ...[
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
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: SizedBox(
                  width: isLandscape ? 600 : 320,
                  height: 3,
                  child: LinearProgressIndicator(
                    value: dayProgress(t),
                    backgroundColor: theme.border.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(theme.accent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
