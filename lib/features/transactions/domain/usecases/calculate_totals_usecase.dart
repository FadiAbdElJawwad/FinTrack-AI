import '../models/transaction_model.dart';

class TransactionTotals {
  final double income;
  final double expense;

  const TransactionTotals({required this.income, required this.expense});

  double get balance => income - expense;
}

TransactionTotals calculateTotals(List<TransactionModel> transactions) {
  double income = 0.0;
  double expense = 0.0;

  for (final tx in transactions) {
    if (tx.type == TransactionType.income) {
      income += tx.amount;
    } else {
      expense += tx.amount;
    }
  }

  return TransactionTotals(income: income, expense: expense);
}
