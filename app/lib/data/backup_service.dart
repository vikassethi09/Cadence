import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'db/database.dart';

/// Exports every habit and log to a single JSON file and shares it via the
/// system share sheet, and restores from a previously exported file.
/// This is the app's only safety net — there is no cloud.
class BackupService {
  BackupService(this.db);
  final AppDatabase db;

  Future<File> exportToFile() async {
    final habits = await db.select(db.habits).get();
    final logs = await db.select(db.habitLogs).get();

    final payload = {
      'version': 2,
      'exportedAt': DateTime.now().toIso8601String(),
      'habits': habits
          .map((h) => {
                'id': h.id,
                'name': h.name,
                'type': h.type,
                'targetValue': h.targetValue,
                'targetUnit': h.targetUnit,
                'colour': h.colour,
                'scheduleMask': h.scheduleMask,
                'reminderMode': h.reminderMode,
                'fallbackTimeMinutes': h.fallbackTimeMinutes,
                'intervalMinutes': h.intervalMinutes,
                'intervalStartMinutes': h.intervalStartMinutes,
                'intervalEndMinutes': h.intervalEndMinutes,
                'createdAt': h.createdAt.toIso8601String(),
                'archivedAt': h.archivedAt?.toIso8601String(),
                'sortOrder': h.sortOrder,
              })
          .toList(),
      'logs': logs
          .map((l) => {
                'habitId': l.habitId,
                'localDate': l.localDate.toIso8601String(),
                'value': l.value,
                'completedAt': l.completedAt.toIso8601String(),
                'source': l.source,
                'note': l.note,
                'skipped': l.skipped,
              })
          .toList(),
    };

    final dir = await getTemporaryDirectory();
    final stamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
    final file = File('${dir.path}/cadence-backup-$stamp.json');
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(payload));
    return file;
  }

  Future<void> exportAndShare() async {
    final file = await exportToFile();
    await Share.shareXFiles([XFile(file.path)], text: 'Cadence backup');
  }

  /// Restores habits and logs from an exported JSON file. Existing data is
  /// left untouched; restored habits get new ids to avoid collisions.
  Future<void> importFromFile(File file) async {
    final raw = await file.readAsString();
    final payload = jsonDecode(raw) as Map<String, dynamic>;
    final habitsJson = (payload['habits'] as List).cast<Map<String, dynamic>>();
    final logsJson = (payload['logs'] as List).cast<Map<String, dynamic>>();

    final idRemap = <int, int>{};
    for (final h in habitsJson) {
      final newId = await db.insertHabit(HabitsCompanion.insert(
        name: h['name'] as String,
        type: h['type'] as int,
        targetValue: Value(h['targetValue'] as int?),
        targetUnit: Value(h['targetUnit'] as String?),
        colour: h['colour'] as int,
        scheduleMask: Value(h['scheduleMask'] as int? ?? 127),
        reminderMode: Value(h['reminderMode'] as int? ?? 0),
        fallbackTimeMinutes: Value(h['fallbackTimeMinutes'] as int?),
        // Absent on backups made before interval reminders existed —
        // falls back to null, same as a habit that never had one set.
        intervalMinutes: Value(h['intervalMinutes'] as int?),
        intervalStartMinutes: Value(h['intervalStartMinutes'] as int?),
        intervalEndMinutes: Value(h['intervalEndMinutes'] as int?),
        createdAt: Value(DateTime.parse(h['createdAt'] as String)),
        archivedAt: Value(h['archivedAt'] != null ? DateTime.parse(h['archivedAt'] as String) : null),
        sortOrder: Value(h['sortOrder'] as int? ?? 0),
      ));
      idRemap[h['id'] as int] = newId;
    }

    for (final l in logsJson) {
      final oldHabitId = l['habitId'] as int;
      final newHabitId = idRemap[oldHabitId];
      if (newHabitId == null) continue;
      await db.into(db.habitLogs).insert(HabitLogsCompanion.insert(
            habitId: newHabitId,
            localDate: DateTime.parse(l['localDate'] as String),
            value: Value(l['value'] as int? ?? 1),
            completedAt: Value(DateTime.parse(l['completedAt'] as String)),
            source: Value(l['source'] as int? ?? 0),
            note: Value(l['note'] as String?),
            // Absent on backups made before rest days existed — defaults to
            // an ordinary (non-skipped) log, same as it would have been then.
            skipped: Value(l['skipped'] as bool? ?? false),
          ));
    }
  }

  Future<void> deleteEverything() async {
    await db.delete(db.habitLogs).go();
    await db.delete(db.nudgeStates).go();
    await db.delete(db.habits).go();
  }
}
