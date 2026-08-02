import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../data/db/database.dart';
import '../../data/models/habit_type.dart';
import '../../providers/database_provider.dart';

const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

/// Add or edit a habit. Pass [existing] to edit; omit to create new.
class HabitEditorScreen extends ConsumerStatefulWidget {
  const HabitEditorScreen({super.key, this.existing});

  final Habit? existing;

  @override
  ConsumerState<HabitEditorScreen> createState() => _HabitEditorScreenState();
}

class _HabitEditorScreenState extends ConsumerState<HabitEditorScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _targetController;
  late final TextEditingController _unitController;
  late HabitType _type;
  late int _scheduleMask;
  late ReminderMode _reminderMode;
  late int _colour;
  TimeOfDay _fixedTime = const TimeOfDay(hour: 9, minute: 0);
  int _intervalMinutes = 120;
  TimeOfDay _intervalStart = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _intervalEnd = const TimeOfDay(hour: 21, minute: 0);

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final h = widget.existing;
    _nameController = TextEditingController(text: h?.name ?? '');
    _type = h != null ? HabitType.values[h.type] : HabitType.yesNo;
    _targetController = TextEditingController(
      text: h?.targetValue != null
          ? (_type == HabitType.timed ? ((h!.targetValue!) ~/ 60).toString() : h!.targetValue.toString())
          : '',
    );
    _unitController = TextEditingController(text: h?.targetUnit ?? '');
    _scheduleMask = h?.scheduleMask ?? 127;
    _reminderMode = h != null ? ReminderMode.values[h.reminderMode] : ReminderMode.adaptive;
    _colour = h?.colour ?? AppColors.habitPalette[0].toARGB32();
    if (h?.fallbackTimeMinutes != null) {
      _fixedTime = TimeOfDay(hour: h!.fallbackTimeMinutes! ~/ 60, minute: h.fallbackTimeMinutes! % 60);
    }
    if (h?.intervalMinutes != null) _intervalMinutes = h!.intervalMinutes!;
    if (h?.intervalStartMinutes != null) {
      _intervalStart = TimeOfDay(hour: h!.intervalStartMinutes! ~/ 60, minute: h.intervalStartMinutes! % 60);
    }
    if (h?.intervalEndMinutes != null) {
      _intervalEnd = TimeOfDay(hour: h!.intervalEndMinutes! ~/ 60, minute: h.intervalEndMinutes! % 60);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  bool get _needsTarget => _type == HabitType.count || _type == HabitType.timed;

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    int? targetValue;
    if (_needsTarget) {
      final raw = int.tryParse(_targetController.text.trim()) ?? 0;
      targetValue = _type == HabitType.timed ? raw * 60 : raw;
      if (targetValue <= 0) targetValue = _type == HabitType.timed ? 600 : 1;
    }

    final db = ref.read(databaseProvider);
    final fallbackMinutes = _fixedTime.hour * 60 + _fixedTime.minute;
    final isInterval = _reminderMode == ReminderMode.interval;
    final intervalStartMinutes = isInterval ? _intervalStart.hour * 60 + _intervalStart.minute : null;
    final intervalEndMinutes = isInterval ? _intervalEnd.hour * 60 + _intervalEnd.minute : null;

    if (_isEditing) {
      await db.updateHabit(HabitsCompanion(
        id: Value(widget.existing!.id),
        name: Value(name),
        type: Value(_type.index),
        targetValue: Value(targetValue),
        targetUnit: Value(_needsTarget && _type == HabitType.count ? _unitController.text.trim() : null),
        colour: Value(_colour),
        scheduleMask: Value(_scheduleMask),
        reminderMode: Value(_reminderMode.index),
        fallbackTimeMinutes: Value(fallbackMinutes),
        intervalMinutes: Value(isInterval ? _intervalMinutes : null),
        intervalStartMinutes: Value(intervalStartMinutes),
        intervalEndMinutes: Value(intervalEndMinutes),
      ));
    } else {
      await db.insertHabit(HabitsCompanion.insert(
        name: name,
        type: _type.index,
        targetValue: Value(targetValue),
        targetUnit: Value(_needsTarget && _type == HabitType.count ? _unitController.text.trim() : null),
        colour: _colour,
        scheduleMask: Value(_scheduleMask),
        reminderMode: Value(_reminderMode.index),
        fallbackTimeMinutes: Value(fallbackMinutes),
        intervalMinutes: Value(isInterval ? _intervalMinutes : null),
        intervalStartMinutes: Value(intervalStartMinutes),
        intervalEndMinutes: Value(intervalEndMinutes),
      ));
    }

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _archive() async {
    final db = ref.read(databaseProvider);
    await db.archiveHabit(widget.existing!.id);
    if (mounted) {
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsScope.of(context);
    final text = AppText(colors);

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: text.body.copyWith(color: colors.muted)),
        ),
        leadingWidth: 90,
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('Save', style: text.body.copyWith(color: colors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xxl),
        children: [
          Text(_isEditing ? 'Edit habit' : 'New habit', style: text.h1),
          const SizedBox(height: AppSpacing.xl),

          _FieldLabel('Name', text: text),
          TextField(controller: _nameController, style: text.body, decoration: const InputDecoration(hintText: 'e.g. Evening stretch')),
          const SizedBox(height: AppSpacing.lg),

          _FieldLabel('Type', text: text),
          _TypeSegment(
            value: _type,
            onChanged: (t) => setState(() {
              _type = t;
              // Interval reminders only make sense for count/timed habits.
              if (_reminderMode == ReminderMode.interval && t != HabitType.count && t != HabitType.timed) {
                _reminderMode = ReminderMode.adaptive;
              }
            }),
            colors: colors,
            text: text,
          ),
          const SizedBox(height: AppSpacing.lg),

          if (_needsTarget) ...[
            _FieldLabel(_type == HabitType.timed ? 'Daily target (minutes)' : 'Daily target', text: text),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _targetController,
                    keyboardType: TextInputType.number,
                    style: text.body,
                    decoration: const InputDecoration(hintText: '20'),
                  ),
                ),
                if (_type == HabitType.count) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _unitController,
                      style: text.body,
                      decoration: const InputDecoration(hintText: 'unit, e.g. pages'),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          _FieldLabel('Repeat on', text: text),
          _DayPicker(mask: _scheduleMask, onChanged: (m) => setState(() => _scheduleMask = m), colors: colors, text: text),
          const SizedBox(height: AppSpacing.lg),

          _FieldLabel('Reminder', text: text),
          _ReminderSegment(
            value: _reminderMode,
            allowInterval: _needsTarget,
            onChanged: (m) => setState(() => _reminderMode = m),
            colors: colors,
            text: text,
          ),
          const SizedBox(height: AppSpacing.md),

          if (_reminderMode == ReminderMode.adaptive)
            _InfoCard(
              colors: colors,
              text: text,
              label: 'WHILE IT LEARNS',
              body:
                  'Nudging at ${_fixedTime.format(context)} until there\'s a week of history — then it adjusts to when you actually do this.',
            )
          else if (_reminderMode == ReminderMode.fixed)
            _TimePickerRow(time: _fixedTime, onChanged: (t) => setState(() => _fixedTime = t), colors: colors, text: text)
          else if (_reminderMode == ReminderMode.interval)
            _IntervalPicker(
              intervalMinutes: _intervalMinutes,
              start: _intervalStart,
              end: _intervalEnd,
              onIntervalChanged: (m) => setState(() => _intervalMinutes = m),
              onStartChanged: (t) => setState(() => _intervalStart = t),
              onEndChanged: (t) => setState(() => _intervalEnd = t),
              colors: colors,
              text: text,
            ),

          const SizedBox(height: AppSpacing.lg),
          _FieldLabel('Colour', text: text),
          _ColourPicker(value: _colour, onChanged: (c) => setState(() => _colour = c)),

          if (_isEditing) ...[
            const SizedBox(height: AppSpacing.xxl),
            OutlinedButton(
              onPressed: _archive,
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.danger,
                side: BorderSide(color: colors.danger.withValues(alpha: 0.4)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: const Text('Archive this habit'),
            ),
          ],
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label, {required this.text});
  final String label;
  final AppText text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(label.toUpperCase(), style: text.kicker),
      );
}

