import 'package:flutter/material.dart';

import '../habit_detail/habit_detail_screen.dart';

/// Lets a notification tap open a specific habit even though notification
/// callbacks fire outside any BuildContext. The root [MaterialApp] registers
/// [navigatorKey]; a tap just pushes through it directly.
class NotificationNav {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static void openHabit(int habitId) {
    final nav = navigatorKey.currentState;
    if (nav == null) return;
    nav.push(MaterialPageRoute(builder: (_) => HabitDetailScreen(habitId: habitId)));
  }
}
