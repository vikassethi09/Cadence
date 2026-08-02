import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/habit_logic.dart';
import '../../data/db/database.dart';
import '../../data/models/habit_type.dart';
import '../../providers/database_provider.dart';
import '../../providers/habit_providers.dart';
import '../habit_editor/habit_editor_screen.dart';
import 'widgets/heatmap.dart';

class HabitDetailScreen extends ConsumerWidget {
  const HabitDetailScreen({super.key, required this.habitId});
  final int habitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColorsScope.of(context);
    final text = AppText(colors);
    final db = ref.watch(databaseProvider);
    final logsAsync = ref.watch(logsForHabitProvider(habitId));

    return FutureBuilder<Habit?>(
      future: db.getHabit(habitId),
      builder: (context, habitSnap) {
        final habit = habitSnap.data;
        if (habit == null) return const Scaffold(body: SizedBox.shrink());

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => HabitEditorScreen(existing: habit)),
                ),
              ),
            ],
          ),
          body: logsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (logs) {
              final now = DateTime.now();
              final streak = HabitLogic.currentStreak(habit, logs, now);
              final best = HabitLogic.bestStreak(habit, logs, now);
              final rate = HabitLogic.completionRate(habit, logs, now, days: 30);
              final habitColor = Color(habit.colour);

              return ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xxl),
                children: [
                  Text(habit.name, style: text.h1),
                  const SizedBox(height: 4),
                  Text(_scheduleDescription(habit), style: text.sub),
                  const SizedBox(height: AppSpacing.xl),

                  Row(
                    children: [
                      Expanded(child: _StatTile(label: 'Current streak', value: '$streak', text: text, colors: colors)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: _StatTile(label: 'Best streak', value: '$best', text: text, colors: colors)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(child: _StatTile(label: 'Last 30 days', value: '${(rate * 100).round()}%', text: text, colors: colors)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: _StatTile(label: 'Total logged', value: '${logs.length}', text: text, colors: colors)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  Text('LAST 10 WEEKS', style: text.kicker),
                  const SizedBox(height: AppSpacing.sm),
                  HabitHeatmap(habit: habit, logs: logs),
                  const SizedBox(height: AppSpacing.xl),

                  if (ReminderMode.values[habit.reminderMode] != ReminderMode.off)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colors.signalDim,
                        border: Border.all(color: colors.signal.withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            switch (ReminderMode.values[habit.reminderMode]) {
                              ReminderMode.adaptive => 'REMINDER · ADAPTIVE',
                              ReminderMode.interval => 'REMINDER · INTERVAL',
                              _ => 'REMINDER · FIXED',
                            },
                            style: text.kicker.copyWith(color: colors.signal),
                          ),
                          const SizedBox(height: 6),
                          Text(_reminderDescription(habit), style: text.bodySoft),
                        ],
                      ),
                    ),

                  const SizedBox(height: AppSpacing.xl),
                  _BestDayInsight(habit: habit, logs: logs, text: text, colors: colors),

                  const SizedBox(height: AppSpacing.xxl),
                  Row(
                    children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: habitColor)),
                      const SizedBox(width: 8),
                      Text('Habit colour', style: text.sub),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  String _scheduleDescription(Habit habit) {
    final typeLabel = switch (HabitType.values[habit.type]) {
      HabitType.yesNo => 'Yes / no',
      HabitType.count => 'Count',
      HabitType.timed => 'Timed',
      HabitType.quit => 'Quit',
    };
    if (habit.scheduleMask == 127) return '$typeLabel · every day';
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final days = [for (var i = 0; i < 7; i++) if ((habit.scheduleMask >> i) & 1 == 1) labels[i]];
    return '$typeLabel · ${days.join(', ')}';
  }

  String _reminderDescription(Habit habit) {
    final mode = ReminderMode.values[habit.reminderMode];
    final time = habit.fallbackTimeMinutes;
    final timeStr = time != null ? _formatMinutes(time) : '—';
    if (mode == ReminderMode.adaptive) {
      return 'Learning your rhythm. Nudging at $timeStr until there\'s enough history to adapt.';
    }
    if (mode == ReminderMode.interval) {
      final every = habit.intervalMinutes ?? 120;
      final everyStr = every < 60 ? '$every min' : '${every ~/ 60}h';
      final start = habit.intervalStartMinutes != null ? _formatMinutes(habit.intervalStartMinutes!) : '—';
      final end = habit.intervalEndMinutes != null ? _formatMinutes(habit.intervalEndMinutes!) : '—';
      return 'Nudging every $everyStr, from $start to $end.';
    }
    return 'Nudging every scheduled day at $timeStr.';
  }

  String _formatMinutes(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    final period = h >= 12 ? 'pm' : 'am';
    final h12 = h % 12 == 0 ? 12 : h % 12;
    return '$h12:${m.toString().padLeft(2, '0')} $period';
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.text, required this.colors});
  final String label;
  final String value;
  final AppText text;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(border: Border.all(color: colors.lineSoft), borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: text.statNumber),
          const SizedBox(height: 2),
          Text(label.toUpperCase(), style: text.kicker),
        ],
      ),
    );
  }
}

class _BestDayInsight extends StatelessWidget {
  const _BestDayInsight({required this.habit, required this.logs, required this.text, required this.colors});
  final Habit habit;
  final List<HabitLog> logs;
  final AppText text;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final byDate = {for (final l in logs) DateTime(l.localDate.year, l.localDate.month, l.localDate.day): l};
    final today = DateTime.now();
    var cursor = DateTime(habit.createdAt.year, habit.createdAt.month, habit.createdAt.day);
    final todayOnly = DateTime(today.year, today.month, today.day);

    final counts = List.generate(7, (_) => [0, 0]); // [done, scheduled]
    while (!cursor.isAfter(todayOnly)) {
      if (HabitLogic.isScheduledOn(habit, cursor)) {
        final idx = cursor.weekday - 1;
        counts[idx][1]++;
        if (HabitLogic.isDone(habit, byDate[cursor])) counts[idx][0]++;
      }
      cursor = cursor.add(const Duration(days: 1));
    }

    const labels = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    int bestIdx = -1;
    double bestRate = -1;
    for (var i = 0; i < 7; i++) {
      if (counts[i][1] < 2) continue;
      final rate = counts[i][0] / counts[i][1];
      if (rate > bestRate) {
        bestRate = rate;
        bestIdx = i;
      }
    }

    if (bestIdx == -1) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('BEST DAY', style: text.kicker),
        const SizedBox(height: 6),
        Text(
          '${labels[bestIdx]}s — ${(bestRate * 100).round()}% done.',
          style: text.bodySoft,
        ),
      ],
    );
  }
}
