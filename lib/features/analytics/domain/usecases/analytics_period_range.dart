import '../../../transactions/domain/transaction_limits.dart';
import '../models/analytics_period.dart';

/// Computes the start (inclusive) and endExclusive dates for an [AnalyticsPeriod].
///
/// Uses calendar arithmetic (e.g., [DateTime] constructors) rather than [Duration]
/// arithmetic on days/months to handle month length variations and DST safely.
({DateTime start, DateTime endExclusive}) analyticsPeriodRange(
  AnalyticsPeriod period,
  DateTime now, {
  int windowMonths = transactionWindowMonths,
}) {
  return switch (period) {
    AnalyticsPeriod.week => (
      start: DateTime(now.year, now.month, now.day - 6),
      endExclusive: DateTime(now.year, now.month, now.day + 1),
    ),
    AnalyticsPeriod.month => (
      start: DateTime(now.year, now.month, 1),
      endExclusive: DateTime(now.year, now.month + 1, 1),
    ),
    AnalyticsPeriod.year => (
      start: DateTime(now.year, now.month - (windowMonths - 1), 1),
      endExclusive: DateTime(now.year, now.month + 1, 1),
    ),
  };
}
