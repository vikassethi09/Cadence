import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../data/db/database.dart';
import '../../data/models/habit_type.dart';
import '../../providers/database_provider.dart';
import '../../providers/habit_providers.dart';
import '../reminders/reminder_scheduler.dart';

class ArchivedHabitsScreen extends ConsumerWidget {
  const ArchivedHabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColorsScope.of(context);
    final text = AppText(colors);
    final db = ref.watch(databaseProvider);
    final archivedAsync = ref.watch(archivedHabitsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Archived habits', style: text.h2)),
      body: archivedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (habits) {
          if (habits.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'Nothing archived. Habits you archive from the editor keep their full history here.',
                  textAlign: TextAlign.center,
                  style: text.bodySoft,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: habits.length,
            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final habit = habits[index];
              return _ArchivedRow(
                habit: habit,
                colors: colors,
                text: text,
                onRestore: () async {
                  await db.restoreHabit(habit.id);
                  await ReminderScheduler(db).rescheduleAll();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${habit.name} restored')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ArchivedRow extends StatelessWidget {
  const _ArchivedRow({required this.habit, required this.colors, required this.text, required this.onRestore});

  final Habit habit;
  final AppColors colors;
  final AppText text;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.ground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: colors.lineSoft),
      ),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: Color(habit.colour))),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.name, style: text.label),
                const SizedBox(height: 2),
                Text(_archivedLabel(habit), style: text.sub),
              ],
            ),
          ),
          TextButton(
            onPressed: onRestore,
            child: Text('Restore', style: text.body.copyWith(color: colors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  String _archivedLabel(Habit habit) {
    final type = switch (HabitType.values[habit.type]) {
      HabitType.yesNo => 'Yes / no',
      HabitType.count => 'Count',
      HabitType.timed => 'Timed',
      HabitType.quit => 'Quit',
    };
    final archivedAt = habit.archivedAt;
    if (archivedAt == null) return type;
    return '$type · archived ${_formatDate(archivedAt)}';
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]}';
  }
}
