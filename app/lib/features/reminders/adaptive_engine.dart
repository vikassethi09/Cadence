import '../../data/db/database.dart';

/// The learned nudge time for one habit, computed fresh from its logs.
class AdaptiveResult {
  const AdaptiveResult({
    required this.weekdayMinutes,
    required this.weekendMinutes,
    required this.sampleCount,
    required this.spreadMinutes,
    required this.confident,
  });

  /// Learned minute-of-day (0-1439) for Mon-Fri, or null if not confident.
  final int? weekdayMinutes;

  /// Learned minute-of-day for Sat/Sun, or null if not confident.
  final int? weekendMinutes;

  final int sampleCount;
  final int? spreadMinutes;
  final bool confident;

  static const empty = AdaptiveResult(
    weekdayMinutes: null,
    weekendMinutes: null,
    sampleCount: 0,
    spreadMinutes: null,
    confident: false,
  );

  /// Picks weekday or weekend learned time for [date], falling back to
  /// [fallbackMinutes] and nudging 15 minutes early.
  int nudgeMinutesFor(DateTime date, int fallbackMinutes) {
    final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    final learned = isWeekend ? weekendMinutes : weekdayMinutes;
    final base = learned ?? fallbackMinutes;
    final early = base - 15;
    return early < 0 ? early + 1440 : early;
  }
}

/// Computes [AdaptiveResult] from a habit's completion history. Pure — no
/// I/O, no database access, so it's trivially testable and safe to call on
/// every nightly recompute without touching the DB beyond the read.
class AdaptiveEngine {
  static const _minSamples = 7;
  static const _minBucketSamples = 4;
  static const _maxSpreadMinutes = 180; // 3 hours — beyond this, no real rhythm

  static AdaptiveResult compute(List<HabitLog> logs) {
    if (logs.length < _minSamples) {
      return AdaptiveResult(
        weekdayMinutes: null,
        weekendMinutes: null,
        sampleCount: logs.length,
        spreadMinutes: null,
        confident: false,
      );
    }

    final weekdayTimes = <int>[];
    final weekendTimes = <int>[];
    for (final log in logs) {
      final minutes = log.completedAt.hour * 60 + log.completedAt.minute;
      final isWeekend = log.completedAt.weekday == DateTime.saturday || log.completedAt.weekday == DateTime.sunday;
      (isWeekend ? weekendTimes : weekdayTimes).add(minutes);
    }

    final weekday = _bucketResult(weekdayTimes);
    final weekend = _bucketResult(weekendTimes);

    return AdaptiveResult(
      weekdayMinutes: weekday.$1,
      weekendMinutes: weekend.$1,
      sampleCount: logs.length,
      spreadMinutes: weekday.$2 ?? weekend.$2,
      confident: weekday.$1 != null || weekend.$1 != null,
    );
  }

  /// Returns (medianMinutes, iqrMinutes) for a bucket, or (null, null) if
  /// there isn't enough data or the spread is too wide to trust.
  static (int?, int?) _bucketResult(List<int> minutes) {
    if (minutes.length < _minBucketSamples) return (null, null);
    final sorted = [...minutes]..sort();
    final median = _percentile(sorted, 0.5);
    final q1 = _percentile(sorted, 0.25);
    final q3 = _percentile(sorted, 0.75);
    final iqr = q3 - q1;
    if (iqr > _maxSpreadMinutes) return (null, iqr);
    return (median, iqr);
  }

  static int _percentile(List<int> sorted, double p) {
    final idx = (sorted.length - 1) * p;
    final lower = idx.floor();
    final upper = idx.ceil();
    if (lower == upper) return sorted[lower];
    final frac = idx - lower;
    return (sorted[lower] * (1 - frac) + sorted[upper] * frac).round();
  }
}
