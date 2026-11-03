import 'package:flutter/material.dart';

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
