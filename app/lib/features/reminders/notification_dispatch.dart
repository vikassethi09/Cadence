import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../data/db/database.dart';
import 'notification_nav.dart';
import 'notification_service.dart';

/// Handles a tap on a notification or one of its action buttons. Runs in
/// the main isolate for a foreground/backgrounded-but-alive app, and in a
/// separate headless isolate ([backgroundEntryPoint]) when the app was fully
/// terminated — so it opens its own database connection rather than reaching
/// through Riverpod, which doesn't exist in that isolate.
Future<void> handleNotificationResponse(NotificationResponse response) async {
  final payload = response.payload;
  if (payload == null || !payload.startsWith('habit:')) return;
  final habitId = int.tryParse(payload.substring('habit:'.length));
  if (habitId == null) return;

  final actionId = response.actionId;
  if (actionId == null) {
    // Plain tap on the notification body — open the habit. Only meaningful
    // when called from the main isolate, where a Navigator actually exists.
    NotificationNav.openHabit(habitId);
    return;
  }

  final db = AppDatabase();
  try {
    final habit = await db.getHabit(habitId);
    if (habit == null) return;
    final today = DateTime.now();

    switch (actionId) {
      case 'done':
        await db.markFullyDone(habitId, today, source: LogSourceArg.notification);
      case 'snooze':
        await NotificationService.instance.snoozeHabit(habitId, habit.name);
      case 'skip':
        break; // Dismiss only — no data change, no streak penalty.
    }
  } finally {
    await db.close();
  }
}

/// Entry point for notifications handled while the app process is fully
/// terminated. Must be a top-level or static function.
@pragma('vm:entry-point')
void notificationBackgroundEntryPoint(NotificationResponse response) {
  WidgetsFlutterBinding.ensureInitialized();
  handleNotificationResponse(response);
}
