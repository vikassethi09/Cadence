import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/db/database.dart';
import 'database_provider.dart';

/// All non-archived habits, ordered by sortOrder.
final activeHabitsProvider = StreamProvider<List<Habit>>((ref) {
  return ref.watch(databaseProvider).watchActiveHabits();
});

/// Habits the user has archived, most recently archived first.
final archivedHabitsProvider = StreamProvider<List<Habit>>((ref) {
  return ref.watch(databaseProvider).watchArchivedHabits();
});

/// The currently viewed day on the Today screen (defaults to today, can be
/// changed via the week strip / backfill flow).
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// Logs for whichever date is currently selected.
final logsForSelectedDateProvider = StreamProvider<List<HabitLog>>((ref) {
  final date = ref.watch(selectedDateProvider);
  return ref.watch(databaseProvider).watchLogsForDate(date);
});

/// All logs for a single habit — used by the detail and stats screens.
final logsForHabitProvider = StreamProvider.family<List<HabitLog>, int>((ref, habitId) {
  return ref.watch(databaseProvider).watchLogsForHabit(habitId);
});
