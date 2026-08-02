import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/habit_logic.dart';
import '../../../data/db/database.dart';

/// A GitHub-style heatmap of the last [weeks] weeks, columns = weeks,
/// rows = weekday (Monday top).
class HabitHeatmap extends StatelessWidget {
  const HabitHeatmap({super.key, required this.habit, required this.logs, this.weeks = 10});

  final Habit habit;
  final List<HabitLog> logs;
  final int weeks;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsScope.of(context);
    final byDate = {for (final l in logs) DateTime(l.localDate.year, l.localDate.month, l.localDate.day): l};

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final endOfWeek = todayOnly.add(Duration(days: DateTime.sunday - todayOnly.weekday));
    final start = endOfWeek.subtract(Duration(days: weeks * 7 - 1));

    final cellColor = Color(habit.colour);

    return SizedBox(
      height: 7 * 13.0 + 6 * 3,
      child: Row(
        children: List.generate(weeks, (week) {
          return Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Column(
              children: List.generate(7, (day) {
                final date = start.add(Duration(days: week * 7 + day));
                if (date.isAfter(todayOnly) || date.isBefore(DateTime(habit.createdAt.year, habit.createdAt.month, habit.createdAt.day))) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: _cell(colors.lineSoft.withValues(alpha: 0.4)),
                  );
                }
                final level = HabitLogic.heatLevel(habit, byDate[date]);
                final color = switch (level) {
                  0 => colors.lineSoft,
                  1 => Color.lerp(colors.lineSoft, cellColor, 0.35)!,
                  2 => Color.lerp(colors.lineSoft, cellColor, 0.65)!,
                  _ => cellColor,
                };
                return Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: _cell(color),
                );
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget _cell(Color color) => Container(
        width: 13,
        height: 13,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
      );
}
