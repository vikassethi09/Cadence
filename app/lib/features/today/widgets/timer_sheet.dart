import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text.dart';
import '../../../data/db/database.dart';

Future<int?> showTimerSheet(BuildContext context, {required Habit habit, required int alreadyLogged}) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _TimerSheet(habit: habit, alreadyLogged: alreadyLogged),
  );
}

class _TimerSheet extends StatefulWidget {
  const _TimerSheet({required this.habit, required this.alreadyLogged});
  final Habit habit;
  final int alreadyLogged;

  @override
  State<_TimerSheet> createState() => _TimerSheetState();
}

class _TimerSheetState extends State<_TimerSheet> {
  Timer? _ticker;
  int _elapsed = 0;
  bool _running = false;

  void _toggle() {
    if (_running) {
      _ticker?.cancel();
      setState(() => _running = false);
    } else {
      setState(() => _running = true);
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _elapsed++));
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
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
    final target = widget.habit.targetValue ?? 0;
    final totalSoFar = widget.alreadyLogged + _elapsed;
    final habitColor = Color(widget.habit.colour);

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
          Text(widget.habit.name, style: text.h2),
          const SizedBox(height: AppSpacing.sm),
          Text('Target ${target ~/ 60} min', style: text.sub),
          const SizedBox(height: AppSpacing.xl),
          Text(_fmt(totalSoFar), style: text.display.copyWith(fontSize: 52, fontFeatures: const [])),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(_elapsed),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: colors.line),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: Text('Save & close', style: text.button.copyWith(color: colors.inkSoft)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton(
                  onPressed: _toggle,
                  style: ElevatedButton.styleFrom(backgroundColor: habitColor),
                  child: Text(_running ? 'Pause' : 'Start', style: text.button.copyWith(color: colors.onAccent)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
