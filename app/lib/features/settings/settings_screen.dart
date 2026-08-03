import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../data/backup_service.dart';
import '../../providers/database_provider.dart';
import '../../providers/habit_providers.dart';
import '../../providers/settings_providers.dart';
import '../onboarding/onboarding_flow.dart';
import '../reminders/reminder_scheduler.dart';
import 'archived_habits_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColorsScope.of(context);
    final text = AppText(colors);
    final db = ref.watch(databaseProvider);

    final themeMode = ref.watch(themeModeProvider).valueOrNull ?? ThemeMode.system;
    final adaptiveOn = ref.watch(adaptiveEnabledProvider).valueOrNull ?? true;
    final notificationsOn = ref.watch(notificationsEnabledProvider).valueOrNull ?? true;
    final streakNudgeOn = ref.watch(streakNudgeEnabledProvider).valueOrNull ?? true;
    final quietHours = ref.watch(quietHoursProvider).valueOrNull ?? (22 * 60 + 30, 7 * 60);
    final weekStartsMonday = ref.watch(weekStartsMondayProvider).valueOrNull ?? true;

    Future<void> reschedule() => ReminderScheduler(db).rescheduleAll();

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xxl),
        children: [
          Text('Settings', style: text.h1),
          const SizedBox(height: AppSpacing.xl),

          _SectionLabel('Appearance', text: text),
          _Row(
            label: 'Theme',
            text: text,
            colors: colors,
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('Follow system')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
              onChanged: (m) {
                if (m == null) return;
                final v = switch (m) { ThemeMode.light => 'light', ThemeMode.dark => 'dark', _ => 'system' };
                db.setSetting(SettingsKeys.themeMode, v);
              },
            ),
          ),
          _SwitchRow(
            label: 'Week starts on Monday',
            value: weekStartsMonday,
            text: text,
            colors: colors,
            onChanged: (v) => db.setSetting(SettingsKeys.weekStartsMonday, v.toString()),
          ),

          const SizedBox(height: AppSpacing.xl),
          _SectionLabel('Habits', text: text),
          Consumer(
            builder: (context, ref, _) {
              final count = ref.watch(archivedHabitsProvider).valueOrNull?.length ?? 0;
              return _Row(
                label: 'Archived habits',
                text: text,
                colors: colors,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (count > 0) Text('$count', style: text.mono),
                    const SizedBox(width: 6),
                    Icon(Icons.chevron_right, color: colors.muted),
                  ],
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ArchivedHabitsScreen()),
                ),
              );
            },
          ),

          const SizedBox(height: AppSpacing.xl),
          _SectionLabel('Reminders', text: text),
          _SwitchRow(
            label: 'Notifications',
            value: notificationsOn,
            text: text,
            colors: colors,
            onChanged: (v) async {
              await db.setSetting(SettingsKeys.notificationsEnabled, v.toString());
              await reschedule();
            },
          ),
          _SwitchRow(
            label: 'Adaptive timing',
            value: adaptiveOn,
            text: text,
            colors: colors,
            onChanged: (v) async {
              await db.setSetting(SettingsKeys.adaptiveEnabled, v.toString());
              await reschedule();
            },
          ),
          _Row(
            label: 'Quiet hours',
            text: text,
            colors: colors,
            trailing: TextButton(
              onPressed: () async {
                final start = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: quietHours.$1 ~/ 60, minute: quietHours.$1 % 60),
                );
                if (start == null || !context.mounted) return;
                final end = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: quietHours.$2 ~/ 60, minute: quietHours.$2 % 60),
                );
                if (end == null) return;
                await db.setSetting(SettingsKeys.quietStart, (start.hour * 60 + start.minute).toString());
                await db.setSetting(SettingsKeys.quietEnd, (end.hour * 60 + end.minute).toString());
                await reschedule();
              },
              child: Text(_formatRange(quietHours.$1, quietHours.$2), style: text.mono),
            ),
          ),
          _SwitchRow(
            label: 'Streak-at-risk nudge',
            value: streakNudgeOn,
            text: text,
            colors: colors,
            onChanged: (v) async {
              await db.setSetting(SettingsKeys.streakNudgeEnabled, v.toString());
              await reschedule();
            },
          ),

          const SizedBox(height: AppSpacing.xl),
          _SectionLabel('Your data', text: text),
          _Row(
            label: 'Export backup',
            text: text,
            colors: colors,
            trailing: Icon(Icons.ios_share, size: 18, color: colors.muted),
            onTap: () => BackupService(db).exportAndShare(),
          ),
          _Row(
            label: 'Restore from file',
            text: text,
            colors: colors,
            trailing: Icon(Icons.chevron_right, color: colors.muted),
            onTap: () async {
              final result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
              final path = result?.files.single.path;
              if (path == null || !context.mounted) return;
              await BackupService(db).importFromFile(File(path));
              await reschedule();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup restored')));
              }
            },
          ),
          _Row(
            label: 'Delete everything',
            text: text,
            colors: colors,
            labelColor: colors.danger,
            trailing: Icon(Icons.chevron_right, color: colors.danger),
            onTap: () => _confirmDeleteEverything(context, ref),
          ),

          const SizedBox(height: AppSpacing.xl),
          _SectionLabel('About', text: text),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snap) {
              return _Row(
                label: 'Version',
                text: text,
                colors: colors,
                trailing: Text(snap.data?.version ?? '—', style: text.mono),
              );
            },
          ),
          _SwitchRow(
            label: 'Check for updates on GitHub',
            value: ref.watch(updateCheckEnabledProvider).valueOrNull ?? false,
            text: text,
            colors: colors,
            onChanged: (v) => db.setSetting(SettingsKeys.updateCheckEnabled, v.toString()),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'The only network call this app ever makes — off by default. When on, it checks once a day at most.',
              style: text.sub,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRange(int start, int end) {
    String fmt(int m) {
      final h = m ~/ 60;
      final mm = m % 60;
      final period = h >= 12 ? 'pm' : 'am';
      final h12 = h % 12 == 0 ? 12 : h % 12;
      return '$h12:${mm.toString().padLeft(2, '0')}$period';
    }
    return '${fmt(start)} – ${fmt(end)}';
  }

  Future<void> _confirmDeleteEverything(BuildContext context, WidgetRef ref) async {
    final colors = AppColorsScope.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.card,
        title: const Text('Delete all habits and history?'),
        content: const Text('This removes every habit and every day you\'ve logged, permanently. There is no undo and no cloud copy.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete everything', style: TextStyle(color: colors.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final db = ref.read(databaseProvider);
    await BackupService(db).deleteEverything();
    await db.setSetting(SettingsKeys.onboardingDone, 'false');
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const OnboardingFlow()),
        (route) => false,
      );
    }
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label, {required this.text});
  final String label;
  final AppText text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Text(label.toUpperCase(), style: text.kicker),
      );
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.text, required this.colors, this.trailing, this.onTap, this.labelColor});
  final String label;
  final AppText text;
  final AppColors colors;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colors.lineSoft))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: text.body.copyWith(color: labelColor ?? colors.ink)),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({required this.label, required this.value, required this.text, required this.colors, required this.onChanged});
  final String label;
  final bool value;
  final AppText text;
  final AppColors colors;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colors.lineSoft))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: text.body),
          Switch(value: value, onChanged: onChanged, activeThumbColor: colors.card, activeTrackColor: colors.accent),
        ],
      ),
    );
  }
}
