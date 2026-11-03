import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../logic/time_logic.dart';
import 'display_style.dart';

/// Days / hours / minutes / seconds until a target moment.
class CountdownView extends StatelessWidget {
  const CountdownView({
    super.key,
    required this.style,
    required this.now,
    required this.target,
    required this.title,
  });

  final DisplayStyle style;
  final ValueListenable<DateTime> now;
  final DateTime target;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: now,
      builder: (context, t, _) => _build(countdownParts(target, t)),
    );
  }

  Widget _build(CountdownParts p) {
    final theme = style.theme;
    final isLandscape = style.isLandscape;
    final glow = style.glow();

    final numStyle = style.text(
      TextStyle(
        color: theme.primary,
        fontSize: isLandscape ? 120 : 96,
        fontWeight: FontWeight.w900,
        height: 1.0,
        shadows: glow,
      ),
    );
    final labelStyle = style.text(
      TextStyle(
        color: theme.accent,
        fontSize: isLandscape ? 14 : 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
      ),
    );

    final spoken = p.expired
        ? '$title. Target reached.'
        : '$title. ${p.days} days, ${p.hours} hours, '
              '${p.minutes} minutes, ${p.seconds} seconds remaining.';

    return Semantics(
      container: true,
      label: 'Countdown. $spoken',
      child: ExcludeSemantics(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  title.toUpperCase(),
                  style: style.text(
                    TextStyle(
                      color: theme.accent,
                      fontSize: isLandscape ? 20 : 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _block(two(p.days), 'DAYS', numStyle, labelStyle),
                  _separator(),
                  _block(two(p.hours), 'HOURS', numStyle, labelStyle),
                  _separator(),
                  _block(two(p.minutes), 'MINS', numStyle, labelStyle),
                  _separator(),
                  _block(two(p.seconds), 'SECS', numStyle, labelStyle),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                p.expired
                    ? 'HORIZON REACHED'
                    : 'TARGET: ${DateFormat('yyyy-MM-dd HH:mm').format(target)}',
                style: TextStyle(
                  color: theme.secondary,
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _block(
    String val,
    String label,
    TextStyle numStyle,
    TextStyle labelStyle,
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

  Widget _separator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(
        ':',
        style: style.text(
          TextStyle(
            color: style.theme.accent,
            fontSize: 70,
            fontWeight: FontWeight.w300,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
