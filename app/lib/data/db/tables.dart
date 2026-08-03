import 'package:drift/drift.dart';

/// One row per habit definition. Never deleted — archived instead, so a
/// habit resumed months later keeps its history.
class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();

  /// Index into [HabitType]: 0 yesNo, 1 count, 2 timed, 3 quit.
  IntColumn get type => integer()();

  /// Count target (glasses, pages) or timed target in seconds. Null for
  /// yesNo and quit.
  IntColumn get targetValue => integer().nullable()();

  /// Unit label for count habits, e.g. "glasses", "pages".
  TextColumn get targetUnit => text().nullable()();

  /// ARGB colour, one of AppColors.habitPalette.
  IntColumn get colour => integer()();

  /// 7-bit mask, bit 0 = Monday .. bit 6 = Sunday.
  IntColumn get scheduleMask => integer().withDefault(const Constant(127))();

  /// Index into [ReminderMode].
  IntColumn get reminderMode => integer().withDefault(const Constant(0))();

  /// Fallback / manually-set reminder time, minutes since midnight local time.
  IntColumn get fallbackTimeMinutes => integer().nullable()();

  /// Only set when reminderMode is [ReminderMode.interval]: how often to
  /// nudge (e.g. 120 for every 2 hours) and the window to do it in, all in
  /// minutes since midnight local time.
  IntColumn get intervalMinutes => integer().nullable()();
  IntColumn get intervalStartMinutes => integer().nullable()();
  IntColumn get intervalEndMinutes => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Set while a timed habit's timer is running. Elapsed time is always
  /// computed as `now - runningTimerStartedAt`, never counted by ticks, so
  /// the timer survives the screen locking, the app backgrounding, or the
  /// sheet being closed — nothing needs to keep running in the foreground
  /// for the elapsed time to stay correct.
  DateTimeColumn get runningTimerStartedAt => dateTime().nullable()();
}

/// One row per habit per day it has activity. For yesNo/count/timed habits,
/// a row's existence (with sufficient value) means done. For quit habits, a
/// row's existence means a *slip* — silence is the success case.
class HabitLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id)();

  /// Local calendar date at midnight, used as the identity for "which day".
  DateTimeColumn get localDate => dateTime()();

  /// Yes/no: 1. Count: running total for the day. Timed: seconds logged.
  /// Quit: 1 marks a slip.
  IntColumn get value => integer().withDefault(const Constant(1))();

  DateTimeColumn get completedAt => dateTime().withDefault(currentDateAndTime)();

  /// Index into [LogSource].
  IntColumn get source => integer().withDefault(const Constant(0))();

  TextColumn get note => text().nullable()();

  /// A deliberate rest day — excluded from streaks and completion rate,
  /// distinct from an ordinary miss. Swiped on from the Today screen.
  BoolColumn get skipped => boolean().withDefault(const Constant(false))();
}

/// The adaptive engine's cached output per habit. Rewritten nightly.
class NudgeStates extends Table {
  IntColumn get habitId => integer().references(Habits, #id)();
  IntColumn get learnedWeekdayMinutes => integer().nullable()();
  IntColumn get learnedWeekendMinutes => integer().nullable()();
  IntColumn get sampleCount => integer().withDefault(const Constant(0))();
  IntColumn get spreadMinutes => integer().nullable()();
  BoolColumn get confident => boolean().withDefault(const Constant(false))();
  DateTimeColumn get nextFireAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {habitId};
}

/// Flat key/value store for app-wide settings.
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
