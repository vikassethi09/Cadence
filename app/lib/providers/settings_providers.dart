import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';

const _kOnboardingDone = 'onboarding_done';
const _kThemeMode = 'theme_mode'; // 'system' | 'light' | 'dark'
const _kAdaptiveEnabled = 'adaptive_enabled';
const _kNotificationsEnabled = 'notifications_enabled';
const _kStreakNudgeEnabled = 'streak_nudge_enabled';
const _kQuietStart = 'quiet_start_minutes'; // minutes since midnight
const _kQuietEnd = 'quiet_end_minutes';
const _kWeekStartsMonday = 'week_starts_monday';
const _kGestureHintsDismissed = 'gesture_hints_dismissed';

final onboardingDoneProvider = StreamProvider<bool>((ref) {
  return ref.watch(databaseProvider).watchSetting(_kOnboardingDone).map((v) => v == 'true');
});

final themeModeProvider = StreamProvider<ThemeMode>((ref) {
  return ref.watch(databaseProvider).watchSetting(_kThemeMode).map(_parseThemeMode);
});

ThemeMode _parseThemeMode(String? v) {
  switch (v) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

final adaptiveEnabledProvider = StreamProvider<bool>((ref) {
  return ref.watch(databaseProvider).watchSetting(_kAdaptiveEnabled).map((v) => v != 'false');
});

final notificationsEnabledProvider = StreamProvider<bool>((ref) {
  return ref.watch(databaseProvider).watchSetting(_kNotificationsEnabled).map((v) => v != 'false');
});

final streakNudgeEnabledProvider = StreamProvider<bool>((ref) {
  return ref.watch(databaseProvider).watchSetting(_kStreakNudgeEnabled).map((v) => v != 'false');
});

/// Quiet hours as (startMinutes, endMinutes), default 10:30pm-7:00am.
final quietHoursProvider = StreamProvider<(int, int)>((ref) async* {
  final db = ref.watch(databaseProvider);
  final start = await db.getSetting(_kQuietStart);
  final end = await db.getSetting(_kQuietEnd);
  yield (int.tryParse(start ?? '') ?? (22 * 60 + 30), int.tryParse(end ?? '') ?? (7 * 60));
});

final weekStartsMondayProvider = StreamProvider<bool>((ref) {
  return ref.watch(databaseProvider).watchSetting(_kWeekStartsMonday).map((v) => v != 'false');
});

/// True once the user has dismissed the one-time Today-screen gesture hint
/// (swipe to skip, long-press to backfill, drag to reorder).
final gestureHintsDismissedProvider = StreamProvider<bool>((ref) {
  return ref.watch(databaseProvider).watchSetting(_kGestureHintsDismissed).map((v) => v == 'true');
});

class SettingsKeys {
  static const onboardingDone = _kOnboardingDone;
  static const themeMode = _kThemeMode;
  static const adaptiveEnabled = _kAdaptiveEnabled;
  static const notificationsEnabled = _kNotificationsEnabled;
  static const streakNudgeEnabled = _kStreakNudgeEnabled;
  static const quietStart = _kQuietStart;
  static const quietEnd = _kQuietEnd;
  static const weekStartsMonday = _kWeekStartsMonday;
  static const gestureHintsDismissed = _kGestureHintsDismissed;
}
