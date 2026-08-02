import 'package:cadence/core/utils/habit_logic.dart';
import 'package:cadence/data/db/database.dart';
import 'package:cadence/data/models/habit_type.dart';
import 'package:flutter_test/flutter_test.dart';

Habit _habit({
  int id = 1,
  HabitType type = HabitType.yesNo,
  int? targetValue,
  int scheduleMask = 127, // every day
  required DateTime createdAt,
}) {
  return Habit(
    id: id,
    name: 'Test habit',
    type: type.index,
    targetValue: targetValue,
    colour: 0xFF000000,
    scheduleMask: scheduleMask,
    reminderMode: 0,
    createdAt: createdAt,
    sortOrder: 0,
  );
}

HabitLog _log({
  required int habitId,
  required DateTime date,
  int value = 1,
  bool skipped = false,
}) {
  return HabitLog(
    id: date.millisecondsSinceEpoch, // unique enough for test fixtures
    habitId: habitId,
    localDate: DateTime(date.year, date.month, date.day),
    value: value,
    completedAt: date,
    source: 0,
    skipped: skipped,
  );
}

void main() {
  // A fixed "today" so streak math doesn't depend on wall-clock time.
  final today = DateTime(2026, 8, 10); // a Monday
  DateTime daysAgo(int n) => today.subtract(Duration(days: n));

  group('isScheduledOn', () {
    test('every-day mask matches every weekday', () {
      final habit = _habit(createdAt: daysAgo(30));
      for (var i = 0; i < 7; i++) {
        expect(HabitLogic.isScheduledOn(habit, today.add(Duration(days: i))), isTrue);
      }
    });

    test('a single-day mask only matches that weekday', () {
      // bit 0 = Monday
      final habit = _habit(createdAt: daysAgo(30), scheduleMask: 1);
      expect(HabitLogic.isScheduledOn(habit, today), isTrue); // today is Monday
      expect(HabitLogic.isScheduledOn(habit, today.add(const Duration(days: 1))), isFalse); // Tuesday
    });
  });

  group('isDone', () {
    test('yesNo is done only when a log exists and is not skipped', () {
      final habit = _habit(createdAt: daysAgo(1));
      expect(HabitLogic.isDone(habit, null), isFalse);
      expect(HabitLogic.isDone(habit, _log(habitId: 1, date: today)), isTrue);
      expect(HabitLogic.isDone(habit, _log(habitId: 1, date: today, skipped: true)), isFalse);
    });

    test('quit is done when there is no log (silence is success)', () {
      final habit = _habit(createdAt: daysAgo(1), type: HabitType.quit);
      expect(HabitLogic.isDone(habit, null), isTrue);
      expect(HabitLogic.isDone(habit, _log(habitId: 1, date: today)), isFalse); // a log = a slip
    });

    test('count is done once value reaches target, not before', () {
      final habit = _habit(createdAt: daysAgo(1), type: HabitType.count, targetValue: 8);
      expect(HabitLogic.isDone(habit, _log(habitId: 1, date: today, value: 7)), isFalse);
      expect(HabitLogic.isDone(habit, _log(habitId: 1, date: today, value: 8)), isTrue);
      expect(HabitLogic.isDone(habit, _log(habitId: 1, date: today, value: 12)), isTrue);
    });
  });

  group('currentStreak', () {
    test('counts consecutive done days ending today', () {
      final habit = _habit(createdAt: daysAgo(10));
      final logs = [
        _log(habitId: 1, date: today),
        _log(habitId: 1, date: daysAgo(1)),
        _log(habitId: 1, date: daysAgo(2)),
      ];
      expect(HabitLogic.currentStreak(habit, logs, today), 3);
    });

    test('today not yet done does not break a live streak', () {
      final habit = _habit(createdAt: daysAgo(10));
      final logs = [
        _log(habitId: 1, date: daysAgo(1)),
        _log(habitId: 1, date: daysAgo(2)),
      ];
      expect(HabitLogic.currentStreak(habit, logs, today), 2);
    });

    test('a miss in the past breaks the streak', () {
      final habit = _habit(createdAt: daysAgo(10));
      final logs = [
        _log(habitId: 1, date: today),
        _log(habitId: 1, date: daysAgo(1)),
        // daysAgo(2) missing — breaks it
        _log(habitId: 1, date: daysAgo(3)),
      ];
      expect(HabitLogic.currentStreak(habit, logs, today), 2);
    });

    test('a skipped day does not break the streak and is not counted', () {
      final habit = _habit(createdAt: daysAgo(10));
      final logs = [
        _log(habitId: 1, date: today),
        _log(habitId: 1, date: daysAgo(1), skipped: true), // rest day
        _log(habitId: 1, date: daysAgo(2)),
      ];
      // today + daysAgo(2) count; the skipped day in between is invisible to the streak.
      expect(HabitLogic.currentStreak(habit, logs, today), 2);
    });

    test('non-scheduled days are skipped over, not counted as misses', () {
      // Scheduled Mon/Wed/Fri only (bits 0, 2, 4).
      final habit = _habit(createdAt: daysAgo(10), scheduleMask: 1 | 4 | 16);
      // today (Mon) done, Sunday/Saturday not scheduled, Friday done.
      final logs = [
        _log(habitId: 1, date: today), // Monday
        _log(habitId: 1, date: daysAgo(3)), // Friday
      ];
      expect(HabitLogic.currentStreak(habit, logs, today), 2);
    });
  });

  group('bestStreak', () {
    test('finds the longest run even if it is not the current one', () {
      final habit = _habit(createdAt: daysAgo(10));
      final logs = [
        _log(habitId: 1, date: daysAgo(8)),
        _log(habitId: 1, date: daysAgo(7)),
        _log(habitId: 1, date: daysAgo(6)),
        _log(habitId: 1, date: daysAgo(5)),
        // gap
        _log(habitId: 1, date: today),
      ];
      expect(HabitLogic.bestStreak(habit, logs, today), 4);
    });
  });

  group('completionRate', () {
    test('is 0 with no logs and no window', () {
      final habit = _habit(createdAt: today);
      expect(HabitLogic.completionRate(habit, const [], today, days: 7), 0);
    });

    test('counts only scheduled, non-skipped days in the denominator', () {
      final habit = _habit(createdAt: daysAgo(6));
      final logs = [
        _log(habitId: 1, date: today),
        _log(habitId: 1, date: daysAgo(1)),
        _log(habitId: 1, date: daysAgo(2), skipped: true),
      ];
      // Window of 7 days (today..daysAgo(6)) minus the 1 skipped day = 6 scheduled days, 2 done.
      expect(HabitLogic.completionRate(habit, logs, today, days: 7), closeTo(2 / 6, 0.0001));
    });
  });
}
