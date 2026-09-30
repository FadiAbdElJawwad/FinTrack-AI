import '../models/transaction_model.dart';

Map<String, List<TransactionModel>> groupTransactions(
  List<TransactionModel> txs, {
  DateTime? now,
}) {
  now ??= DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final startOfMonth = DateTime(now.year, now.month, 1);
  final startOfNextMonth = DateTime(now.year, now.month + 1, 1);

  final Map<String, List<TransactionModel>> grouped = {
    'UPCOMING': [],
    'TODAY': [],
    'YESTERDAY': [],
    'THIS MONTH': [],
    'EARLIER': [],
  };

  for (final tx in txs) {
    final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);

    if (!tx.date.isBefore(startOfNextMonth)) {
      grouped['UPCOMING']!.add(tx);
    } else if (txDate == today) {
      grouped['TODAY']!.add(tx);
    } else if (txDate == yesterday) {
      grouped['YESTERDAY']!.add(tx);
    } else if (!tx.date.isBefore(startOfMonth)) {
      grouped['THIS MONTH']!.add(tx);
    } else {
      grouped['EARLIER']!.add(tx);
    }
  }

  grouped.removeWhere((key, value) => value.isEmpty);
  return grouped;
}
