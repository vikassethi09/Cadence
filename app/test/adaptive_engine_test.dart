import 'package:cadence/data/db/database.dart';
import 'package:cadence/features/reminders/adaptive_engine.dart';
import 'package:flutter_test/flutter_test.dart';

HabitLog _completionAt(DateTime dateTime) {
  return HabitLog(
    id: dateTime.millisecondsSinceEpoch,
    habitId: 1,
    localDate: DateTime(dateTime.year, dateTime.month, dateTime.day),
    value: 1,
    completedAt: dateTime,
    source: 0,
    skipped: false,
  );
}

void main() {
  group('AdaptiveEngine.compute', () {
    test('is not confident with fewer than 7 total samples', () {
      final logs = List.generate(6, (i) => _completionAt(DateTime(2026, 8, i + 1, 7, 0)));
      final result = AdaptiveEngine.compute(logs);
      expect(result.confident, isFalse);
      expect(result.weekdayMinutes, isNull);
      expect(result.weekendMinutes, isNull);
    });

    test('learns a tight weekday cluster once there is enough history', () {
      // 2026-08-03 is a Monday; 5 consecutive weekdays all around 7:00-7:10am.
      final logs = [
        _completionAt(DateTime(2026, 8, 3, 7, 0)), // Mon
        _completionAt(DateTime(2026, 8, 4, 7, 5)), // Tue
        _completionAt(DateTime(2026, 8, 5, 6, 55)), // Wed
        _completionAt(DateTime(2026, 8, 6, 7, 10)), // Thu
        _completionAt(DateTime(2026, 8, 7, 7, 0)), // Fri
        _completionAt(DateTime(2026, 8, 10, 7, 5)), // Mon
        _completionAt(DateTime(2026, 8, 11, 7, 0)), // Tue
      ];
      final result = AdaptiveEngine.compute(logs);
      expect(result.confident, isTrue);
      expect(result.weekdayMinutes, isNotNull);
      // Median should land squarely in the 6:55-7:10 cluster.
      expect(result.weekdayMinutes!, inInclusiveRange(6 * 60 + 55, 7 * 60 + 10));
    });

    test('does not learn a time when completions are scattered all over the day', () {
      final logs = [
        _completionAt(DateTime(2026, 8, 3, 6, 0)),
        _completionAt(DateTime(2026, 8, 4, 12, 0)),
        _completionAt(DateTime(2026, 8, 5, 18, 0)),
        _completionAt(DateTime(2026, 8, 6, 22, 0)),
        _completionAt(DateTime(2026, 8, 7, 8, 0)),
        _completionAt(DateTime(2026, 8, 10, 14, 0)),
        _completionAt(DateTime(2026, 8, 11, 20, 0)),
      ];
      final result = AdaptiveEngine.compute(logs);
      // Confidently wrong is worse than not trying — spread exceeds the 3-hour cutoff.
      expect(result.weekdayMinutes, isNull);
    });

    test('keeps weekday and weekend rhythms separate', () {
      final logs = [
        // Weekdays cluster at 7am.
        _completionAt(DateTime(2026, 8, 3, 7, 0)),
        _completionAt(DateTime(2026, 8, 4, 7, 0)),
        _completionAt(DateTime(2026, 8, 5, 7, 0)),
        _completionAt(DateTime(2026, 8, 6, 7, 0)),
        // Weekends cluster at 9:30am.
        _completionAt(DateTime(2026, 8, 8, 9, 30)), // Sat
        _completionAt(DateTime(2026, 8, 9, 9, 30)), // Sun
        _completionAt(DateTime(2026, 8, 15, 9, 30)), // Sat
        _completionAt(DateTime(2026, 8, 16, 9, 30)), // Sun
      ];
      final result = AdaptiveEngine.compute(logs);
      expect(result.weekdayMinutes, 7 * 60);
      expect(result.weekendMinutes, 9 * 60 + 30);
    });
  });

  group('AdaptiveResult.nudgeMinutesFor', () {
    test('fires 15 minutes before the learned weekday time', () {
      const result = AdaptiveResult(
        weekdayMinutes: 7 * 60, // 7:00am
        weekendMinutes: null,
        sampleCount: 10,
        spreadMinutes: 10,
        confident: true,
      );
      final monday = DateTime(2026, 8, 10); // Monday
      expect(result.nudgeMinutesFor(monday, 9 * 60), 6 * 60 + 45);
    });

    test('falls back to the given default when nothing is learned yet', () {
      const result = AdaptiveResult.empty;
      final monday = DateTime(2026, 8, 10);
      expect(result.nudgeMinutesFor(monday, 9 * 60), 8 * 60 + 45);
    });

    test('wraps around midnight for an early-morning learned time', () {
      const result = AdaptiveResult(
        weekdayMinutes: 5, // 12:05am
        weekendMinutes: null,
        sampleCount: 10,
        spreadMinutes: 5,
        confident: true,
      );
      final monday = DateTime(2026, 8, 10);
      // 15 minutes before 00:05 wraps to 23:50 the previous day.
      expect(result.nudgeMinutesFor(monday, 9 * 60), 23 * 60 + 50);
    });
  });
}
