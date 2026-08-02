import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/habit_logic.dart';
import '../../data/db/database.dart';
import '../../providers/database_provider.dart';
import '../../providers/habit_providers.dart';
import '../../providers/settings_providers.dart';
import '../../data/models/habit_type.dart';
import '../habit_detail/habit_detail_screen.dart';
import '../habit_editor/habit_editor_screen.dart';
import '../updates/update_provider.dart';
import 'widgets/backfill_sheet.dart';
import 'widgets/habit_row.dart';
import 'widgets/progress_ring.dart';
import 'widgets/timer_sheet.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColorsScope.of(context);
    final text = AppText(colors);
    final habitsAsync = ref.watch(activeHabitsProvider);
    final logsAsync = ref.watch(logsForSelectedDateProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final db = ref.watch(databaseProvider);
    final today = DateTime.now();
    final isToday = _isSameDay(selectedDate, today);
    final hintsDismissed = ref.watch(gestureHintsDismissedProvider).valueOrNull ?? true;
    final update = ref.watch(latestUpdateProvider);

    return Scaffold(
      appBar: AppBar(
        title: null,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HabitEditorScreen()),
            ),
          ),
        ],
      ),
      body: habitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Something went wrong: $e')),
        data: (allHabits) {
          final habits = allHabits.where((h) => HabitLogic.isScheduledOn(h, selectedDate)).toList();
          return logsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Something went wrong: $e')),
            data: (logs) {
              final logByHabit = {for (final l in logs) l.habitId: l};
              final doneCount = habits.where((h) => HabitLogic.isDone(h, logByHabit[h.id])).length;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => _showDayPicker(context, ref),
                            child: Text(DateFormat('EEEE, d MMMM').format(selectedDate).toUpperCase(), style: text.kicker),
                          ),
                          const SizedBox(height: 6),
                          Text(isToday ? _greeting() : 'Looking back', style: text.display),
                          const SizedBox(height: AppSpacing.xl),
                          Center(child: ProgressRing(done: doneCount, total: habits.length)),
                        ],
                      ),
                    ),
                  ),
                  if (update != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
                        child: _UpdateBanner(
                          version: update.version,
                          colors: colors,
                          text: text,
                          onOpen: () => launchUrl(Uri.parse(update.url), mode: LaunchMode.externalApplication),
                          onDismiss: () {
                            db.setSetting(SettingsKeys.updateDismissedVersion, update.version);
                            ref.read(latestUpdateProvider.notifier).state = null;
                          },
                        ),
                      ),
                    ),
                  if (habits.isNotEmpty && !hintsDismissed)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
                        child: _GestureHintBanner(
                          colors: colors,
                          text: text,
                          onDismiss: () => db.setSetting(SettingsKeys.gestureHintsDismissed, 'true'),
                        ),
                      ),
                    ),
                  if (habits.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
                        child: Center(
                          child: Text('Nothing scheduled for this day.', style: text.bodySoft),
                        ),
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxl),
                        child: ReorderableListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          buildDefaultDragHandles: false,
                          onReorderItem: (oldIndex, newIndex) async {
                            final reordered = List.of(habits);
                            final moved = reordered.removeAt(oldIndex);
                            reordered.insert(newIndex, moved);
                            await db.reorderHabits(reordered.map((h) => h.id).toList());
                          },
                          children: [
                            for (var i = 0; i < habits.length; i++)
                              Padding(
                                key: ValueKey(habits[i].id),
                                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: Builder(
                                  builder: (context) {
                                    final habit = habits[i];
                                    final log = logByHabit[habit.id];
                                    final canSkip = HabitLogic.typeOf(habit) != HabitType.quit;
                                    final skipped = HabitLogic.isSkipped(log);

                                    return FutureBuilder<List<HabitLog>>(
                                      future: db.logsForHabit(habit.id),
                                      builder: (context, snap) {
                                        final streak = snap.hasData
                                            ? HabitLogic.currentStreak(habit, snap.data!, selectedDate)
                                            : 0;
                                        final row = HabitRow(
                                          habit: habit,
                                          log: log,
                                          streak: streak,
                                          onToggle: () => db.setYesNoDone(
                                            habit.id,
                                            selectedDate,
                                            !HabitLogic.isDone(habit, log),
                                          ),
                                          onIncrement: () => db.adjustCount(habit.id, selectedDate, 1),
                                          onStartTimer: () async {
                                            final added = await showTimerSheet(
                                              context,
                                              habit: habit,
                                              alreadyLogged: log?.value ?? 0,
                                            );
                                            if (added != null && added > 0) {
                                              await db.logTimedSeconds(habit.id, selectedDate, added);
                                            }
                                          },
                                          onOpenDetail: () => Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) => HabitDetailScreen(habitId: habit.id)),
                                          ),
                                          onLongPress: () => showBackfillSheet(context, db: db, habit: habit),
                                          dragHandle: ReorderableDragStartListener(
                                            index: i,
                                            child: Icon(Icons.drag_indicator, color: colors.muted, size: 20),
                                          ),
                                        );

                                        if (!canSkip) return row;

                                        return Dismissible(
                                          key: ValueKey('skip-${habit.id}'),
                                          direction: DismissDirection.endToStart,
                                          background: _SkipBackground(skipped: skipped, colors: colors, text: text),
                                          confirmDismiss: (_) async {
                                            await db.setSkipped(habit.id, selectedDate, !skipped);
                                            return false;
                                          },
                                          child: row,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  static bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  static Future<void> _showDayPicker(BuildContext context, WidgetRef ref) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: ref.read(selectedDateProvider),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = DateTime(picked.year, picked.month, picked.day);
    }
  }
}

/// Shown when an opted-in GitHub release check finds a newer version.
class _UpdateBanner extends StatelessWidget {
  const _UpdateBanner({
    required this.version,
    required this.colors,
    required this.text,
    required this.onOpen,
    required this.onDismiss,
  });
  final String version;
  final AppColors colors;
  final AppText text;
  final VoidCallback onOpen;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.sm, AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.accentDim,
        border: Border.all(color: colors.accent.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('UPDATE AVAILABLE', style: text.kicker.copyWith(color: colors.accent)),
                const SizedBox(height: 6),
                Text('Cadence $version is out on GitHub.', style: text.bodySoft),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onOpen,
                  child: Text('View release', style: text.body.copyWith(color: colors.accent, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: Icon(Icons.close, size: 18, color: colors.accent),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            tooltip: 'Dismiss',
          ),
        ],
      ),
    );
  }
}

