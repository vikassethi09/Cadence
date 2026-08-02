import 'package:drift/drift.dart' show Value;

import '../../core/utils/habit_logic.dart';
import '../../data/db/database.dart';
import '../../data/models/habit_type.dart';
import '../../providers/settings_providers.dart' show SettingsKeys;
import 'adaptive_engine.dart';
import 'notification_service.dart';

/// Recomputes every active habit's nudge time and re-arms notifications.
/// Called on app start, after any habit is saved, and (best-effort) from a
/// nightly background job. Idempotent — safe to call as often as needed.
class ReminderScheduler {
  ReminderScheduler(this.db);
  final AppDatabase db;

  Future<void> rescheduleAll() async {
    final notificationsOn = (await db.getSetting(SettingsKeys.notificationsEnabled)) != 'false';
    if (!notificationsOn) {
      await NotificationService.instance.cancelAll();
      return;
    }

    final adaptiveOn = (await db.getSetting(SettingsKeys.adaptiveEnabled)) != 'false';
    final quietStart = int.tryParse(await db.getSetting(SettingsKeys.quietStart) ?? '') ?? (22 * 60 + 30);
    final quietEnd = int.tryParse(await db.getSetting(SettingsKeys.quietEnd) ?? '') ?? (7 * 60);

    final habits = await (db.select(db.habits)..where((h) => h.archivedAt.isNull())).get();
    final atRiskNames = <String>[];
    final now = DateTime.now();

    for (final habit in habits) {
      final mode = ReminderMode.values[habit.reminderMode];
      if (mode == ReminderMode.off) {
        await NotificationService.instance.cancelForHabit(habit.id);
        continue;
      }

      final logs = await db.logsForHabit(habit.id);
      final streak = HabitLogic.currentStreak(habit, logs, now);
      final fallback = habit.fallbackTimeMinutes ?? (9 * 60);

      if (mode == ReminderMode.interval) {
        final intervalMinutes = habit.intervalMinutes ?? 120;
        var start = habit.intervalStartMinutes ?? (9 * 60);
        var end = habit.intervalEndMinutes ?? (21 * 60);
        // Quiet hours still win — pull the window's edges in to respect them.
        start = _clampOutsideQuietHours(start, quietStart, quietEnd);
        end = _clampOutsideQuietHours(end, quietStart, quietEnd);
        await NotificationService.instance.scheduleIntervalHabitReminders(
          habitId: habit.id,
          habitName: habit.name,
          scheduleMask: habit.scheduleMask,
          intervalMinutes: intervalMinutes,
          startMinutes: start,
          endMinutes: end,
        );
      } else {
        int minutes;
        if (mode == ReminderMode.adaptive && adaptiveOn) {
          final result = AdaptiveEngine.compute(logs);
          minutes = result.nudgeMinutesFor(now, fallback);
          await db.upsertNudgeState(NudgeStatesCompanion.insert(
            habitId: Value(habit.id),
            learnedWeekdayMinutes: Value(result.weekdayMinutes),
            learnedWeekendMinutes: Value(result.weekendMinutes),
            sampleCount: Value(result.sampleCount),
            spreadMinutes: Value(result.spreadMinutes),
            confident: Value(result.confident),
          ));
        } else {
          minutes = fallback;
        }

        minutes = _clampOutsideQuietHours(minutes, quietStart, quietEnd);

        await NotificationService.instance.scheduleHabitReminders(
          habitId: habit.id,
          habitName: habit.name,
          scheduleMask: habit.scheduleMask,
          minutesOfDay: minutes,
          streakLength: streak,
        );
      }

      if (streak >= 3 && HabitLogic.isScheduledOn(habit, now) && !HabitLogic.isDone(habit, _todayLog(logs, now))) {
        atRiskNames.add(habit.name);
      }
    }

    final streakNudgeOn = (await db.getSetting(SettingsKeys.streakNudgeEnabled)) != 'false';
    if (streakNudgeOn && atRiskNames.isNotEmpty) {
      final eveningMinutes = _clampOutsideQuietHours(20 * 60 + 30, quietStart, quietEnd);
      await NotificationService.instance.scheduleStreakSweep(
        minutesOfDay: eveningMinutes,
        body: atRiskNames.join(' · '),
      );
    } else {
      await NotificationService.instance.scheduleStreakSweep(minutesOfDay: 0, body: '');
    }
  }

  HabitLog? _todayLog(List<HabitLog> logs, DateTime today) {
    for (final l in logs) {
      if (l.localDate.year == today.year && l.localDate.month == today.month && l.localDate.day == today.day) {
        return l;
      }
    }
    return null;
  }

  /// Pushes [minutes] to the far edge of quiet hours if it falls inside
  /// them. Quiet hours always win over any learned or fixed time.
  int _clampOutsideQuietHours(int minutes, int quietStart, int quietEnd) {
    final spansMidnight = quietStart > quietEnd;
    final inQuiet = spansMidnight ? (minutes >= quietStart || minutes < quietEnd) : (minutes >= quietStart && minutes < quietEnd);
    if (!inQuiet) return minutes;
    return quietEnd;
  }
}
