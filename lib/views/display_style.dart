import 'package:flutter/material.dart';

import '../theme/clock_font.dart';
import '../theme/clock_theme.dart';

/// Theme, typography and layout context shared by every mode view.
class DisplayStyle {
  final ClockTheme theme;
  final ClockFont font;
  final bool isLandscape;
  final bool enableGlow;

  const DisplayStyle({
    required this.theme,
    required this.font,
    required this.isLandscape,
    required this.enableGlow,
  });

  /// Applies the selected font with tabular figures so digits don't jitter.
  TextStyle text(TextStyle base) {
    try {
      return font
          .builder(base)
          .copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
    } catch (_) {
      return base.copyWith(fontFamily: 'monospace');
    }
  }

  /// Neon glow halo, or null when disabled / the theme has none.
  List<Shadow>? glow({bool strong = false}) {
    if (!enableGlow || theme.glow.a <= 0) return null;
    return [
      Shadow(color: theme.glow, blurRadius: 25),
      if (strong)
        Shadow(color: theme.glow.withValues(alpha: 0.5), blurRadius: 50),
    ];
  }
}
