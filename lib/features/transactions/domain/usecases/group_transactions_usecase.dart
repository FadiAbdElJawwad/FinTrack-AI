import '../models/transaction_model.dart';

Map<String, List<TransactionModel>> groupTransactions(
  List<TransactionModel> txs, {
  DateTime? now,
}) {
  now ??= DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final startOfMonth = DateTime(now.year, now.month, 1);

  final Map<String, List<TransactionModel>> grouped = {
    'TODAY': [],
    'YESTERDAY': [],
    'THIS MONTH': [],
  };

  for (final tx in txs) {
    final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);

    if (txDate == today) {
      grouped['TODAY']!.add(tx);
    } else if (txDate == yesterday) {
      grouped['YESTERDAY']!.add(tx);
    } else if (tx.date.isAfter(startOfMonth) ||
        tx.date.isAtSameMomentAs(startOfMonth)) {
      grouped['THIS MONTH']!.add(tx);
    }
  }

  grouped.removeWhere((key, value) => value.isEmpty);
  return grouped;
}
