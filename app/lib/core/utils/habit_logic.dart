import '../../data/db/database.dart';
import '../../data/models/habit_type.dart';

/// Pure functions over a habit's logs. Nothing here touches the database —
/// streaks and completion rates are always derived, never stored, so they
/// can never drift out of sync with the logs behind them.
class HabitLogic {
  static HabitType typeOf(Habit habit) => HabitType.values[habit.type];

  static bool isScheduledOn(Habit habit, DateTime date) {
    final bit = date.weekday - 1; // Monday=0 .. Sunday=6
    return (habit.scheduleMask >> bit) & 1 == 1;
  }

  /// True for a deliberate rest day — swiped on from the Today screen.
  /// Excluded from streaks and completion rate, distinct from a miss.
  static bool isSkipped(HabitLog? log) => log?.skipped == true;

  /// Whether [habit] counts as complete on [date] given that day's log (if any).
  static bool isDone(Habit habit, HabitLog? log) {
    if (isSkipped(log)) return false;
    final type = typeOf(habit);
    switch (type) {
      case HabitType.yesNo:
        return log != null;
      case HabitType.quit:
        // Presence of a log means a slip; success is silence.
        return log == null;
      case HabitType.count:
      case HabitType.timed:
        final target = habit.targetValue ?? 1;
        return (log?.value ?? 0) >= target;
    }
  }

  /// 0.0–1.0 progress for count/timed habits; 0 or 1 for the others.
  static double progressOf(Habit habit, HabitLog? log) {
    final type = typeOf(habit);
    if (type == HabitType.count || type == HabitType.timed) {
      final target = (habit.targetValue ?? 1).clamp(1, 1 << 30);
      final value = log?.value ?? 0;
      return (value / target).clamp(0.0, 1.0);
    }
    return isDone(habit, log) ? 1.0 : 0.0;
  }

  /// Consecutive days of success counting back from [asOf] (inclusive),
  /// skipping days the habit wasn't scheduled on.
  static int currentStreak(Habit habit, List<HabitLog> allLogs, DateTime asOf) {
    final byDate = _indexByDate(allLogs);
    var streak = 0;
    var cursor = _dateOnly(asOf);
    final createdDate = _dateOnly(habit.createdAt);

    while (!cursor.isBefore(createdDate)) {
      final log = byDate[cursor];
      if (!isScheduledOn(habit, cursor) || isSkipped(log)) {
        cursor = cursor.subtract(const Duration(days: 1));
        continue;
      }
      final done = isDone(habit, log);
      if (cursor == _dateOnly(asOf) && !done) {
        // Today not yet done doesn't break a streak that's still "live".
        cursor = cursor.subtract(const Duration(days: 1));
        continue;
      }
      if (!done) break;
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Longest run of consecutive scheduled-day successes across all history.
  static int bestStreak(Habit habit, List<HabitLog> allLogs, DateTime asOf) {
    final byDate = _indexByDate(allLogs);
    final createdDate = _dateOnly(habit.createdAt);
    final today = _dateOnly(asOf);

    var best = 0;
    var running = 0;
    var cursor = createdDate;
    while (!cursor.isAfter(today)) {
      final log = byDate[cursor];
      if (isScheduledOn(habit, cursor) && !isSkipped(log)) {
        final done = isDone(habit, log);
        if (done) {
          running++;
          if (running > best) best = running;
        } else if (cursor != today) {
          running = 0;
        }
      }
      cursor = cursor.add(const Duration(days: 1));
    }
    return best;
  }

  /// Completion rate over the last [days] scheduled, non-skipped days,
  /// ending [asOf].
  static double completionRate(Habit habit, List<HabitLog> allLogs, DateTime asOf, {int days = 30}) {
    final byDate = _indexByDate(allLogs);
    final today = _dateOnly(asOf);
    final createdDate = _dateOnly(habit.createdAt);
    var scheduled = 0;
    var done = 0;
    var cursor = today.subtract(Duration(days: days - 1));
    if (cursor.isBefore(createdDate)) cursor = createdDate;

    while (!cursor.isAfter(today)) {
      final log = byDate[cursor];
      if (isScheduledOn(habit, cursor) && !isSkipped(log)) {
        scheduled++;
        if (isDone(habit, log)) done++;
      }
      cursor = cursor.add(const Duration(days: 1));
    }
    if (scheduled == 0) return 0;
    return done / scheduled;
  }

  /// Heat-level 0-3 for a single day, used by the calendar heatmap.
  static int heatLevel(Habit habit, HabitLog? log) {
    if (!isDone(habit, log)) return 0;
    final type = typeOf(habit);
    if (type == HabitType.count || type == HabitType.timed) {
      final target = (habit.targetValue ?? 1).clamp(1, 1 << 30);
      final ratio = (log?.value ?? 0) / target;
      if (ratio >= 1.5) return 3;
      if (ratio >= 1.0) return 2;
      return 1;
    }
    return 3;
  }

  static Map<DateTime, HabitLog> _indexByDate(List<HabitLog> logs) {
    return {for (final l in logs) _dateOnly(l.localDate): l};
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
