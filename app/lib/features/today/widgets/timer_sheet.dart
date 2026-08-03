import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text.dart';
import '../../../data/db/database.dart';

/// Opens the timer sheet for [habit]. The timer itself lives in the
/// database (a start timestamp, not a running clock in memory), so closing
/// this sheet — for any reason, including the screen locking or the app
/// being backgrounded — never loses elapsed time. Only tapping Pause
/// commits progress and stops it.
Future<void> showTimerSheet(BuildContext context, {required AppDatabase db, required Habit habit, required DateTime date}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _TimerSheet(db: db, habit: habit, date: date),
  );
}

class _TimerSheet extends StatefulWidget {
  const _TimerSheet({required this.db, required this.habit, required this.date});
  final AppDatabase db;
  final Habit habit;
  final DateTime date;

  @override
  State<_TimerSheet> createState() => _TimerSheetState();
}

class _TimerSheetState extends State<_TimerSheet> {
  Timer? _uiTicker;
  late Habit _habit;
  int _loggedBeforeThisSession = 0;

  @override
  void initState() {
    super.initState();
    _habit = widget.habit;
    _loadLoggedValue();
    if (_habit.runningTimerStartedAt != null) _startUiTicker();
  }

  Future<void> _loadLoggedValue() async {
    final log = await widget.db.logForHabitAndDate(_habit.id, widget.date);
    if (mounted) setState(() => _loggedBeforeThisSession = log?.value ?? 0);
  }

  void _startUiTicker() {
    _uiTicker?.cancel();
    // Purely cosmetic — repaints the displayed number once a second. The
    // actual elapsed time is always (now - startedAt), so a missed or
    // delayed tick (e.g. right after the screen turns back on) never causes
    // drift; it just catches the display up on the next frame.
    _uiTicker = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  Future<void> _toggle() async {
    if (_habit.runningTimerStartedAt != null) {
      await widget.db.pauseRunningTimer(_habit.id, widget.date);
      _uiTicker?.cancel();
      final refreshed = await widget.db.getHabit(_habit.id);
      final log = await widget.db.logForHabitAndDate(_habit.id, widget.date);
      if (!mounted) return;
      setState(() {
        if (refreshed != null) _habit = refreshed;
        _loggedBeforeThisSession = log?.value ?? 0;
      });
    } else {
      await widget.db.startRunningTimer(_habit.id);
      final refreshed = await widget.db.getHabit(_habit.id);
      if (!mounted) return;
      setState(() {
        if (refreshed != null) _habit = refreshed;
      });
      _startUiTicker();
    }
  }

  @override
  void dispose() {
    _uiTicker?.cancel();
    super.dispose();
  }

  String _fmt(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsScope.of(context);
    final text = AppText(colors);
    final target = _habit.targetValue ?? 0;
    final habitColor = Color(_habit.colour);
    final running = _habit.runningTimerStartedAt != null;
    final liveSeconds = running ? DateTime.now().difference(_habit.runningTimerStartedAt!).inSeconds : 0;
    final totalSoFar = _loggedBeforeThisSession + liveSeconds;

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: AppSpacing.xl,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 36, height: 4, decoration: BoxDecoration(color: colors.line, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: AppSpacing.xl),
          Text(_habit.name, style: text.h2),
          const SizedBox(height: AppSpacing.sm),
          Text('Target ${target ~/ 60} min', style: text.sub),
          const SizedBox(height: AppSpacing.xl),
          Text(_fmt(totalSoFar), style: text.display.copyWith(fontSize: 52, fontFeatures: const [])),
          const SizedBox(height: AppSpacing.sm),
          if (running)
            Text('Running — keeps going if you close this or lock your phone', style: text.sub, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: colors.line),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: Text('Close', style: text.button.copyWith(color: colors.inkSoft)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton(
                  onPressed: _toggle,
                  style: ElevatedButton.styleFrom(backgroundColor: habitColor),
                  child: Text(running ? 'Pause' : 'Start', style: text.button.copyWith(color: colors.onAccent)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
