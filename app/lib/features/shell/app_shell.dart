import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../settings/settings_screen.dart';
import '../stats/stats_screen.dart';
import '../today/today_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _screens = [TodayScreen(), StatsScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsScope.of(context);
    final text = AppText(colors);

    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.card,
          border: Border(top: BorderSide(color: colors.lineSoft)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 58,
            child: Row(
              children: [
                _TabButton(icon: Icons.today_outlined, activeIcon: Icons.today, label: 'Today', selected: _index == 0, onTap: () => setState(() => _index = 0), colors: colors, text: text),
                _TabButton(icon: Icons.insights_outlined, activeIcon: Icons.insights, label: 'Stats', selected: _index == 1, onTap: () => setState(() => _index = 1), colors: colors, text: text),
                _TabButton(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Settings', selected: _index == 2, onTap: () => setState(() => _index = 2), colors: colors, text: text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colors,
    required this.text,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final AppColors colors;
  final AppText text;

  @override
  Widget build(BuildContext context) {
    final color = selected ? colors.accent : colors.muted;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? activeIcon : icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(label, style: text.kicker.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
