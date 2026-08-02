import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../data/db/database.dart';
import '../../data/models/habit_type.dart';
import '../../data/seed_habits.dart';
import '../../providers/database_provider.dart';
import '../../providers/settings_providers.dart';
import '../reminders/notification_service.dart';
import '../reminders/reminder_scheduler.dart';
import '../shell/app_shell.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final _pageController = PageController();
  int _page = 0;
  late final Set<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {for (var i = 0; i < seedHabits.length; i++) if (seedHabits[i].preChecked) i};
  }

  void _next() {
    if (_page < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
    }
  }

  Future<void> _finish({required bool addSeeds}) async {
    final db = ref.read(databaseProvider);
    if (addSeeds) {
      for (var i = 0; i < seedHabits.length; i++) {
        if (!_selected.contains(i)) continue;
        final s = seedHabits[i];
        final mode = s.reminderMode ?? (s.fallbackTimeMinutes != null ? ReminderMode.adaptive : ReminderMode.off);
        await db.insertHabit(HabitsCompanion.insert(
          name: s.name,
          type: s.type.index,
          targetValue: Value(s.targetValue),
          targetUnit: Value(s.targetUnit),
          colour: s.colour,
          reminderMode: Value(mode.index),
          fallbackTimeMinutes: Value(s.fallbackTimeMinutes ?? 9 * 60),
          intervalMinutes: Value(s.intervalMinutes),
          intervalStartMinutes: Value(s.intervalStartMinutes),
          intervalEndMinutes: Value(s.intervalEndMinutes),
        ));
      }
    }
    await db.setSetting(SettingsKeys.onboardingDone, 'true');
    await ReminderScheduler(db).rescheduleAll();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AppShell()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (i) => setState(() => _page = i),
          children: [
            _PromiseStep(onNext: _next),
            _PickerStep(
              selected: _selected,
              onToggle: (i) => setState(() {
                _selected.contains(i) ? _selected.remove(i) : _selected.add(i);
              }),
              onNext: _next,
              onSkip: () => _finish(addSeeds: false),
            ),
            _PermissionStep(onFinish: () => _finish(addSeeds: true)),
          ],
        ),
      ),
    );
  }
}

class _PromiseStep extends StatelessWidget {
  const _PromiseStep({required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsScope.of(context);
    final text = AppText(colors);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text('CADENCE', style: text.kicker.copyWith(color: colors.accent)),
          const SizedBox(height: AppSpacing.md),
          Text('Everything stays\non this phone.', style: text.display.copyWith(fontSize: 38)),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No account, no sync, no server. Cadence tracks your habits offline and learns when to remind you — quietly, from your own history.',
            style: text.bodySoft,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: onNext, child: const Text('Get started')),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _PickerStep extends StatelessWidget {
  const _PickerStep({required this.selected, required this.onToggle, required this.onNext, required this.onSkip});
  final Set<int> selected;
  final ValueChanged<int> onToggle;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsScope.of(context);
    final text = AppText(colors);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('STEP 2 OF 3', style: text.kicker),
          const SizedBox(height: 8),
          Text('Pick a few to begin', style: text.h1),
          const SizedBox(height: 6),
          Text('Three or four is plenty. You can add more whenever.', style: text.bodySoft),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: GridView.builder(
              itemCount: seedHabits.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.6,
              ),
              itemBuilder: (context, i) {
                final habit = seedHabits[i];
                final on = selected.contains(i);
                return GestureDetector(
                  onTap: () => onToggle(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: on ? colors.accentDim : colors.ground,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(color: on ? colors.accent : colors.line),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(habit.name, style: text.label.copyWith(color: on ? colors.accent : colors.ink)),
                        const SizedBox(height: 2),
                        Text(habit.typeLabel.toUpperCase(), style: text.kicker),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              child: Text('Continue with ${selected.length}'),
            ),
          ),
          Center(
            child: TextButton(onPressed: onSkip, child: Text('Start empty instead', style: text.sub)),
          ),
        ],
      ),
    );
  }
}

class _PermissionStep extends ConsumerWidget {
  const _PermissionStep({required this.onFinish});
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColorsScope.of(context);
    final text = AppText(colors);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text('STEP 3 OF 3', style: text.kicker),
          const SizedBox(height: 8),
          Text('One quiet nudge\nat the right time', style: text.h1),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Cadence needs permission to send local notifications. It watches when you actually complete each habit and learns to remind you just before — never more than once a day per habit, and it stays fully on-device.',
            style: text.bodySoft,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await NotificationService.instance.init();
                await NotificationService.instance.requestPermission();
                onFinish();
              },
              child: const Text('Allow notifications'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(child: TextButton(onPressed: onFinish, child: Text('Not now', style: text.sub))),
        ],
      ),
    );
  }
}
