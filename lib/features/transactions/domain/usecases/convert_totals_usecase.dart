import '../../../currency/domain/models/app_currency.dart';
import '../../../currency/domain/usecases/money.dart';
import 'calculate_totals_usecase.dart';

/// Converts per-currency totals into [target] at display time.
///
/// Income and expense are converted separately, then summed. A currency
/// equal to [target] never needs a rate, and a zero amount needs none
/// either. If a needed rate cannot be obtained, the affected total becomes
/// `null` (unknown) instead of zero.
({int? incomeMinor, int? expenseMinor}) convertTotals(
  Map<AppCurrency, CurrencyTotals> totals,
  AppCurrency target,
  double Function(AppCurrency from, AppCurrency to) rateBetween,
) {
  int? income = 0;
  int? expense = 0;

  for (final MapEntry(key: currency, value: total) in totals.entries) {
    if (currency == target) {
      if (income != null) income += total.incomeMinor;
      if (expense != null) expense += total.expenseMinor;
      continue;
    }

    double? rate;
    var rateFailed = false;
    int? convert(int minor) {
      if (minor == 0) return 0;
      if (rateFailed) return null;
      try {
        rate ??= rateBetween(currency, target);
        return convertMinorUnits(minor, currency, target, rate!);
      } catch (_) {
        rateFailed = true;
        return null;
      }
    }

    final convertedIncome = convert(total.incomeMinor);
    final convertedExpense = convert(total.expenseMinor);
    income = (income == null || convertedIncome == null)
        ? null
        : income + convertedIncome;
    expense = (expense == null || convertedExpense == null)
        ? null
        : expense + convertedExpense;
  }

  return (incomeMinor: income, expenseMinor: expense);
}
