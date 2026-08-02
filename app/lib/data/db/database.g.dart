// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<int> targetValue = GeneratedColumn<int>(
    'target_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetUnitMeta = const VerificationMeta(
    'targetUnit',
  );
  @override
  late final GeneratedColumn<String> targetUnit = GeneratedColumn<String>(
    'target_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colourMeta = const VerificationMeta('colour');
  @override
  late final GeneratedColumn<int> colour = GeneratedColumn<int>(
    'colour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduleMaskMeta = const VerificationMeta(
    'scheduleMask',
  );
  @override
  late final GeneratedColumn<int> scheduleMask = GeneratedColumn<int>(
    'schedule_mask',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(127),
  );
  static const VerificationMeta _reminderModeMeta = const VerificationMeta(
    'reminderMode',
  );
  @override
  late final GeneratedColumn<int> reminderMode = GeneratedColumn<int>(
    'reminder_mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fallbackTimeMinutesMeta =
      const VerificationMeta('fallbackTimeMinutes');
  @override
  late final GeneratedColumn<int> fallbackTimeMinutes = GeneratedColumn<int>(
    'fallback_time_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intervalMinutesMeta = const VerificationMeta(
    'intervalMinutes',
  );
  @override
  late final GeneratedColumn<int> intervalMinutes = GeneratedColumn<int>(
    'interval_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intervalStartMinutesMeta =
      const VerificationMeta('intervalStartMinutes');
  @override
  late final GeneratedColumn<int> intervalStartMinutes = GeneratedColumn<int>(
    'interval_start_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intervalEndMinutesMeta =
      const VerificationMeta('intervalEndMinutes');
  @override
  late final GeneratedColumn<int> intervalEndMinutes = GeneratedColumn<int>(
    'interval_end_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    targetValue,
    targetUnit,
    colour,
    scheduleMask,
    reminderMode,
    fallbackTimeMinutes,
    intervalMinutes,
    intervalStartMinutes,
    intervalEndMinutes,
    createdAt,
    archivedAt,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Habit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    }
    if (data.containsKey('target_unit')) {
      context.handle(
        _targetUnitMeta,
        targetUnit.isAcceptableOrUnknown(data['target_unit']!, _targetUnitMeta),
      );
    }
    if (data.containsKey('colour')) {
      context.handle(
        _colourMeta,
        colour.isAcceptableOrUnknown(data['colour']!, _colourMeta),
      );
    } else if (isInserting) {
      context.missing(_colourMeta);
    }
    if (data.containsKey('schedule_mask')) {
      context.handle(
        _scheduleMaskMeta,
        scheduleMask.isAcceptableOrUnknown(
          data['schedule_mask']!,
          _scheduleMaskMeta,
        ),
      );
    }
    if (data.containsKey('reminder_mode')) {
      context.handle(
        _reminderModeMeta,
        reminderMode.isAcceptableOrUnknown(
          data['reminder_mode']!,
          _reminderModeMeta,
        ),
      );
    }
    if (data.containsKey('fallback_time_minutes')) {
      context.handle(
        _fallbackTimeMinutesMeta,
        fallbackTimeMinutes.isAcceptableOrUnknown(
          data['fallback_time_minutes']!,
          _fallbackTimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('interval_minutes')) {
      context.handle(
        _intervalMinutesMeta,
        intervalMinutes.isAcceptableOrUnknown(
          data['interval_minutes']!,
          _intervalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('interval_start_minutes')) {
      context.handle(
        _intervalStartMinutesMeta,
        intervalStartMinutes.isAcceptableOrUnknown(
          data['interval_start_minutes']!,
          _intervalStartMinutesMeta,
        ),
      );
    }
    if (data.containsKey('interval_end_minutes')) {
      context.handle(
        _intervalEndMinutesMeta,
        intervalEndMinutes.isAcceptableOrUnknown(
          data['interval_end_minutes']!,
          _intervalEndMinutesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_value'],
      ),
      targetUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_unit'],
      ),
      colour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}colour'],
      )!,
      scheduleMask: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schedule_mask'],
      )!,
      reminderMode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_mode'],
      )!,
      fallbackTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fallback_time_minutes'],
      ),
      intervalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_minutes'],
      ),
      intervalStartMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_start_minutes'],
      ),
      intervalEndMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_end_minutes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final int id;
  final String name;

  /// Index into [HabitType]: 0 yesNo, 1 count, 2 timed, 3 quit.
  final int type;

  /// Count target (glasses, pages) or timed target in seconds. Null for
  /// yesNo and quit.
  final int? targetValue;

  /// Unit label for count habits, e.g. "glasses", "pages".
  final String? targetUnit;

  /// ARGB colour, one of AppColors.habitPalette.
  final int colour;

  /// 7-bit mask, bit 0 = Monday .. bit 6 = Sunday.
  final int scheduleMask;

  /// Index into [ReminderMode].
  final int reminderMode;

  /// Fallback / manually-set reminder time, minutes since midnight local time.
  final int? fallbackTimeMinutes;

  /// Only set when reminderMode is [ReminderMode.interval]: how often to
  /// nudge (e.g. 120 for every 2 hours) and the window to do it in, all in
  /// minutes since midnight local time.
  final int? intervalMinutes;
  final int? intervalStartMinutes;
  final int? intervalEndMinutes;
  final DateTime createdAt;
  final DateTime? archivedAt;
  final int sortOrder;
  const Habit({
    required this.id,
    required this.name,
    required this.type,
    this.targetValue,
    this.targetUnit,
    required this.colour,
    required this.scheduleMask,
    required this.reminderMode,
    this.fallbackTimeMinutes,
    this.intervalMinutes,
    this.intervalStartMinutes,
    this.intervalEndMinutes,
    required this.createdAt,
    this.archivedAt,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<int>(type);
    if (!nullToAbsent || targetValue != null) {
      map['target_value'] = Variable<int>(targetValue);
    }
    if (!nullToAbsent || targetUnit != null) {
      map['target_unit'] = Variable<String>(targetUnit);
    }
    map['colour'] = Variable<int>(colour);
    map['schedule_mask'] = Variable<int>(scheduleMask);
    map['reminder_mode'] = Variable<int>(reminderMode);
    if (!nullToAbsent || fallbackTimeMinutes != null) {
      map['fallback_time_minutes'] = Variable<int>(fallbackTimeMinutes);
    }
    if (!nullToAbsent || intervalMinutes != null) {
      map['interval_minutes'] = Variable<int>(intervalMinutes);
    }
    if (!nullToAbsent || intervalStartMinutes != null) {
      map['interval_start_minutes'] = Variable<int>(intervalStartMinutes);
    }
    if (!nullToAbsent || intervalEndMinutes != null) {
      map['interval_end_minutes'] = Variable<int>(intervalEndMinutes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      targetValue: targetValue == null && nullToAbsent
          ? const Value.absent()
          : Value(targetValue),
      targetUnit: targetUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(targetUnit),
      colour: Value(colour),
      scheduleMask: Value(scheduleMask),
      reminderMode: Value(reminderMode),
      fallbackTimeMinutes: fallbackTimeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(fallbackTimeMinutes),
      intervalMinutes: intervalMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalMinutes),
      intervalStartMinutes: intervalStartMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalStartMinutes),
      intervalEndMinutes: intervalEndMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalEndMinutes),
      createdAt: Value(createdAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      sortOrder: Value(sortOrder),
    );
  }

  factory Habit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<int>(json['type']),
      targetValue: serializer.fromJson<int?>(json['targetValue']),
      targetUnit: serializer.fromJson<String?>(json['targetUnit']),
      colour: serializer.fromJson<int>(json['colour']),
      scheduleMask: serializer.fromJson<int>(json['scheduleMask']),
      reminderMode: serializer.fromJson<int>(json['reminderMode']),
      fallbackTimeMinutes: serializer.fromJson<int?>(
        json['fallbackTimeMinutes'],
      ),
      intervalMinutes: serializer.fromJson<int?>(json['intervalMinutes']),
      intervalStartMinutes: serializer.fromJson<int?>(
        json['intervalStartMinutes'],
      ),
      intervalEndMinutes: serializer.fromJson<int?>(json['intervalEndMinutes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>(type),
      'targetValue': serializer.toJson<int?>(targetValue),
      'targetUnit': serializer.toJson<String?>(targetUnit),
      'colour': serializer.toJson<int>(colour),
      'scheduleMask': serializer.toJson<int>(scheduleMask),
      'reminderMode': serializer.toJson<int>(reminderMode),
      'fallbackTimeMinutes': serializer.toJson<int?>(fallbackTimeMinutes),
      'intervalMinutes': serializer.toJson<int?>(intervalMinutes),
      'intervalStartMinutes': serializer.toJson<int?>(intervalStartMinutes),
      'intervalEndMinutes': serializer.toJson<int?>(intervalEndMinutes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Habit copyWith({
    int? id,
    String? name,
    int? type,
    Value<int?> targetValue = const Value.absent(),
    Value<String?> targetUnit = const Value.absent(),
    int? colour,
    int? scheduleMask,
    int? reminderMode,
    Value<int?> fallbackTimeMinutes = const Value.absent(),
    Value<int?> intervalMinutes = const Value.absent(),
    Value<int?> intervalStartMinutes = const Value.absent(),
    Value<int?> intervalEndMinutes = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    int? sortOrder,
  }) => Habit(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    targetValue: targetValue.present ? targetValue.value : this.targetValue,
    targetUnit: targetUnit.present ? targetUnit.value : this.targetUnit,
    colour: colour ?? this.colour,
    scheduleMask: scheduleMask ?? this.scheduleMask,
    reminderMode: reminderMode ?? this.reminderMode,
    fallbackTimeMinutes: fallbackTimeMinutes.present
        ? fallbackTimeMinutes.value
        : this.fallbackTimeMinutes,
    intervalMinutes: intervalMinutes.present
        ? intervalMinutes.value
        : this.intervalMinutes,
    intervalStartMinutes: intervalStartMinutes.present
        ? intervalStartMinutes.value
        : this.intervalStartMinutes,
    intervalEndMinutes: intervalEndMinutes.present
        ? intervalEndMinutes.value
        : this.intervalEndMinutes,
    createdAt: createdAt ?? this.createdAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      targetUnit: data.targetUnit.present
          ? data.targetUnit.value
          : this.targetUnit,
      colour: data.colour.present ? data.colour.value : this.colour,
      scheduleMask: data.scheduleMask.present
          ? data.scheduleMask.value
          : this.scheduleMask,
      reminderMode: data.reminderMode.present
          ? data.reminderMode.value
          : this.reminderMode,
      fallbackTimeMinutes: data.fallbackTimeMinutes.present
          ? data.fallbackTimeMinutes.value
          : this.fallbackTimeMinutes,
      intervalMinutes: data.intervalMinutes.present
          ? data.intervalMinutes.value
          : this.intervalMinutes,
      intervalStartMinutes: data.intervalStartMinutes.present
          ? data.intervalStartMinutes.value
          : this.intervalStartMinutes,
      intervalEndMinutes: data.intervalEndMinutes.present
          ? data.intervalEndMinutes.value
          : this.intervalEndMinutes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('targetUnit: $targetUnit, ')
          ..write('colour: $colour, ')
          ..write('scheduleMask: $scheduleMask, ')
          ..write('reminderMode: $reminderMode, ')
          ..write('fallbackTimeMinutes: $fallbackTimeMinutes, ')
          ..write('intervalMinutes: $intervalMinutes, ')
          ..write('intervalStartMinutes: $intervalStartMinutes, ')
          ..write('intervalEndMinutes: $intervalEndMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    targetValue,
    targetUnit,
    colour,
    scheduleMask,
    reminderMode,
    fallbackTimeMinutes,
    intervalMinutes,
    intervalStartMinutes,
    intervalEndMinutes,
    createdAt,
    archivedAt,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.targetValue == this.targetValue &&
          other.targetUnit == this.targetUnit &&
          other.colour == this.colour &&
          other.scheduleMask == this.scheduleMask &&
          other.reminderMode == this.reminderMode &&
          other.fallbackTimeMinutes == this.fallbackTimeMinutes &&
          other.intervalMinutes == this.intervalMinutes &&
          other.intervalStartMinutes == this.intervalStartMinutes &&
          other.intervalEndMinutes == this.intervalEndMinutes &&
          other.createdAt == this.createdAt &&
          other.archivedAt == this.archivedAt &&
          other.sortOrder == this.sortOrder);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> type;
  final Value<int?> targetValue;
  final Value<String?> targetUnit;
  final Value<int> colour;
  final Value<int> scheduleMask;
  final Value<int> reminderMode;
  final Value<int?> fallbackTimeMinutes;
  final Value<int?> intervalMinutes;
  final Value<int?> intervalStartMinutes;
  final Value<int?> intervalEndMinutes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> archivedAt;
  final Value<int> sortOrder;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.targetUnit = const Value.absent(),
    this.colour = const Value.absent(),
    this.scheduleMask = const Value.absent(),
    this.reminderMode = const Value.absent(),
    this.fallbackTimeMinutes = const Value.absent(),
    this.intervalMinutes = const Value.absent(),
    this.intervalStartMinutes = const Value.absent(),
    this.intervalEndMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  HabitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int type,
    this.targetValue = const Value.absent(),
    this.targetUnit = const Value.absent(),
    required int colour,
    this.scheduleMask = const Value.absent(),
    this.reminderMode = const Value.absent(),
    this.fallbackTimeMinutes = const Value.absent(),
    this.intervalMinutes = const Value.absent(),
    this.intervalStartMinutes = const Value.absent(),
    this.intervalEndMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : name = Value(name),
       type = Value(type),
       colour = Value(colour);
  static Insertable<Habit> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? type,
    Expression<int>? targetValue,
    Expression<String>? targetUnit,
    Expression<int>? colour,
    Expression<int>? scheduleMask,
    Expression<int>? reminderMode,
    Expression<int>? fallbackTimeMinutes,
    Expression<int>? intervalMinutes,
    Expression<int>? intervalStartMinutes,
    Expression<int>? intervalEndMinutes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (targetValue != null) 'target_value': targetValue,
      if (targetUnit != null) 'target_unit': targetUnit,
      if (colour != null) 'colour': colour,
      if (scheduleMask != null) 'schedule_mask': scheduleMask,
      if (reminderMode != null) 'reminder_mode': reminderMode,
      if (fallbackTimeMinutes != null)
        'fallback_time_minutes': fallbackTimeMinutes,
      if (intervalMinutes != null) 'interval_minutes': intervalMinutes,
      if (intervalStartMinutes != null)
        'interval_start_minutes': intervalStartMinutes,
      if (intervalEndMinutes != null)
        'interval_end_minutes': intervalEndMinutes,
      if (createdAt != null) 'created_at': createdAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  HabitsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? type,
    Value<int?>? targetValue,
    Value<String?>? targetUnit,
    Value<int>? colour,
    Value<int>? scheduleMask,
    Value<int>? reminderMode,
    Value<int?>? fallbackTimeMinutes,
    Value<int?>? intervalMinutes,
    Value<int?>? intervalStartMinutes,
    Value<int?>? intervalEndMinutes,
    Value<DateTime>? createdAt,
    Value<DateTime?>? archivedAt,
    Value<int>? sortOrder,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      targetUnit: targetUnit ?? this.targetUnit,
      colour: colour ?? this.colour,
      scheduleMask: scheduleMask ?? this.scheduleMask,
      reminderMode: reminderMode ?? this.reminderMode,
      fallbackTimeMinutes: fallbackTimeMinutes ?? this.fallbackTimeMinutes,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      intervalStartMinutes: intervalStartMinutes ?? this.intervalStartMinutes,
      intervalEndMinutes: intervalEndMinutes ?? this.intervalEndMinutes,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt ?? this.archivedAt,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<int>(targetValue.value);
    }
    if (targetUnit.present) {
      map['target_unit'] = Variable<String>(targetUnit.value);
    }
    if (colour.present) {
      map['colour'] = Variable<int>(colour.value);
    }
    if (scheduleMask.present) {
      map['schedule_mask'] = Variable<int>(scheduleMask.value);
    }
    if (reminderMode.present) {
      map['reminder_mode'] = Variable<int>(reminderMode.value);
    }
    if (fallbackTimeMinutes.present) {
      map['fallback_time_minutes'] = Variable<int>(fallbackTimeMinutes.value);
    }
    if (intervalMinutes.present) {
      map['interval_minutes'] = Variable<int>(intervalMinutes.value);
    }
    if (intervalStartMinutes.present) {
      map['interval_start_minutes'] = Variable<int>(intervalStartMinutes.value);
    }
    if (intervalEndMinutes.present) {
      map['interval_end_minutes'] = Variable<int>(intervalEndMinutes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('targetValue: $targetValue, ')
          ..write('targetUnit: $targetUnit, ')
          ..write('colour: $colour, ')
          ..write('scheduleMask: $scheduleMask, ')
          ..write('reminderMode: $reminderMode, ')
          ..write('fallbackTimeMinutes: $fallbackTimeMinutes, ')
          ..write('intervalMinutes: $intervalMinutes, ')
          ..write('intervalStartMinutes: $intervalStartMinutes, ')
          ..write('intervalEndMinutes: $intervalEndMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $HabitLogsTable extends HabitLogs
    with TableInfo<$HabitLogsTable, HabitLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<int> habitId = GeneratedColumn<int>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id)',
    ),
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<DateTime> localDate = GeneratedColumn<DateTime>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<int> source = GeneratedColumn<int>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skippedMeta = const VerificationMeta(
    'skipped',
  );
  @override
  late final GeneratedColumn<bool> skipped = GeneratedColumn<bool>(
    'skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("skipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    habitId,
    localDate,
    value,
    completedAt,
    source,
    note,
    skipped,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('skipped')) {
      context.handle(
        _skippedMeta,
        skipped.isAcceptableOrUnknown(data['skipped']!, _skippedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}habit_id'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}local_date'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      skipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}skipped'],
      )!,
    );
  }

  @override
  $HabitLogsTable createAlias(String alias) {
    return $HabitLogsTable(attachedDatabase, alias);
  }
}

class HabitLog extends DataClass implements Insertable<HabitLog> {
  final int id;
  final int habitId;

  /// Local calendar date at midnight, used as the identity for "which day".
  final DateTime localDate;

  /// Yes/no: 1. Count: running total for the day. Timed: seconds logged.
  /// Quit: 1 marks a slip.
  final int value;
  final DateTime completedAt;

  /// Index into [LogSource].
  final int source;
  final String? note;

  /// A deliberate rest day — excluded from streaks and completion rate,
  /// distinct from an ordinary miss. Swiped on from the Today screen.
  final bool skipped;
  const HabitLog({
    required this.id,
    required this.habitId,
    required this.localDate,
    required this.value,
    required this.completedAt,
    required this.source,
    this.note,
    required this.skipped,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['habit_id'] = Variable<int>(habitId);
    map['local_date'] = Variable<DateTime>(localDate);
    map['value'] = Variable<int>(value);
    map['completed_at'] = Variable<DateTime>(completedAt);
    map['source'] = Variable<int>(source);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['skipped'] = Variable<bool>(skipped);
    return map;
  }

  HabitLogsCompanion toCompanion(bool nullToAbsent) {
    return HabitLogsCompanion(
      id: Value(id),
      habitId: Value(habitId),
      localDate: Value(localDate),
      value: Value(value),
      completedAt: Value(completedAt),
      source: Value(source),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      skipped: Value(skipped),
    );
  }

  factory HabitLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitLog(
      id: serializer.fromJson<int>(json['id']),
      habitId: serializer.fromJson<int>(json['habitId']),
      localDate: serializer.fromJson<DateTime>(json['localDate']),
      value: serializer.fromJson<int>(json['value']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      source: serializer.fromJson<int>(json['source']),
      note: serializer.fromJson<String?>(json['note']),
      skipped: serializer.fromJson<bool>(json['skipped']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'habitId': serializer.toJson<int>(habitId),
      'localDate': serializer.toJson<DateTime>(localDate),
      'value': serializer.toJson<int>(value),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'source': serializer.toJson<int>(source),
      'note': serializer.toJson<String?>(note),
      'skipped': serializer.toJson<bool>(skipped),
    };
  }

  HabitLog copyWith({
    int? id,
    int? habitId,
    DateTime? localDate,
    int? value,
    DateTime? completedAt,
    int? source,
    Value<String?> note = const Value.absent(),
    bool? skipped,
  }) => HabitLog(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    localDate: localDate ?? this.localDate,
    value: value ?? this.value,
    completedAt: completedAt ?? this.completedAt,
    source: source ?? this.source,
    note: note.present ? note.value : this.note,
    skipped: skipped ?? this.skipped,
  );
  HabitLog copyWithCompanion(HabitLogsCompanion data) {
    return HabitLog(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      value: data.value.present ? data.value.value : this.value,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      source: data.source.present ? data.source.value : this.source,
      note: data.note.present ? data.note.value : this.note,
      skipped: data.skipped.present ? data.skipped.value : this.skipped,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitLog(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('localDate: $localDate, ')
          ..write('value: $value, ')
          ..write('completedAt: $completedAt, ')
          ..write('source: $source, ')
          ..write('note: $note, ')
          ..write('skipped: $skipped')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    habitId,
    localDate,
    value,
    completedAt,
    source,
    note,
    skipped,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitLog &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.localDate == this.localDate &&
          other.value == this.value &&
          other.completedAt == this.completedAt &&
          other.source == this.source &&
          other.note == this.note &&
          other.skipped == this.skipped);
}

class HabitLogsCompanion extends UpdateCompanion<HabitLog> {
  final Value<int> id;
  final Value<int> habitId;
  final Value<DateTime> localDate;
  final Value<int> value;
  final Value<DateTime> completedAt;
  final Value<int> source;
  final Value<String?> note;
  final Value<bool> skipped;
  const HabitLogsCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.localDate = const Value.absent(),
    this.value = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.note = const Value.absent(),
    this.skipped = const Value.absent(),
  });
  HabitLogsCompanion.insert({
    this.id = const Value.absent(),
    required int habitId,
    required DateTime localDate,
    this.value = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.note = const Value.absent(),
    this.skipped = const Value.absent(),
  }) : habitId = Value(habitId),
       localDate = Value(localDate);
  static Insertable<HabitLog> custom({
    Expression<int>? id,
    Expression<int>? habitId,
    Expression<DateTime>? localDate,
    Expression<int>? value,
    Expression<DateTime>? completedAt,
    Expression<int>? source,
    Expression<String>? note,
    Expression<bool>? skipped,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (localDate != null) 'local_date': localDate,
      if (value != null) 'value': value,
      if (completedAt != null) 'completed_at': completedAt,
      if (source != null) 'source': source,
      if (note != null) 'note': note,
      if (skipped != null) 'skipped': skipped,
    });
  }

  HabitLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? habitId,
    Value<DateTime>? localDate,
    Value<int>? value,
    Value<DateTime>? completedAt,
    Value<int>? source,
    Value<String?>? note,
    Value<bool>? skipped,
  }) {
    return HabitLogsCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      localDate: localDate ?? this.localDate,
      value: value ?? this.value,
      completedAt: completedAt ?? this.completedAt,
      source: source ?? this.source,
      note: note ?? this.note,
      skipped: skipped ?? this.skipped,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<int>(habitId.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<DateTime>(localDate.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<int>(source.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (skipped.present) {
      map['skipped'] = Variable<bool>(skipped.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitLogsCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('localDate: $localDate, ')
          ..write('value: $value, ')
          ..write('completedAt: $completedAt, ')
          ..write('source: $source, ')
          ..write('note: $note, ')
          ..write('skipped: $skipped')
          ..write(')'))
        .toString();
  }
}

class $NudgeStatesTable extends NudgeStates
    with TableInfo<$NudgeStatesTable, NudgeState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NudgeStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<int> habitId = GeneratedColumn<int>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id)',
    ),
  );
  static const VerificationMeta _learnedWeekdayMinutesMeta =
      const VerificationMeta('learnedWeekdayMinutes');
  @override
  late final GeneratedColumn<int> learnedWeekdayMinutes = GeneratedColumn<int>(
    'learned_weekday_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _learnedWeekendMinutesMeta =
      const VerificationMeta('learnedWeekendMinutes');
  @override
  late final GeneratedColumn<int> learnedWeekendMinutes = GeneratedColumn<int>(
    'learned_weekend_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sampleCountMeta = const VerificationMeta(
    'sampleCount',
  );
  @override
  late final GeneratedColumn<int> sampleCount = GeneratedColumn<int>(
    'sample_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _spreadMinutesMeta = const VerificationMeta(
    'spreadMinutes',
  );
  @override
  late final GeneratedColumn<int> spreadMinutes = GeneratedColumn<int>(
    'spread_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidentMeta = const VerificationMeta(
    'confident',
  );
  @override
  late final GeneratedColumn<bool> confident = GeneratedColumn<bool>(
    'confident',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("confident" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nextFireAtMeta = const VerificationMeta(
    'nextFireAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextFireAt = GeneratedColumn<DateTime>(
    'next_fire_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    habitId,
    learnedWeekdayMinutes,
    learnedWeekendMinutes,
    sampleCount,
    spreadMinutes,
    confident,
    nextFireAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nudge_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<NudgeState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    }
    if (data.containsKey('learned_weekday_minutes')) {
      context.handle(
        _learnedWeekdayMinutesMeta,
        learnedWeekdayMinutes.isAcceptableOrUnknown(
          data['learned_weekday_minutes']!,
          _learnedWeekdayMinutesMeta,
        ),
      );
    }
    if (data.containsKey('learned_weekend_minutes')) {
      context.handle(
        _learnedWeekendMinutesMeta,
        learnedWeekendMinutes.isAcceptableOrUnknown(
          data['learned_weekend_minutes']!,
          _learnedWeekendMinutesMeta,
        ),
      );
    }
    if (data.containsKey('sample_count')) {
      context.handle(
        _sampleCountMeta,
        sampleCount.isAcceptableOrUnknown(
          data['sample_count']!,
          _sampleCountMeta,
        ),
      );
    }
    if (data.containsKey('spread_minutes')) {
      context.handle(
        _spreadMinutesMeta,
        spreadMinutes.isAcceptableOrUnknown(
          data['spread_minutes']!,
          _spreadMinutesMeta,
        ),
      );
    }
    if (data.containsKey('confident')) {
      context.handle(
        _confidentMeta,
        confident.isAcceptableOrUnknown(data['confident']!, _confidentMeta),
      );
    }
    if (data.containsKey('next_fire_at')) {
      context.handle(
        _nextFireAtMeta,
        nextFireAt.isAcceptableOrUnknown(
          data['next_fire_at']!,
          _nextFireAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {habitId};
  @override
  NudgeState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NudgeState(
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}habit_id'],
      )!,
      learnedWeekdayMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}learned_weekday_minutes'],
      ),
      learnedWeekendMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}learned_weekend_minutes'],
      ),
      sampleCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sample_count'],
      )!,
      spreadMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spread_minutes'],
      ),
      confident: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}confident'],
      )!,
      nextFireAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_fire_at'],
      ),
    );
  }

  @override
  $NudgeStatesTable createAlias(String alias) {
    return $NudgeStatesTable(attachedDatabase, alias);
  }
}