class _TypeSegment extends StatelessWidget {
  const _TypeSegment({required this.value, required this.onChanged, required this.colors, required this.text});
  final HabitType value;
  final ValueChanged<HabitType> onChanged;
  final AppColors colors;
  final AppText text;

  static const _labels = {
    HabitType.yesNo: 'Yes/no',
    HabitType.count: 'Count',
    HabitType.timed: 'Timed',
    HabitType.quit: 'Quit',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: colors.line), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: HabitType.values.map((t) {
          final selected = t == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(t),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? colors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Text(_labels[t]!, style: text.mono.copyWith(color: selected ? colors.onAccent : colors.inkSoft)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ReminderSegment extends StatelessWidget {
  const _ReminderSegment({
    required this.value,
    required this.allowInterval,
    required this.onChanged,
    required this.colors,
    required this.text,
  });
  final ReminderMode value;
  final bool allowInterval;
  final ValueChanged<ReminderMode> onChanged;
  final AppColors colors;
  final AppText text;

  static const _labels = {
    ReminderMode.adaptive: 'Adaptive',
    ReminderMode.fixed: 'Fixed time',
    ReminderMode.interval: 'Interval',
    ReminderMode.off: 'Off',
  };

  @override
  Widget build(BuildContext context) {
    final modes = [
      ReminderMode.adaptive,
      ReminderMode.fixed,
      if (allowInterval) ReminderMode.interval,
      ReminderMode.off,
    ];
    return Container(
      decoration: BoxDecoration(border: Border.all(color: colors.line), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: modes.map((m) {
          final selected = m == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(m),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? colors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Text(_labels[m]!, style: text.mono.copyWith(color: selected ? colors.onAccent : colors.inkSoft)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DayPicker extends StatelessWidget {
  const _DayPicker({required this.mask, required this.onChanged, required this.colors, required this.text});
  final int mask;
  final ValueChanged<int> onChanged;
  final AppColors colors;
  final AppText text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (i) {
        final on = (mask >> i) & 1 == 1;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: () => onChanged(mask ^ (1 << i)),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: on ? colors.accent : Colors.transparent,
                    border: Border.all(color: on ? colors.accent : colors.line),
                  ),
                  alignment: Alignment.center,
                  child: Text(_weekdayLabels[i], style: text.mono.copyWith(color: on ? colors.onAccent : colors.muted)),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _TimePickerRow extends StatelessWidget {
  const _TimePickerRow({
    required this.time,
    required this.onChanged,
    required this.colors,
    required this.text,
    this.label = 'Reminder time',
  });
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onChanged;
  final AppColors colors;
  final AppText text;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: time);
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(color: colors.ground, borderRadius: BorderRadius.circular(12), border: Border.all(color: colors.line)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: text.body),
            Text(time.format(context), style: text.body.copyWith(fontWeight: FontWeight.w600, color: colors.accent)),
          ],
        ),
      ),
    );
  }
}

class _IntervalPicker extends StatelessWidget {
  const _IntervalPicker({
    required this.intervalMinutes,
    required this.start,
    required this.end,
    required this.onIntervalChanged,
    required this.onStartChanged,
    required this.onEndChanged,
    required this.colors,
    required this.text,
  });

  final int intervalMinutes;
  final TimeOfDay start;
  final TimeOfDay end;
  final ValueChanged<int> onIntervalChanged;
  final ValueChanged<TimeOfDay> onStartChanged;
  final ValueChanged<TimeOfDay> onEndChanged;
  final AppColors colors;
  final AppText text;

  static const _choices = [30, 60, 90, 120, 180, 240, 360];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(color: colors.ground, borderRadius: BorderRadius.circular(12), border: Border.all(color: colors.line)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Every', style: text.body),
              DropdownButton<int>(
                value: intervalMinutes,
                underline: const SizedBox.shrink(),
                items: _choices
                    .map((m) => DropdownMenuItem(value: m, child: Text(_formatInterval(m), style: text.body)))
                    .toList(),
                onChanged: (m) {
                  if (m != null) onIntervalChanged(m);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _TimePickerRow(time: start, onChanged: onStartChanged, colors: colors, text: text, label: 'From'),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _TimePickerRow(time: end, onChanged: onEndChanged, colors: colors, text: text, label: 'Until'),
            ),
          ],
        ),
      ],
    );
  }

  String _formatInterval(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes / 60;
    return hours == hours.roundToDouble() ? '${hours.round()}h' : '${hours}h';
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.colors, required this.text, required this.label, required this.body});
  final AppColors colors;
  final AppText text;
  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.signalDim,
        border: Border.all(color: colors.signal.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text.kicker.copyWith(color: colors.signal)),
          const SizedBox(height: 6),
          Text(body, style: text.bodySoft),
        ],
      ),
    );
  }
}

class _ColourPicker extends StatelessWidget {
  const _ColourPicker({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsScope.of(context);
    return Row(
      children: AppColors.habitPalette.map((c) {
        final argb = c.toARGB32();
        final selected = argb == value;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => onChanged(argb),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c,
                border: selected ? Border.all(color: colors.ink, width: 2.5) : null,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
