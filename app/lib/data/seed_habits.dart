import '../core/theme/app_colors.dart';
import 'models/habit_type.dart';

/// A row in the onboarding habit picker. [preChecked] habits arrive
/// selected by default, and between them exercise all four habit types.
class SeedHabit {
  const SeedHabit({
    required this.name,
    required this.type,
    this.targetValue,
    this.targetUnit,
    required this.fallbackTimeMinutes,
    required this.colour,
    this.preChecked = false,
    this.reminderMode,
    this.intervalMinutes,
    this.intervalStartMinutes,
    this.intervalEndMinutes,
  });

  final String name;
  final HabitType type;
  final int? targetValue;
  final String? targetUnit;
  final int? fallbackTimeMinutes; // null = no default reminder (quit habits)
  final int colour;
  final bool preChecked;

  /// Overrides the default adaptive/off inference below — used for the
  /// water habit's interval reminder.
  final ReminderMode? reminderMode;
  final int? intervalMinutes;
  final int? intervalStartMinutes;
  final int? intervalEndMinutes;

  String get typeLabel {
    switch (type) {
      case HabitType.yesNo:
        return 'Yes / no';
      case HabitType.count:
        return 'Count · $targetValue${targetUnit != null ? ' $targetUnit' : ''}';
      case HabitType.timed:
        final mins = (targetValue ?? 0) ~/ 60;
        return 'Timed · ${mins}m';
      case HabitType.quit:
        return 'Quit';
    }
  }
}

int _t(int hour, [int minute = 0]) => hour * 60 + minute;

final seedHabits = <SeedHabit>[
  SeedHabit(
    name: 'Morning walk',
    type: HabitType.yesNo,
    fallbackTimeMinutes: _t(7, 30),
    colour: AppColors.habitPalette[0].toARGB32(),
    preChecked: true,
  ),
  SeedHabit(
    name: 'Drink water',
    type: HabitType.count,
    targetValue: 8,
    targetUnit: 'glasses',
    fallbackTimeMinutes: _t(9),
    colour: AppColors.habitPalette[1].toARGB32(),
    preChecked: true,
    reminderMode: ReminderMode.interval,
    intervalMinutes: 120,
    intervalStartMinutes: _t(9),
    intervalEndMinutes: _t(21),
  ),
  SeedHabit(
    name: 'Read',
    type: HabitType.count,
    targetValue: 20,
    targetUnit: 'pages',
    fallbackTimeMinutes: _t(21),
    colour: AppColors.habitPalette[2].toARGB32(),
    preChecked: true,
  ),
  SeedHabit(
    name: 'No smoking',
    type: HabitType.quit,
    fallbackTimeMinutes: null,
    colour: AppColors.habitPalette[4].toARGB32(),
    preChecked: true,
  ),
  SeedHabit(
    name: 'Meditate',
    type: HabitType.timed,
    targetValue: 10 * 60,
    fallbackTimeMinutes: _t(7),
    colour: AppColors.habitPalette[3].toARGB32(),
  ),
  SeedHabit(
    name: 'Evening stretch',
    type: HabitType.timed,
    targetValue: 5 * 60,
    fallbackTimeMinutes: _t(21, 30),
    colour: AppColors.habitPalette[0].toARGB32(),
  ),
  SeedHabit(
    name: 'Study / deep work',
    type: HabitType.timed,
    targetValue: 60 * 60,
    fallbackTimeMinutes: _t(10),
    colour: AppColors.habitPalette[1].toARGB32(),
  ),
  SeedHabit(
    name: 'Journal',
    type: HabitType.yesNo,
    fallbackTimeMinutes: _t(21, 45),
    colour: AppColors.habitPalette[2].toARGB32(),
  ),
  SeedHabit(
    name: 'Sleep by 11pm',
    type: HabitType.yesNo,
    fallbackTimeMinutes: _t(22, 30),
    colour: AppColors.habitPalette[3].toARGB32(),
  ),
  SeedHabit(
    name: 'Take vitamins',
    type: HabitType.yesNo,
    fallbackTimeMinutes: _t(8, 30),
    colour: AppColors.habitPalette[0].toARGB32(),
  ),
  SeedHabit(
    name: 'No sugar',
    type: HabitType.quit,
    fallbackTimeMinutes: null,
    colour: AppColors.habitPalette[4].toARGB32(),
  ),
  SeedHabit(
    name: 'No phone after 10',
    type: HabitType.quit,
    fallbackTimeMinutes: _t(22),
    colour: AppColors.habitPalette[4].toARGB32(),
  ),
];