class NudgeState extends DataClass implements Insertable<NudgeState> {
  final int habitId;
  final int? learnedWeekdayMinutes;
  final int? learnedWeekendMinutes;
  final int sampleCount;
  final int? spreadMinutes;
  final bool confident;
  final DateTime? nextFireAt;
  const NudgeState({
    required this.habitId,
    this.learnedWeekdayMinutes,
    this.learnedWeekendMinutes,
    required this.sampleCount,
    this.spreadMinutes,
    required this.confident,
    this.nextFireAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['habit_id'] = Variable<int>(habitId);
    if (!nullToAbsent || learnedWeekdayMinutes != null) {
      map['learned_weekday_minutes'] = Variable<int>(learnedWeekdayMinutes);
    }
    if (!nullToAbsent || learnedWeekendMinutes != null) {
      map['learned_weekend_minutes'] = Variable<int>(learnedWeekendMinutes);
    }
    map['sample_count'] = Variable<int>(sampleCount);
    if (!nullToAbsent || spreadMinutes != null) {
      map['spread_minutes'] = Variable<int>(spreadMinutes);
    }
    map['confident'] = Variable<bool>(confident);
    if (!nullToAbsent || nextFireAt != null) {
      map['next_fire_at'] = Variable<DateTime>(nextFireAt);
    }
    return map;
  }

  NudgeStatesCompanion toCompanion(bool nullToAbsent) {
    return NudgeStatesCompanion(
      habitId: Value(habitId),
      learnedWeekdayMinutes: learnedWeekdayMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(learnedWeekdayMinutes),
      learnedWeekendMinutes: learnedWeekendMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(learnedWeekendMinutes),
      sampleCount: Value(sampleCount),
      spreadMinutes: spreadMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(spreadMinutes),
      confident: Value(confident),
      nextFireAt: nextFireAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextFireAt),
    );
  }

