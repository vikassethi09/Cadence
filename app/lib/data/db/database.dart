import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../models/habit_type.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Habits, HabitLogs, NudgeStates, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(habitLogs, habitLogs.skipped);
          }
          if (from < 3) {
            await m.addColumn(habits, habits.intervalMinutes);
            await m.addColumn(habits, habits.intervalStartMinutes);
            await m.addColumn(habits, habits.intervalEndMinutes);
          }
        },
      );

  // ---------------------------------------------------------------------
  // Habits
  // ---------------------------------------------------------------------

  Stream<List<Habit>> watchActiveHabits() {
    return (select(habits)
          ..where((h) => h.archivedAt.isNull())
          ..orderBy([(h) => OrderingTerm.asc(h.sortOrder)]))
        .watch();
  }

  Stream<List<Habit>> watchArchivedHabits() {
    return (select(habits)
          ..where((h) => h.archivedAt.isNotNull())
          ..orderBy([(h) => OrderingTerm.desc(h.archivedAt)]))
        .watch();
  }

  Future<Habit?> getHabit(int id) =>
      (select(habits)..where((h) => h.id.equals(id))).getSingleOrNull();

  Future<int> insertHabit(HabitsCompanion habit) => into(habits).insert(habit);

  Future<void> updateHabit(HabitsCompanion habit) =>
      (update(habits)..where((h) => h.id.equals(habit.id.value))).write(habit);

  Future<void> archiveHabit(int id) => (update(habits)..where((h) => h.id.equals(id)))
      .write(HabitsCompanion(archivedAt: Value(DateTime.now())));

  Future<void> restoreHabit(int id) => (update(habits)..where((h) => h.id.equals(id)))
      .write(const HabitsCompanion(archivedAt: Value(null)));

  /// Persists a new relative order for exactly [orderedIds] — habits not in
  /// the list (e.g. not scheduled on the day being reordered) keep their
  /// existing sortOrder untouched.
  Future<void> reorderHabits(List<int> orderedIds) async {
    await batch((b) {
      for (var i = 0; i < orderedIds.length; i++) {
        b.update(
          habits,
          HabitsCompanion(sortOrder: Value(i)),
          where: (h) => h.id.equals(orderedIds[i]),
        );
      }
    });
  }

  // ---------------------------------------------------------------------
  // Logs
  // ---------------------------------------------------------------------

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  Stream<List<HabitLog>> watchLogsForDate(DateTime date) {
    final day = dateOnly(date);
    return (select(habitLogs)..where((l) => l.localDate.equals(day))).watch();
  }

  Future<List<HabitLog>> logsForHabit(int habitId) => (select(habitLogs)
        ..where((l) => l.habitId.equals(habitId))
        ..orderBy([(l) => OrderingTerm.asc(l.localDate)]))
      .get();

  Stream<List<HabitLog>> watchLogsForHabit(int habitId) => (select(habitLogs)
        ..where((l) => l.habitId.equals(habitId))
        ..orderBy([(l) => OrderingTerm.asc(l.localDate)]))
      .watch();

  Future<HabitLog?> logForHabitAndDate(int habitId, DateTime date) {
    final day = dateOnly(date);
    return (select(habitLogs)
          ..where((l) => l.habitId.equals(habitId) & l.localDate.equals(day)))
        .getSingleOrNull();
  }

  /// Marks a yes/no habit done or undone for [date]. Clears any rest-day
  /// skip marker first, so tapping "done" always wins over a prior skip.
  Future<void> setYesNoDone(int habitId, DateTime date, bool done, {LogSourceArg source = LogSourceArg.app}) async {
    final existing = await logForHabitAndDate(habitId, date);
    if (done && existing == null) {
      await into(habitLogs).insert(HabitLogsCompanion.insert(
        habitId: habitId,
        localDate: dateOnly(date),
        completedAt: Value(DateTime.now()),
        source: Value(source.index),
      ));
    } else if (done && existing != null && existing.skipped) {
      await (update(habitLogs)..where((l) => l.id.equals(existing.id)))
          .write(HabitLogsCompanion(skipped: const Value(false), completedAt: Value(DateTime.now())));
    } else if (!done && existing != null) {
      await (delete(habitLogs)..where((l) => l.id.equals(existing.id))).go();
    }
  }

  /// Adds [delta] to a count habit's progress for [date], clamped at 0.
  Future<void> adjustCount(int habitId, DateTime date, int delta, {LogSourceArg source = LogSourceArg.app}) async {
    final existing = await logForHabitAndDate(habitId, date);
    if (existing == null) {
      if (delta <= 0) return;
      await into(habitLogs).insert(HabitLogsCompanion.insert(
        habitId: habitId,
        localDate: dateOnly(date),
        value: Value(delta),
        completedAt: Value(DateTime.now()),
        source: Value(source.index),
      ));
    } else {
      final next = (existing.value + delta).clamp(0, 1 << 30);
      if (next == 0 && !existing.skipped) {
        await (delete(habitLogs)..where((l) => l.id.equals(existing.id))).go();
      } else {
        await (update(habitLogs)..where((l) => l.id.equals(existing.id))).write(
          HabitLogsCompanion(value: Value(next), completedAt: Value(DateTime.now()), skipped: const Value(false)),
        );
      }
    }
  }

  /// Records a completed timed session (adds seconds; a session is "done"
  /// once total seconds for the day meets the habit's target).
  Future<void> logTimedSeconds(int habitId, DateTime date, int seconds, {LogSourceArg source = LogSourceArg.app}) =>
      adjustCount(habitId, date, seconds, source: source);

  /// Marks a slip for a quit habit. Removing the row un-marks it.
  Future<void> setSlip(int habitId, DateTime date, bool slipped) =>
      setYesNoDone(habitId, date, slipped);

  /// Marks [habitId] fully complete for [date] regardless of type — used by
  /// the notification "Done" action and by manual backfill. Quit habits have
  /// no "done" action since silence is already their success state.
  Future<void> markFullyDone(int habitId, DateTime date, {LogSourceArg source = LogSourceArg.app}) async {
    final habit = await getHabit(habitId);
    if (habit == null) return;
    switch (HabitType.values[habit.type]) {
      case HabitType.yesNo:
        await setYesNoDone(habitId, date, true, source: source);
      case HabitType.count:
      case HabitType.timed:
        final existing = await logForHabitAndDate(habitId, date);
        final target = habit.targetValue ?? 1;
        final remaining = target - (existing?.value ?? 0);
        if (remaining > 0) await adjustCount(habitId, date, remaining, source: source);
      case HabitType.quit:
        break;
    }
  }

  /// Clears whatever log exists for [habitId] on [date], regardless of type.
  Future<void> unmarkDone(int habitId, DateTime date) async {
    final existing = await logForHabitAndDate(habitId, date);
    if (existing != null) {
      await (delete(habitLogs)..where((l) => l.id.equals(existing.id))).go();
    }
  }

  /// Marks or clears [date] as a deliberate rest day for [habitId] — a
  /// skipped day is excluded from streaks and completion rate entirely,
  /// distinct from an ordinary miss. Only meaningful for yesNo/count/timed
  /// habits; quit habits have no "day" to skip.
  Future<void> setSkipped(int habitId, DateTime date, bool skip) async {
    final day = dateOnly(date);
    final existing = await logForHabitAndDate(habitId, date);
    if (skip) {
      if (existing == null) {
        await into(habitLogs).insert(HabitLogsCompanion.insert(
          habitId: habitId,
          localDate: day,
          value: const Value(0),
          completedAt: Value(DateTime.now()),
          skipped: const Value(true),
        ));
      } else {
        await (update(habitLogs)..where((l) => l.id.equals(existing.id)))
            .write(const HabitLogsCompanion(skipped: Value(true)));
      }
    } else if (existing != null && existing.skipped) {
      await (delete(habitLogs)..where((l) => l.id.equals(existing.id))).go();
    }
  }

  // ---------------------------------------------------------------------
  // Nudge state
  // ---------------------------------------------------------------------

  Future<NudgeState?> nudgeStateFor(int habitId) =>
      (select(nudgeStates)..where((n) => n.habitId.equals(habitId))).getSingleOrNull();

  Future<void> upsertNudgeState(NudgeStatesCompanion state) =>
      into(nudgeStates).insertOnConflictUpdate(state);

  // ---------------------------------------------------------------------
  // Settings
  // ---------------------------------------------------------------------

  Future<String?> getSetting(String key) async {
    final row = await (select(settings)..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Stream<String?> watchSetting(String key) => (select(settings)..where((s) => s.key.equals(key)))
      .watchSingleOrNull()
      .map((row) => row?.value);

  Future<void> setSetting(String key, String value) => into(settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));
}

/// Mirrors LogSource without importing the enum file into generated code.
enum LogSourceArg { app, notification, widget }

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'cadence.sqlite'));
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;
    return NativeDatabase.createInBackground(file);
  });
}
