import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/habit_logic.dart';
import '../../data/db/database.dart';
import '../../providers/database_provider.dart';
import '../../providers/habit_providers.dart';
import '../habit_detail/habit_detail_screen.dart';
import '../habit_detail/widgets/heatmap.dart';

enum _Range { week, month, year }

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  _Range _range = _Range.month;

  int get _days => switch (_range) { _Range.week => 7, _Range.month => 30, _Range.year => 365 };

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsScope.of(context);
    final text = AppText(colors);
    final db = ref.watch(databaseProvider);
    final habitsAsync = ref.watch(activeHabitsProvider);

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: habitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (habits) {
          if (habits.isEmpty) {
            return Center(child: Text('Add a habit to see stats here.', style: text.bodySoft));
          }
          return FutureBuilder<List<List<HabitLog>>>(
            future: Future.wait(habits.map((h) => db.logsForHabit(h.id))),
            builder: (context, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final logsByHabit = <int, List<HabitLog>>{
                for (var i = 0; i < habits.length; i++) habits[i].id: snap.data![i],
              };
              final now = DateTime.now();

              double totalRate = 0;
              int perfectDays = 0;
              final rates = <(Habit, double)>[];
              for (final h in habits) {
                final r = HabitLogic.completionRate(h, logsByHabit[h.id]!, now, days: _days);
                rates.add((h, r));
                totalRate += r;
              }
              totalRate = habits.isEmpty ? 0 : totalRate / habits.length;

              var cursor = now.subtract(Duration(days: _days - 1));
              final todayOnly = DateTime(now.year, now.month, now.day);
              while (!cursor.isAfter(todayOnly)) {
                final scheduled = habits.where((h) => HabitLogic.isScheduledOn(h, cursor)).toList();
                if (scheduled.isNotEmpty &&
                    scheduled.every((h) {
                      HabitLog? log;
                      for (final l in logsByHabit[h.id]!) {
                        if (_sameDay(l.localDate, cursor)) {
                          log = l;
                          break;
                        }
                      }
                      return HabitLogic.isDone(h, log);
                    })) {
                  perfectDays++;
                }
                cursor = cursor.add(const Duration(days: 1));
              }

              rates.sort((a, b) => a.$2.compareTo(b.$2));

              return ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xxl),
                children: [
                  Text('Stats', style: text.h1),
                  const SizedBox(height: AppSpacing.lg),
                  _RangeSegment(value: _range, onChanged: (r) => setState(() => _range = r), colors: colors, text: text),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(label: 'Completion', value: '${(totalRate * 100).round()}%', text: text, colors: colors),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _StatTile(label: 'Perfect days', value: '$perfectDays', text: text, colors: colors),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('BY HABIT', style: text.kicker),
                  const SizedBox(height: AppSpacing.md),
                  ...rates.reversed.map((entry) {
                    final (habit, rate) = entry;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => HabitDetailScreen(habitId: habit.id)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(habit.name, style: text.body),
                                Text('${(rate * 100).round()}%', style: text.sub),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: rate,
                                minHeight: 5,
                                backgroundColor: colors.lineSoft,
                                valueColor: AlwaysStoppedAnimation(Color(habit.colour)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: AppSpacing.xl),
                  if (habits.isNotEmpty) ...[
                    Text('BUSIEST HABIT — LAST 10 WEEKS', style: text.kicker),
                    const SizedBox(height: AppSpacing.sm),
                    HabitHeatmap(habit: habits.first, logs: logsByHabit[habits.first.id]!),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}

class _RangeSegment extends StatelessWidget {
  const _RangeSegment({required this.value, required this.onChanged, required this.colors, required this.text});
  final _Range value;
  final ValueChanged<_Range> onChanged;
  final AppColors colors;
  final AppText text;

  static const _labels = {_Range.week: 'Week', _Range.month: 'Month', _Range.year: 'Year'};

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: colors.line), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: _Range.values.map((r) {
          final selected = r == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(r),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: selected ? colors.accent : Colors.transparent, borderRadius: BorderRadius.circular(9)),
                alignment: Alignment.center,
                child: Text(_labels[r]!, style: text.mono.copyWith(color: selected ? colors.onAccent : colors.inkSoft)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.text, required this.colors});
  final String label;
  final String value;
  final AppText text;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(border: Border.all(color: colors.lineSoft), borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: text.statNumber),
          const SizedBox(height: 2),
          Text(label.toUpperCase(), style: text.kicker),
        ],
      ),
    );
  }
}