  factory NudgeState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NudgeState(
      habitId: serializer.fromJson<int>(json['habitId']),
      learnedWeekdayMinutes: serializer.fromJson<int?>(
        json['learnedWeekdayMinutes'],
      ),
      learnedWeekendMinutes: serializer.fromJson<int?>(
        json['learnedWeekendMinutes'],
      ),
      sampleCount: serializer.fromJson<int>(json['sampleCount']),
      spreadMinutes: serializer.fromJson<int?>(json['spreadMinutes']),
      confident: serializer.fromJson<bool>(json['confident']),
      nextFireAt: serializer.fromJson<DateTime?>(json['nextFireAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'habitId': serializer.toJson<int>(habitId),
      'learnedWeekdayMinutes': serializer.toJson<int?>(learnedWeekdayMinutes),
      'learnedWeekendMinutes': serializer.toJson<int?>(learnedWeekendMinutes),
      'sampleCount': serializer.toJson<int>(sampleCount),
      'spreadMinutes': serializer.toJson<int?>(spreadMinutes),
      'confident': serializer.toJson<bool>(confident),
      'nextFireAt': serializer.toJson<DateTime?>(nextFireAt),
    };
  }

  NudgeState copyWith({
    int? habitId,
    Value<int?> learnedWeekdayMinutes = const Value.absent(),
    Value<int?> learnedWeekendMinutes = const Value.absent(),
    int? sampleCount,
    Value<int?> spreadMinutes = const Value.absent(),
    bool? confident,
    Value<DateTime?> nextFireAt = const Value.absent(),
  }) => NudgeState(
    habitId: habitId ?? this.habitId,
    learnedWeekdayMinutes: learnedWeekdayMinutes.present
        ? learnedWeekdayMinutes.value
        : this.learnedWeekdayMinutes,
    learnedWeekendMinutes: learnedWeekendMinutes.present
        ? learnedWeekendMinutes.value
        : this.learnedWeekendMinutes,
    sampleCount: sampleCount ?? this.sampleCount,
    spreadMinutes: spreadMinutes.present
        ? spreadMinutes.value
        : this.spreadMinutes,
    confident: confident ?? this.confident,
    nextFireAt: nextFireAt.present ? nextFireAt.value : this.nextFireAt,
  );
  NudgeState copyWithCompanion(NudgeStatesCompanion data) {
    return NudgeState(
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      learnedWeekdayMinutes: data.learnedWeekdayMinutes.present
          ? data.learnedWeekdayMinutes.value
          : this.learnedWeekdayMinutes,
      learnedWeekendMinutes: data.learnedWeekendMinutes.present
          ? data.learnedWeekendMinutes.value
          : this.learnedWeekendMinutes,
      sampleCount: data.sampleCount.present
          ? data.sampleCount.value
          : this.sampleCount,
      spreadMinutes: data.spreadMinutes.present
          ? data.spreadMinutes.value
          : this.spreadMinutes,
      confident: data.confident.present ? data.confident.value : this.confident,
      nextFireAt: data.nextFireAt.present
          ? data.nextFireAt.value
          : this.nextFireAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NudgeState(')
          ..write('habitId: $habitId, ')
          ..write('learnedWeekdayMinutes: $learnedWeekdayMinutes, ')
          ..write('learnedWeekendMinutes: $learnedWeekendMinutes, ')
          ..write('sampleCount: $sampleCount, ')
          ..write('spreadMinutes: $spreadMinutes, ')
          ..write('confident: $confident, ')
          ..write('nextFireAt: $nextFireAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    habitId,
    learnedWeekdayMinutes,
    learnedWeekendMinutes,
    sampleCount,
    spreadMinutes,
    confident,
    nextFireAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NudgeState &&
          other.habitId == this.habitId &&
          other.learnedWeekdayMinutes == this.learnedWeekdayMinutes &&
          other.learnedWeekendMinutes == this.learnedWeekendMinutes &&
          other.sampleCount == this.sampleCount &&
          other.spreadMinutes == this.spreadMinutes &&
          other.confident == this.confident &&
          other.nextFireAt == this.nextFireAt);
}

class NudgeStatesCompanion extends UpdateCompanion<NudgeState> {
  final Value<int> habitId;
  final Value<int?> learnedWeekdayMinutes;
  final Value<int?> learnedWeekendMinutes;
  final Value<int> sampleCount;
  final Value<int?> spreadMinutes;
  final Value<bool> confident;
  final Value<DateTime?> nextFireAt;
  const NudgeStatesCompanion({
    this.habitId = const Value.absent(),
    this.learnedWeekdayMinutes = const Value.absent(),
    this.learnedWeekendMinutes = const Value.absent(),
    this.sampleCount = const Value.absent(),
    this.spreadMinutes = const Value.absent(),
    this.confident = const Value.absent(),
    this.nextFireAt = const Value.absent(),
  });
  NudgeStatesCompanion.insert({
    this.habitId = const Value.absent(),
    this.learnedWeekdayMinutes = const Value.absent(),
    this.learnedWeekendMinutes = const Value.absent(),
    this.sampleCount = const Value.absent(),
    this.spreadMinutes = const Value.absent(),
    this.confident = const Value.absent(),
    this.nextFireAt = const Value.absent(),
  });
  static Insertable<NudgeState> custom({
    Expression<int>? habitId,
    Expression<int>? learnedWeekdayMinutes,
    Expression<int>? learnedWeekendMinutes,
    Expression<int>? sampleCount,
    Expression<int>? spreadMinutes,
    Expression<bool>? confident,
    Expression<DateTime>? nextFireAt,
  }) {
    return RawValuesInsertable({
      if (habitId != null) 'habit_id': habitId,
      if (learnedWeekdayMinutes != null)
        'learned_weekday_minutes': learnedWeekdayMinutes,
      if (learnedWeekendMinutes != null)
        'learned_weekend_minutes': learnedWeekendMinutes,
      if (sampleCount != null) 'sample_count': sampleCount,
      if (spreadMinutes != null) 'spread_minutes': spreadMinutes,
      if (confident != null) 'confident': confident,
      if (nextFireAt != null) 'next_fire_at': nextFireAt,
    });
  }

  NudgeStatesCompanion copyWith({
    Value<int>? habitId,
    Value<int?>? learnedWeekdayMinutes,
    Value<int?>? learnedWeekendMinutes,
    Value<int>? sampleCount,
    Value<int?>? spreadMinutes,
    Value<bool>? confident,
    Value<DateTime?>? nextFireAt,
  }) {
    return NudgeStatesCompanion(
      habitId: habitId ?? this.habitId,
      learnedWeekdayMinutes:
          learnedWeekdayMinutes ?? this.learnedWeekdayMinutes,
      learnedWeekendMinutes:
          learnedWeekendMinutes ?? this.learnedWeekendMinutes,
      sampleCount: sampleCount ?? this.sampleCount,
      spreadMinutes: spreadMinutes ?? this.spreadMinutes,
      confident: confident ?? this.confident,
      nextFireAt: nextFireAt ?? this.nextFireAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (habitId.present) {
      map['habit_id'] = Variable<int>(habitId.value);
    }
    if (learnedWeekdayMinutes.present) {
      map['learned_weekday_minutes'] = Variable<int>(
        learnedWeekdayMinutes.value,
      );
    }
    if (learnedWeekendMinutes.present) {
      map['learned_weekend_minutes'] = Variable<int>(
        learnedWeekendMinutes.value,
      );
    }
    if (sampleCount.present) {
      map['sample_count'] = Variable<int>(sampleCount.value);
    }
    if (spreadMinutes.present) {
      map['spread_minutes'] = Variable<int>(spreadMinutes.value);
    }
    if (confident.present) {
      map['confident'] = Variable<bool>(confident.value);
    }
    if (nextFireAt.present) {
      map['next_fire_at'] = Variable<DateTime>(nextFireAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NudgeStatesCompanion(')
          ..write('habitId: $habitId, ')
          ..write('learnedWeekdayMinutes: $learnedWeekdayMinutes, ')
          ..write('learnedWeekendMinutes: $learnedWeekendMinutes, ')
          ..write('sampleCount: $sampleCount, ')
          ..write('spreadMinutes: $spreadMinutes, ')
          ..write('confident: $confident, ')
          ..write('nextFireAt: $nextFireAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitLogsTable habitLogs = $HabitLogsTable(this);
  late final $NudgeStatesTable nudgeStates = $NudgeStatesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    habits,
    habitLogs,
    nudgeStates,
    settings,
  ];
}

typedef $$HabitsTableCreateCompanionBuilder =
    HabitsCompanion Function({
      Value<int> id,
      required String name,
      required int type,
      Value<int?> targetValue,
      Value<String?> targetUnit,
      required int colour,
      Value<int> scheduleMask,
      Value<int> reminderMode,
      Value<int?> fallbackTimeMinutes,
      Value<int?> intervalMinutes,
      Value<int?> intervalStartMinutes,
      Value<int?> intervalEndMinutes,
      Value<DateTime> createdAt,
      Value<DateTime?> archivedAt,
      Value<int> sortOrder,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> type,
      Value<int?> targetValue,
      Value<String?> targetUnit,
      Value<int> colour,
      Value<int> scheduleMask,
      Value<int> reminderMode,
      Value<int?> fallbackTimeMinutes,
      Value<int?> intervalMinutes,
      Value<int?> intervalStartMinutes,
      Value<int?> intervalEndMinutes,
      Value<DateTime> createdAt,
      Value<DateTime?> archivedAt,
      Value<int> sortOrder,
    });

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, Habit> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitLogsTable, List<HabitLog>>
  _habitLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.habitLogs,
    aliasName: 'habits__id__habit_logs__habit_id',
  );

  $$HabitLogsTableProcessedTableManager get habitLogsRefs {
    final manager = $$HabitLogsTableTableManager(
      $_db,
      $_db.habitLogs,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_habitLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NudgeStatesTable, List<NudgeState>>
  _nudgeStatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.nudgeStates,
    aliasName: 'habits__id__nudge_states__habit_id',
  );

  $$NudgeStatesTableProcessedTableManager get nudgeStatesRefs {
    final manager = $$NudgeStatesTableTableManager(
      $_db,
      $_db.nudgeStates,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_nudgeStatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetUnit => $composableBuilder(
    column: $table.targetUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colour => $composableBuilder(
    column: $table.colour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduleMask => $composableBuilder(
    column: $table.scheduleMask,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMode => $composableBuilder(
    column: $table.reminderMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fallbackTimeMinutes => $composableBuilder(
    column: $table.fallbackTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalMinutes => $composableBuilder(
    column: $table.intervalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalStartMinutes => $composableBuilder(
    column: $table.intervalStartMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalEndMinutes => $composableBuilder(
    column: $table.intervalEndMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> habitLogsRefs(
    Expression<bool> Function($$HabitLogsTableFilterComposer f) f,
  ) {
    final $$HabitLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitLogs,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitLogsTableFilterComposer(
            $db: $db,
            $table: $db.habitLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> nudgeStatesRefs(
    Expression<bool> Function($$NudgeStatesTableFilterComposer f) f,
  ) {
    final $$NudgeStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.nudgeStates,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NudgeStatesTableFilterComposer(
            $db: $db,
            $table: $db.nudgeStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetUnit => $composableBuilder(
    column: $table.targetUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colour => $composableBuilder(
    column: $table.colour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduleMask => $composableBuilder(
    column: $table.scheduleMask,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMode => $composableBuilder(
    column: $table.reminderMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fallbackTimeMinutes => $composableBuilder(
    column: $table.fallbackTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalMinutes => $composableBuilder(
    column: $table.intervalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalStartMinutes => $composableBuilder(
    column: $table.intervalStartMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalEndMinutes => $composableBuilder(
    column: $table.intervalEndMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetUnit => $composableBuilder(
    column: $table.targetUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get colour =>
      $composableBuilder(column: $table.colour, builder: (column) => column);

  GeneratedColumn<int> get scheduleMask => $composableBuilder(
    column: $table.scheduleMask,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMode => $composableBuilder(
    column: $table.reminderMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fallbackTimeMinutes => $composableBuilder(
    column: $table.fallbackTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalMinutes => $composableBuilder(
    column: $table.intervalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalStartMinutes => $composableBuilder(
    column: $table.intervalStartMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalEndMinutes => $composableBuilder(
    column: $table.intervalEndMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> habitLogsRefs<T extends Object>(
    Expression<T> Function($$HabitLogsTableAnnotationComposer a) f,
  ) {
    final $$HabitLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitLogs,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.habitLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> nudgeStatesRefs<T extends Object>(
    Expression<T> Function($$NudgeStatesTableAnnotationComposer a) f,
  ) {
    final $$NudgeStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.nudgeStates,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NudgeStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.nudgeStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          Habit,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (Habit, $$HabitsTableReferences),
          Habit,
          PrefetchHooks Function({bool habitLogsRefs, bool nudgeStatesRefs})
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<int?> targetValue = const Value.absent(),
                Value<String?> targetUnit = const Value.absent(),
                Value<int> colour = const Value.absent(),
                Value<int> scheduleMask = const Value.absent(),
                Value<int> reminderMode = const Value.absent(),
                Value<int?> fallbackTimeMinutes = const Value.absent(),
                Value<int?> intervalMinutes = const Value.absent(),
                Value<int?> intervalStartMinutes = const Value.absent(),
                Value<int?> intervalEndMinutes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                name: name,
                type: type,
                targetValue: targetValue,
                targetUnit: targetUnit,
                colour: colour,
                scheduleMask: scheduleMask,
                reminderMode: reminderMode,
                fallbackTimeMinutes: fallbackTimeMinutes,
                intervalMinutes: intervalMinutes,
                intervalStartMinutes: intervalStartMinutes,
                intervalEndMinutes: intervalEndMinutes,
                createdAt: createdAt,
                archivedAt: archivedAt,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int type,
                Value<int?> targetValue = const Value.absent(),
                Value<String?> targetUnit = const Value.absent(),
                required int colour,
                Value<int> scheduleMask = const Value.absent(),
                Value<int> reminderMode = const Value.absent(),
                Value<int?> fallbackTimeMinutes = const Value.absent(),
                Value<int?> intervalMinutes = const Value.absent(),
                Value<int?> intervalStartMinutes = const Value.absent(),
                Value<int?> intervalEndMinutes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                name: name,
                type: type,
                targetValue: targetValue,
                targetUnit: targetUnit,
                colour: colour,
                scheduleMask: scheduleMask,
                reminderMode: reminderMode,
                fallbackTimeMinutes: fallbackTimeMinutes,
                intervalMinutes: intervalMinutes,
                intervalStartMinutes: intervalStartMinutes,
                intervalEndMinutes: intervalEndMinutes,
                createdAt: createdAt,
                archivedAt: archivedAt,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$HabitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({habitLogsRefs = false, nudgeStatesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (habitLogsRefs) db.habitLogs,
                    if (nudgeStatesRefs) db.nudgeStates,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (habitLogsRefs)
                        await $_getPrefetchedData<
                          Habit,
                          $HabitsTable,
                          HabitLog
                        >(
                          currentTable: table,
                          referencedTable: $$HabitsTableReferences
                              ._habitLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HabitsTableReferences(
                                db,
                                table,
                                p0,
                              ).habitLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.habitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (nudgeStatesRefs)
                        await $_getPrefetchedData<
                          Habit,
                          $HabitsTable,
                          NudgeState
                        >(
                          currentTable: table,
                          referencedTable: $$HabitsTableReferences
                              ._nudgeStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HabitsTableReferences(
                                db,
                                table,
                                p0,
                              ).nudgeStatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.habitId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      Habit,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (Habit, $$HabitsTableReferences),
      Habit,
      PrefetchHooks Function({bool habitLogsRefs, bool nudgeStatesRefs})
    >;
typedef $$HabitLogsTableCreateCompanionBuilder =
    HabitLogsCompanion Function({
      Value<int> id,
      required int habitId,
      required DateTime localDate,
      Value<int> value,
      Value<DateTime> completedAt,
      Value<int> source,
      Value<String?> note,
      Value<bool> skipped,
    });
typedef $$HabitLogsTableUpdateCompanionBuilder =
    HabitLogsCompanion Function({
      Value<int> id,
      Value<int> habitId,
      Value<DateTime> localDate,
      Value<int> value,
      Value<DateTime> completedAt,
      Value<int> source,
      Value<String?> note,
      Value<bool> skipped,
    });

final class $$HabitLogsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitLogsTable, HabitLog> {
  $$HabitLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('habit_logs__habit_id__habits__id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<int>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HabitLogsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitLogsTable> {
  $$HabitLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitLogsTable> {
  $$HabitLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitLogsTable> {
  $$HabitLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get skipped =>
      $composableBuilder(column: $table.skipped, builder: (column) => column);

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitLogsTable,
          HabitLog,
          $$HabitLogsTableFilterComposer,
          $$HabitLogsTableOrderingComposer,
          $$HabitLogsTableAnnotationComposer,
          $$HabitLogsTableCreateCompanionBuilder,
          $$HabitLogsTableUpdateCompanionBuilder,
          (HabitLog, $$HabitLogsTableReferences),
          HabitLog,
          PrefetchHooks Function({bool habitId})
        > {
  $$HabitLogsTableTableManager(_$AppDatabase db, $HabitLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> habitId = const Value.absent(),
                Value<DateTime> localDate = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> source = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
              }) => HabitLogsCompanion(
                id: id,
                habitId: habitId,
                localDate: localDate,
                value: value,
                completedAt: completedAt,
                source: source,
                note: note,
                skipped: skipped,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int habitId,
                required DateTime localDate,
                Value<int> value = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> source = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
              }) => HabitLogsCompanion.insert(
                id: id,
                habitId: habitId,
                localDate: localDate,
                value: value,
                completedAt: completedAt,
                source: source,
                note: note,
                skipped: skipped,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HabitLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.habitId,
                                referencedTable: $$HabitLogsTableReferences
                                    ._habitIdTable(db),
                                referencedColumn: $$HabitLogsTableReferences
                                    ._habitIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HabitLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitLogsTable,
      HabitLog,
      $$HabitLogsTableFilterComposer,
      $$HabitLogsTableOrderingComposer,
      $$HabitLogsTableAnnotationComposer,
      $$HabitLogsTableCreateCompanionBuilder,
      $$HabitLogsTableUpdateCompanionBuilder,
      (HabitLog, $$HabitLogsTableReferences),
      HabitLog,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$NudgeStatesTableCreateCompanionBuilder =
    NudgeStatesCompanion Function({
      Value<int> habitId,
      Value<int?> learnedWeekdayMinutes,
      Value<int?> learnedWeekendMinutes,
      Value<int> sampleCount,
      Value<int?> spreadMinutes,
      Value<bool> confident,
      Value<DateTime?> nextFireAt,
    });
typedef $$NudgeStatesTableUpdateCompanionBuilder =
    NudgeStatesCompanion Function({
      Value<int> habitId,
      Value<int?> learnedWeekdayMinutes,
      Value<int?> learnedWeekendMinutes,
      Value<int> sampleCount,
      Value<int?> spreadMinutes,
      Value<bool> confident,
      Value<DateTime?> nextFireAt,
    });

final class $$NudgeStatesTableReferences
    extends BaseReferences<_$AppDatabase, $NudgeStatesTable, NudgeState> {
  $$NudgeStatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('nudge_states__habit_id__habits__id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<int>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NudgeStatesTableFilterComposer
    extends Composer<_$AppDatabase, $NudgeStatesTable> {
  $$NudgeStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get learnedWeekdayMinutes => $composableBuilder(
    column: $table.learnedWeekdayMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get learnedWeekendMinutes => $composableBuilder(
    column: $table.learnedWeekendMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sampleCount => $composableBuilder(
    column: $table.sampleCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get spreadMinutes => $composableBuilder(
    column: $table.spreadMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get confident => $composableBuilder(
    column: $table.confident,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextFireAt => $composableBuilder(
    column: $table.nextFireAt,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NudgeStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $NudgeStatesTable> {
  $$NudgeStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get learnedWeekdayMinutes => $composableBuilder(
    column: $table.learnedWeekdayMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get learnedWeekendMinutes => $composableBuilder(
    column: $table.learnedWeekendMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sampleCount => $composableBuilder(
    column: $table.sampleCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get spreadMinutes => $composableBuilder(
    column: $table.spreadMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get confident => $composableBuilder(
    column: $table.confident,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextFireAt => $composableBuilder(
    column: $table.nextFireAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NudgeStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NudgeStatesTable> {
  $$NudgeStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get learnedWeekdayMinutes => $composableBuilder(
    column: $table.learnedWeekdayMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get learnedWeekendMinutes => $composableBuilder(
    column: $table.learnedWeekendMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sampleCount => $composableBuilder(
    column: $table.sampleCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get spreadMinutes => $composableBuilder(
    column: $table.spreadMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get confident =>
      $composableBuilder(column: $table.confident, builder: (column) => column);

  GeneratedColumn<DateTime> get nextFireAt => $composableBuilder(
    column: $table.nextFireAt,
    builder: (column) => column,
  );

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NudgeStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NudgeStatesTable,
          NudgeState,
          $$NudgeStatesTableFilterComposer,
          $$NudgeStatesTableOrderingComposer,
          $$NudgeStatesTableAnnotationComposer,
          $$NudgeStatesTableCreateCompanionBuilder,
          $$NudgeStatesTableUpdateCompanionBuilder,
          (NudgeState, $$NudgeStatesTableReferences),
          NudgeState,
          PrefetchHooks Function({bool habitId})
        > {
  $$NudgeStatesTableTableManager(_$AppDatabase db, $NudgeStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NudgeStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NudgeStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NudgeStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> habitId = const Value.absent(),
                Value<int?> learnedWeekdayMinutes = const Value.absent(),
                Value<int?> learnedWeekendMinutes = const Value.absent(),
                Value<int> sampleCount = const Value.absent(),
                Value<int?> spreadMinutes = const Value.absent(),
                Value<bool> confident = const Value.absent(),
                Value<DateTime?> nextFireAt = const Value.absent(),
              }) => NudgeStatesCompanion(
                habitId: habitId,
                learnedWeekdayMinutes: learnedWeekdayMinutes,
                learnedWeekendMinutes: learnedWeekendMinutes,
                sampleCount: sampleCount,
                spreadMinutes: spreadMinutes,
                confident: confident,
                nextFireAt: nextFireAt,
              ),
          createCompanionCallback:
              ({
                Value<int> habitId = const Value.absent(),
                Value<int?> learnedWeekdayMinutes = const Value.absent(),
                Value<int?> learnedWeekendMinutes = const Value.absent(),
                Value<int> sampleCount = const Value.absent(),
                Value<int?> spreadMinutes = const Value.absent(),
                Value<bool> confident = const Value.absent(),
                Value<DateTime?> nextFireAt = const Value.absent(),
              }) => NudgeStatesCompanion.insert(
                habitId: habitId,
                learnedWeekdayMinutes: learnedWeekdayMinutes,
                learnedWeekendMinutes: learnedWeekendMinutes,
                sampleCount: sampleCount,
                spreadMinutes: spreadMinutes,
                confident: confident,
                nextFireAt: nextFireAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NudgeStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.habitId,
                                referencedTable: $$NudgeStatesTableReferences
                                    ._habitIdTable(db),
                                referencedColumn: $$NudgeStatesTableReferences
                                    ._habitIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NudgeStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NudgeStatesTable,
      NudgeState,
      $$NudgeStatesTableFilterComposer,
      $$NudgeStatesTableOrderingComposer,
      $$NudgeStatesTableAnnotationComposer,
      $$NudgeStatesTableCreateCompanionBuilder,
      $$NudgeStatesTableUpdateCompanionBuilder,
      (NudgeState, $$NudgeStatesTableReferences),
      NudgeState,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitLogsTableTableManager get habitLogs =>
      $$HabitLogsTableTableManager(_db, _db.habitLogs);
  $$NudgeStatesTableTableManager get nudgeStates =>
      $$NudgeStatesTableTableManager(_db, _db.nudgeStates);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
