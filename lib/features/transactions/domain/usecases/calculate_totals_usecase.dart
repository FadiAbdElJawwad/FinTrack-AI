import '../../../currency/domain/models/app_currency.dart';
import '../models/transaction_model.dart';

/// Income and expense of one currency, in that currency's minor units.
class CurrencyTotals {
  final int incomeMinor;
  final int expenseMinor;

  const CurrencyTotals({required this.incomeMinor, required this.expenseMinor});

  int get balanceMinor => incomeMinor - expenseMinor;
}

/// Sums transactions per original currency, keeping income and expense
/// strictly separate by [TransactionType]. No currency conversion happens
/// here; amounts of different currencies are never added together.
Map<AppCurrency, CurrencyTotals> calculateTotals(
  List<TransactionModel> transactions,
) {
  final income = <AppCurrency, int>{};
  final expense = <AppCurrency, int>{};
  final currencies = <AppCurrency>{};

  for (final tx in transactions) {
    currencies.add(tx.currency);
    if (tx.type == TransactionType.income) {
      income[tx.currency] = (income[tx.currency] ?? 0) + tx.amountMinor;
    } else {
      expense[tx.currency] = (expense[tx.currency] ?? 0) + tx.amountMinor;
    }
  }

  return {
    for (final currency in currencies)
      currency: CurrencyTotals(
        incomeMinor: income[currency] ?? 0,
        expenseMinor: expense[currency] ?? 0,
      ),
  };
}