/// One-time tip explaining the three row gestures that have no visible
/// affordance otherwise: swipe to skip, long-press to backfill, and the
/// drag handle to reorder. Dismissed permanently once closed.
class _GestureHintBanner extends StatelessWidget {
  const _GestureHintBanner({required this.colors, required this.text, required this.onDismiss});
  final AppColors colors;
  final AppText text;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.sm, AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.signalDim,
        border: Border.all(color: colors.signal.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('A FEW GESTURES', style: text.kicker.copyWith(color: colors.signal)),
                const SizedBox(height: 6),
                Text(
                  'Long-press a habit to fix up past days. Swipe left for a rest day, no streak lost. Drag the handle to reorder.',
                  style: text.bodySoft,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: Icon(Icons.close, size: 18, color: colors.signal),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            tooltip: 'Dismiss',
          ),
        ],
      ),
    );
  }
}

/// Revealed behind a habit row while swiping left — names the action rather
/// than just showing an icon, since "skip" isn't a universally obvious swipe.
class _SkipBackground extends StatelessWidget {
  const _SkipBackground({required this.skipped, required this.colors, required this.text});
  final bool skipped;
  final AppColors colors;
  final AppText text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(color: colors.lineSoft, borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(skipped ? 'Unskip' : 'Skip', style: text.label.copyWith(color: colors.inkSoft)),
          const SizedBox(width: 8),
          Icon(skipped ? Icons.replay : Icons.free_breakfast_outlined, color: colors.inkSoft, size: 20),
        ],
      ),
    );
  }
}
