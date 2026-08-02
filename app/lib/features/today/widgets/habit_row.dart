import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text.dart';
import '../../../core/utils/habit_logic.dart';
import '../../../data/db/database.dart';
import '../../../data/models/habit_type.dart';

/// A single habit's row on the Today screen. The tap affordance changes
/// with habit type but the row shape stays constant — yes/no taps the
/// circle, count taps +1, timed opens a start sheet, quit shows streak.
class HabitRow extends StatelessWidget {
  const HabitRow({
    super.key,
    required this.habit,
    required this.log,
    required this.streak,
    required this.onToggle,
    required this.onIncrement,
    required this.onStartTimer,
    required this.onOpenDetail,
    required this.onLongPress,
    this.dragHandle,
  });

  final Habit habit;
  final HabitLog? log;
  final int streak;
  final VoidCallback onToggle;
  final VoidCallback onIncrement;
  final VoidCallback onStartTimer;
  final VoidCallback onOpenDetail;
  final VoidCallback onLongPress;

  /// Optional drag handle shown at the trailing edge, e.g. when the row is
  /// inside a [ReorderableListView]. Kept as its own gesture target so it
  /// never competes with the row's tap or long-press.
  final Widget? dragHandle;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsScope.of(context);
    final text = AppText(colors);
    final type = HabitLogic.typeOf(habit);
    final done = HabitLogic.isDone(habit, log);
    final skipped = HabitLogic.isSkipped(log);
    final habitColor = Color(habit.colour);

    return GestureDetector(
      onTap: onOpenDetail,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: skipped ? colors.lineSoft : (done ? colors.accentDim : colors.ground),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: done && !skipped ? Colors.transparent : colors.lineSoft),
        ),
        child: Row(
          children: [
            _LeadingTick(type: type, done: done, habitColor: habitColor, onToggle: onToggle),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.label.copyWith(color: done ? colors.accent : colors.ink),
                  ),
                  const SizedBox(height: 4),
                  _Subtitle(habit: habit, log: log, streak: streak, colors: colors, text: text),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _TrailingAction(
              type: type,
              done: done,
              habit: habit,
              colors: colors,
              text: text,
              onIncrement: onIncrement,
              onStartTimer: onStartTimer,
            ),
            if (dragHandle != null) ...[
              const SizedBox(width: AppSpacing.xs),
              dragHandle!,
            ],
          ],
        ),
      ),
    );
  }
}

class _LeadingTick extends StatelessWidget {
  const _LeadingTick({required this.type, required this.done, required this.habitColor, required this.onToggle});

  final HabitType type;
  final bool done;
  final Color habitColor;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsScope.of(context);
    // Count/timed habits use the trailing action instead; tapping the tick
    // still opens detail via the row's own GestureDetector.
    final tappable = type == HabitType.yesNo || type == HabitType.quit;

    return GestureDetector(
      onTap: tappable ? onToggle : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: done ? habitColor : Colors.transparent,
          border: Border.all(color: done ? habitColor : colors.line, width: 1.6),
        ),
        alignment: Alignment.center,
        child: done
            ? Icon(Icons.check, size: 15, color: colors.card)
            : null,
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({required this.habit, required this.log, required this.streak, required this.colors, required this.text});

  final Habit habit;
  final HabitLog? log;
  final int streak;
  final AppColors colors;
  final AppText text;

  @override
  Widget build(BuildContext context) {
    if (HabitLogic.isSkipped(log)) {
      return Text('Skipped — rest day', style: text.sub.copyWith(fontStyle: FontStyle.italic));
    }
    final type = HabitLogic.typeOf(habit);
    switch (type) {
      case HabitType.yesNo:
        return Text(streak > 0 ? '$streak-day streak' : 'No streak yet', style: text.sub);
      case HabitType.quit:
        return Text(streak > 0 ? '$streak days clean' : 'Starting today', style: text.sub);
      case HabitType.count:
        final target = habit.targetValue ?? 1;
        final value = log?.value ?? 0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _Bar(progress: HabitLogic.progressOf(habit, log), color: Color(habit.colour), colors: colors),
            const SizedBox(height: 3),
            Text('$value of $target ${habit.targetUnit ?? ''}'.trim(), style: text.sub),
          ],
        );
      case HabitType.timed:
        final target = habit.targetValue ?? 1;
        final value = log?.value ?? 0;
        return Text('${_fmt(value)} / ${_fmt(target)}', style: text.sub);
    }
  }

  String _fmt(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.progress, required this.color, required this.colors});
  final double progress;
  final Color color;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 3,
        width: 120,
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: colors.lineSoft,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
    );
  }
}

class _TrailingAction extends StatelessWidget {
  const _TrailingAction({
    required this.type,
    required this.done,
    required this.habit,
    required this.colors,
    required this.text,
    required this.onIncrement,
    required this.onStartTimer,
  });

  final HabitType type;
  final bool done;
  final Habit habit;
  final AppColors colors;
  final AppText text;
  final VoidCallback onIncrement;
  final VoidCallback onStartTimer;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case HabitType.count:
        return _Pill(label: '+1', solid: true, onTap: onIncrement, colors: colors, text: text);
      case HabitType.timed:
        return _Pill(label: done ? 'Done' : 'Start', solid: done, onTap: onStartTimer, colors: colors, text: text);
      case HabitType.yesNo:
      case HabitType.quit:
        return const SizedBox.shrink();
    }
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.solid, required this.onTap, required this.colors, required this.text});

  final String label;
  final bool solid;
  final VoidCallback onTap;
  final AppColors colors;
  final AppText text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: solid ? colors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(color: solid ? colors.accent : colors.line),
        ),
        child: Text(
          label,
          style: text.mono.copyWith(
            color: solid ? colors.onAccent : colors.inkSoft,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
