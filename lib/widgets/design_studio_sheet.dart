import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/settings_store.dart';
import '../theme/clock_font.dart';
import '../theme/clock_theme.dart';

/// DESIGN STUDIO MODAL SHEET
class DesignStudioSheet extends StatefulWidget {
  /// Live settings; the sheet rebuilds whenever they change.
  final ValueListenable<AppSettings> settings;

  /// Applies a change to the app-wide settings.
  final void Function(AppSettings Function(AppSettings current) change)
  onUpdate;
  final void Function(DateTime dt, String title) onSetCountdownTarget;
  final ValueChanged<int> onSetTimerDuration;

  const DesignStudioSheet({
    super.key,
    required this.settings,
    required this.onUpdate,
    required this.onSetCountdownTarget,
    required this.onSetTimerDuration,
  });

  @override
  State<DesignStudioSheet> createState() => _DesignStudioSheetState();
}

class _DesignStudioSheetState extends State<DesignStudioSheet>
    with SingleTickerProviderStateMixin {
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

  AppSettings get _s => widget.settings.value;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppSettings>(
      valueListenable: widget.settings,
      builder: (context, _, _) => _buildSheet(context),
    );
  }

  Widget _buildSheet(BuildContext context) {
    final activeTheme = kThemes[_s.themeIndex];

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
                  tooltip: 'Close',
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
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 1,
            ),
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
        final isSelected = index == _s.themeIndex;

        return GestureDetector(
          onTap: () {
            widget.onUpdate((s) => s.copyWith(themeIndex: index));
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
                Container(width: 14, height: double.infinity, color: t.primary),
                const SizedBox(width: 4),
                Container(width: 6, height: double.infinity, color: t.accent),
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
        final isSelected = index == _s.fontIndex;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: GestureDetector(
            onTap: () {
              widget.onUpdate((s) => s.copyWith(fontIndex: index));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeTheme.border.withValues(alpha: 0.3)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? activeTheme.primary
                      : activeTheme.border.withValues(alpha: 0.3),
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
        _buildSwitchTile(
          '12-HOUR FORMAT',
          'Display AM/PM instead of 24h military time',
          _s.is12Hour,
          (v) => widget.onUpdate((s) => s.copyWith(is12Hour: v)),
          activeTheme,
        ),
        _buildSwitchTile(
          'SHOW SECONDS',
          'High-frequency seconds indicator',
          _s.showSeconds,
          (v) => widget.onUpdate((s) => s.copyWith(showSeconds: v)),
          activeTheme,
        ),
        _buildSwitchTile(
          'SHOW DATE',
          'Full date & day of week above time',
          _s.showDate,
          (v) => widget.onUpdate((s) => s.copyWith(showDate: v)),
          activeTheme,
        ),
        _buildSwitchTile(
          'TEXT GLOW EFFECT',
          'Atmospheric neon glow halo around numerals',
          _s.enableGlow,
          (v) => widget.onUpdate((s) => s.copyWith(enableGlow: v)),
          activeTheme,
        ),
        _buildSwitchTile(
          'PULSE COLON',
          'Subtle 1Hz blinking colon separator',
          _s.colonBlink,
          (v) => widget.onUpdate((s) => s.copyWith(colonBlink: v)),
          activeTheme,
        ),
        _buildSwitchTile(
          'OLED BURN-IN GUARD',
          'Imperceptible 1.5px micro-shift every 3 mins',
          _s.burnInProtection,
          (v) => widget.onUpdate((s) => s.copyWith(burnInProtection: v)),
          activeTheme,
        ),
        _buildSwitchTile(
          'KEEP SCREEN ON',
          'Prevent the display from sleeping while the clock is open',
          _s.keepAwake,
          (v) => widget.onUpdate((s) => s.copyWith(keepAwake: v)),
          activeTheme,
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool val,
    ValueChanged<bool> onChanged,
    ClockTheme theme,
  ) {
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
                  style: TextStyle(color: theme.accent, fontSize: 10),
                ),
              ],
            ),
          ),
          Switch(
            value: val,
            onChanged: onChanged,
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
            _buildCountdownChip(
              '+24 Hours',
              DateTime.now().add(const Duration(hours: 24)),
              'TOMORROW',
              activeTheme,
            ),
            _buildCountdownChip(
              '+7 Days',
              DateTime.now().add(const Duration(days: 7)),
              'NEXT WEEK',
              activeTheme,
            ),
            _buildCountdownChip(
              '+30 Days',
              DateTime.now().add(const Duration(days: 30)),
              'ONE MONTH',
              activeTheme,
            ),
            _buildCountdownChip(
              'New Year',
              DateTime(DateTime.now().year + 1, 1, 1),
              'NEW YEAR',
              activeTheme,
            ),
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
      labelStyle: TextStyle(
        color: theme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 11,
      ),
      onPressed: () {
        widget.onSetTimerDuration(seconds);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildCountdownChip(
    String label,
    DateTime dt,
    String title,
    ClockTheme theme,
  ) {
    return ActionChip(
      label: Text(label),
      backgroundColor: theme.surface,
      side: BorderSide(color: theme.border),
      labelStyle: TextStyle(
        color: theme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 11,
      ),
      onPressed: () {
        widget.onSetCountdownTarget(dt, title);
        Navigator.pop(context);
      },
    );
  }
}
