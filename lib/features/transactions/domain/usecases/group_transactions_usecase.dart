import '../models/transaction_model.dart';

enum TransactionGroup { upcoming, today, yesterday, thisMonth, earlier }

Map<TransactionGroup, List<TransactionModel>> groupTransactions(
  List<TransactionModel> txs, {
  DateTime? now,
}) {
  now ??= DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final startOfMonth = DateTime(now.year, now.month, 1);
  final startOfNextMonth = DateTime(now.year, now.month + 1, 1);

  final Map<TransactionGroup, List<TransactionModel>> grouped = {
    for (final group in TransactionGroup.values) group: [],
  };

  for (final tx in txs) {
    final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);

    if (!tx.date.isBefore(startOfNextMonth)) {
      grouped[TransactionGroup.upcoming]!.add(tx);
    } else if (txDate == today) {
      grouped[TransactionGroup.today]!.add(tx);
    } else if (txDate == yesterday) {
      grouped[TransactionGroup.yesterday]!.add(tx);
    } else if (!tx.date.isBefore(startOfMonth)) {
      grouped[TransactionGroup.thisMonth]!.add(tx);
    } else {
      grouped[TransactionGroup.earlier]!.add(tx);
    }
  }

  grouped.removeWhere((key, value) => value.isEmpty);
  return grouped;
}
