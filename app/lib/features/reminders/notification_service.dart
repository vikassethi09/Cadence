import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'notification_dispatch.dart';

/// Thin wrapper around flutter_local_notifications. Every habit reminder is
/// scheduled as a weekly-recurring notification per active weekday, so it
/// survives app restarts without needing the notification to be "renewed"
/// each time — only the *time* changes when the adaptive engine relearns it.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _channelId = 'cadence_reminders';
  static const _streakChannelId = 'cadence_streak';
  static const _timerChannelId = 'cadence_timer';

  Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (response) => handleNotificationResponse(response),
      onDidReceiveBackgroundNotificationResponse: notificationBackgroundEntryPoint,
    );

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(const AndroidNotificationChannel(
      _channelId,
      'Habit reminders',
      description: 'Nudges for your scheduled habits',
      importance: Importance.high,
    ));
    await androidImpl?.createNotificationChannel(const AndroidNotificationChannel(
      _streakChannelId,
      'Streak at risk',
      description: 'One evening nudge when a streak is still undone',
      importance: Importance.high,
    ));
    await androidImpl?.createNotificationChannel(const AndroidNotificationChannel(
      _timerChannelId,
      'Active timer',
      description: 'Shows while a timed habit is running, so it stays visible on the lock screen',
      importance: Importance.low,
    ));

    _initialized = true;
  }

  Future<bool> requestPermission() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final iosImpl = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    final androidGranted = await androidImpl?.requestNotificationsPermission();
    final iosGranted = await iosImpl?.requestPermissions(alert: true, badge: true, sound: true);
    return (androidGranted ?? true) && (iosGranted ?? true);
  }

  /// Id space per habit: habitId*10000 + weekday(0-6) for single-time
  /// reminders, habitId*10000 + 100 + weekday*10 + slot(0-9) for interval
  /// reminders (range 100-179). Snooze and timer ids live at fixed bases
  /// far above any realistic habitId*10000 range (habitId would need to
  /// reach ~100,000 to collide), so growth in habit count over the app's
  /// lifetime can't cross into their space.
  static const _maxIntervalSlotsPerDay = 10;
  int _idFor(int habitId, int weekdayIndex) => habitId * 10000 + weekdayIndex;
  int _intervalIdFor(int habitId, int weekdayIndex, int slotIndex) =>
      habitId * 10000 + 100 + weekdayIndex * 10 + slotIndex;

  /// Cancels any existing reminders for [habitId] then schedules a fresh
  /// weekly notification for each active weekday in [scheduleMask] at
  /// [minutesOfDay].
  Future<void> scheduleHabitReminders({
    required int habitId,
    required String habitName,
    required int scheduleMask,
    required int minutesOfDay,
    required int streakLength,
  }) async {
    await cancelForHabit(habitId);

    for (var i = 0; i < 7; i++) {
      if ((scheduleMask >> i) & 1 == 0) continue;
      final dartWeekday = i + 1; // Monday=1..Sunday=7
      final when = _nextInstanceOf(dartWeekday, minutesOfDay);
      await _plugin.zonedSchedule(
        id: _idFor(habitId, i),
        title: habitName,
        body: streakLength > 0
            ? 'You\'ve done this $streakLength day${streakLength == 1 ? '' : 's'} running.'
            : 'Time to keep it going.',
        scheduledDate: when,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            'Habit reminders',
            category: AndroidNotificationCategory.reminder,
            visibility: NotificationVisibility.public,
            actions: _actions,
          ),
          iOS: DarwinNotificationDetails(categoryIdentifier: 'habit_reminder'),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: 'habit:$habitId',
      );
    }
  }

  /// Schedules a nudge every [intervalMinutes] between [startMinutes] and
  /// [endMinutes] (inclusive) on each active weekday — e.g. "every 2 hours,
  /// 9am to 9pm" for a water habit. Capped at [_maxIntervalSlotsPerDay] so a
  /// too-short interval can't flood the notification tray.
  Future<void> scheduleIntervalHabitReminders({
    required int habitId,
    required String habitName,
    required int scheduleMask,
    required int intervalMinutes,
    required int startMinutes,
    required int endMinutes,
  }) async {
    await cancelForHabit(habitId);
    if (intervalMinutes <= 0 || endMinutes <= startMinutes) return;

    final slotTimes = <int>[];
    for (var t = startMinutes; t <= endMinutes && slotTimes.length < _maxIntervalSlotsPerDay; t += intervalMinutes) {
      slotTimes.add(t);
    }

    for (var i = 0; i < 7; i++) {
      if ((scheduleMask >> i) & 1 == 0) continue;
      final dartWeekday = i + 1;
      for (var slot = 0; slot < slotTimes.length; slot++) {
        final when = _nextInstanceOf(dartWeekday, slotTimes[slot]);
        await _plugin.zonedSchedule(
          id: _intervalIdFor(habitId, i, slot),
          title: habitName,
          body: 'Time for a top-up.',
          scheduledDate: when,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              'Habit reminders',
              category: AndroidNotificationCategory.reminder,
              visibility: NotificationVisibility.public,
              actions: _actions,
            ),
            iOS: DarwinNotificationDetails(categoryIdentifier: 'habit_reminder'),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: 'habit:$habitId',
        );
      }
    }
  }

  /// "Done", "Snooze" and "Skip" all resolve entirely in the background —
  /// tapping one should never bring the app to the foreground.
  static const _actions = [
    AndroidNotificationAction('done', 'Done', showsUserInterface: false),
    AndroidNotificationAction('snooze', 'Snooze 15m', showsUserInterface: false),
    AndroidNotificationAction('skip', 'Skip today', showsUserInterface: false),
  ];

  /// One-off notification 15 minutes out, fired by the "Snooze" action.
  Future<void> snoozeHabit(int habitId, String habitName) async {
    final when = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 15));
    await _plugin.zonedSchedule(
      id: _snoozeIdFor(habitId),
      title: habitName,
      body: 'Snoozed — still there when you\'re ready.',
      scheduledDate: when,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Habit reminders',
          category: AndroidNotificationCategory.reminder,
          visibility: NotificationVisibility.public,
          actions: _actions,
        ),
        iOS: DarwinNotificationDetails(categoryIdentifier: 'habit_reminder'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'habit:$habitId',
    );
  }

  int _snoozeIdFor(int habitId) => 1000000000 + habitId;
  int _timerIdFor(int habitId) => 1100000000 + habitId;

  /// Shows an ongoing, OS-rendered stopwatch notification for a running
  /// timed habit. The ticking digits are drawn and updated by Android
  /// itself from [startedAt] — the app doesn't repost this every second, so
  /// it stays correct through the screen locking, Doze, or the app process
  /// being killed outright. Only a real Pause (in-app or from the
  /// notification's action) removes it.
  Future<void> showRunningTimerNotification({
    required int habitId,
    required String habitName,
    required DateTime startedAt,
  }) async {
    await _plugin.show(
      id: _timerIdFor(habitId),
      title: habitName,
      body: 'Timer running',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _timerChannelId,
          'Active timer',
          category: AndroidNotificationCategory.stopwatch,
          visibility: NotificationVisibility.public,
          ongoing: true,
          autoCancel: false,
          usesChronometer: true,
          when: startedAt.millisecondsSinceEpoch,
          actions: const [AndroidNotificationAction('pause_timer', 'Pause', showsUserInterface: false)],
        ),
      ),
      payload: 'timer:$habitId',
    );
  }

  Future<void> cancelRunningTimerNotification(int habitId) => _plugin.cancel(id: _timerIdFor(habitId));

  Future<void> cancelForHabit(int habitId) async {
    for (var i = 0; i < 7; i++) {
      await _plugin.cancel(id: _idFor(habitId, i));
      for (var slot = 0; slot < _maxIntervalSlotsPerDay; slot++) {
        await _plugin.cancel(id: _intervalIdFor(habitId, i, slot));
      }
    }
    await _plugin.cancel(id: _snoozeIdFor(habitId));
  }

  /// Called once at app startup: if the app was launched by tapping a
  /// notification body (cold start, not an action button), navigate to that
  /// habit once the UI exists.
  Future<void> handleColdStartLaunch() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    final response = details?.notificationResponse;
    if (details?.didNotificationLaunchApp == true && response != null) {
      await handleNotificationResponse(response);
    }
  }

  /// The single once-daily "streak at risk" sweep, id space above 1,000,000
  /// to avoid colliding with per-habit ids.
  Future<void> scheduleStreakSweep({required int minutesOfDay, required String body}) async {
    const id = 999999;
    await _plugin.cancel(id: id);
    if (body.isEmpty) return;
    final when = _nextInstanceAt(minutesOfDay);
    await _plugin.zonedSchedule(
      id: id,
      title: 'Still open today',
      body: body,
      scheduledDate: when,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _streakChannelId,
          'Streak at risk',
          category: AndroidNotificationCategory.reminder,
          visibility: NotificationVisibility.public,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  tz.TZDateTime _nextInstanceAt(int minutesOfDay) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, minutesOfDay ~/ 60, minutesOfDay % 60);
    if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 1));
    return scheduled;
  }

  tz.TZDateTime _nextInstanceOf(int dartWeekday, int minutesOfDay) {
    var scheduled = _nextInstanceAt(minutesOfDay);
    while (scheduled.weekday != dartWeekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
