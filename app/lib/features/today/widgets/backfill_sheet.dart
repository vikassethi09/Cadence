import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/habit_logic.dart';
import '../../../data/db/database.dart';
import '../../../data/models/habit_type.dart';

/// Lets the user fix up the last two weeks for one habit without leaving
/// Today — long-press a row to open this instead of hunting through a
/// full-screen date picker for a single missed day.
Future<void> showBackfillSheet(BuildContext context, {required AppDatabase db, required Habit habit}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _BackfillSheet(db: db, habit: habit),
  );
}

class _BackfillSheet extends StatelessWidget {
  const _BackfillSheet({required this.db, required this.habit});
  final AppDatabase db;
  final Habit habit;

  static const _days = 14;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsScope.of(context);
    final text = AppText(colors);
    final today = DateTime.now();
    final type = HabitLogic.typeOf(habit);
    final isQuit = type == HabitType.quit;
    final isNumeric = type == HabitType.count || type == HabitType.timed;

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      child: FutureBuilder<List<HabitLog>>(
        future: db.logsForHabit(habit.id),
        builder: (context, snap) {
          final logs = snap.data ?? const <HabitLog>[];
          final byDate = {for (final l in logs) DateTime(l.localDate.year, l.localDate.month, l.localDate.day): l};

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 36, height: 4, decoration: BoxDecoration(color: colors.line, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: AppSpacing.lg),
                    Text(habit.name, style: text.h2),
                    const SizedBox(height: 4),
                    Text(
                      isQuit
                          ? 'Tap a day to mark or clear a slip.'
                          : isNumeric
                              ? 'Tap a day to enter or fix its exact value.'
                              : 'Tap a day to fill in or clear it.',
                      style: text.sub,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  itemCount: _days,
                  itemBuilder: (context, i) {
                    final date = DateTime(today.year, today.month, today.day).subtract(Duration(days: i));
                    if (date.isBefore(DateTime(habit.createdAt.year, habit.createdAt.month, habit.createdAt.day))) {
                      return const SizedBox.shrink();
                    }
                    final log = byDate[date];
                    final scheduled = HabitLogic.isScheduledOn(habit, date);
                    final done = HabitLogic.isDone(habit, log);
                    final skipped = HabitLogic.isSkipped(log);
                    final value = log?.value ?? 0;

                    return _DayRow(
                      date: date,
                      isToday: i == 0,
                      scheduled: scheduled,
                      done: done,
                      skipped: skipped,
                      valueLabel: isNumeric && scheduled && !skipped ? _valueLabel(type, habit, value) : null,
                      colors: colors,
                      text: text,
                      onTap: !scheduled
                          ? null
                          : () async {
                              if (isQuit) {
                                await db.setSlip(habit.id, date, !done);
                              } else if (isNumeric) {
                                final entered = await _showEditValueDialog(
                                  context,
                                  type: type,
                                  habit: habit,
                                  initialSeconds: value,
                                );
                                if (entered != null) {
                                  await db.setExactValue(habit.id, date, entered);
                                }
                              } else if (done) {
                                await db.unmarkDone(habit.id, date);
                              } else {
                                await db.markFullyDone(habit.id, date);
                              }
                            },
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          );
        },
      ),
    );
  }

  String _valueLabel(HabitType type, Habit habit, int value) {
    final target = habit.targetValue ?? 1;
    if (type == HabitType.timed) {
      return '${value ~/ 60}/${target ~/ 60} min';
    }
    return '$value/$target ${habit.targetUnit ?? ''}'.trim();
  }

  Future<int?> _showEditValueDialog(
    BuildContext context, {
    required HabitType type,
    required Habit habit,
    required int initialSeconds,
  }) async {
    final isTimed = type == HabitType.timed;
    final initial = isTimed ? initialSeconds ~/ 60 : initialSeconds;
    final controller = TextEditingController(text: initial == 0 ? '' : initial.toString());
    final colors = AppColorsScope.of(context);
    final unit = isTimed ? 'minutes' : (habit.targetUnit?.isNotEmpty == true ? habit.targetUnit! : 'count');

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.card,
        title: Text('${habit.name} — $unit'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'e.g. ${habit.targetValue != null && isTimed ? habit.targetValue! ~/ 60 : habit.targetValue ?? 0}'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final raw = int.tryParse(controller.text.trim()) ?? 0;
              Navigator.of(context).pop(isTimed ? raw * 60 : raw);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    return result;
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.date,
    required this.isToday,
    required this.scheduled,
    required this.done,
    required this.skipped,
    required this.colors,
    required this.text,
    required this.onTap,
    this.valueLabel,
  });

  final DateTime date;
  final bool isToday;
  final bool scheduled;
  final bool done;
  final bool skipped;
  final AppColors colors;
  final AppText text;
  final VoidCallback? onTap;

  /// When set (count/timed habits), shows the exact logged value instead of
  /// a plain done/not-done circle — tapping opens an editable value dialog.
  final String? valueLabel;

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  @override
  Widget build(BuildContext context) {
    final label = isToday ? 'Today' : '${_weekdays[date.weekday - 1]}, ${date.day} ${_months[date.month - 1]}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: text.body.copyWith(color: scheduled ? colors.ink : colors.muted),
              ),
            ),
            if (!scheduled)
              Text('Not scheduled', style: text.sub)
            else if (skipped)
              Text('Skipped', style: text.sub.copyWith(fontStyle: FontStyle.italic))
            else if (valueLabel != null)
              Text(valueLabel!, style: text.body.copyWith(color: done ? colors.accent : colors.inkSoft, fontWeight: FontWeight.w500))
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? colors.accent : Colors.transparent,
                  border: Border.all(color: done ? colors.accent : colors.line, width: 1.6),
                ),
                alignment: Alignment.center,
                child: done ? Icon(Icons.check, size: 15, color: colors.card) : null,
              ),
          ],
        ),
      ),
    );
  }
}
