import '../../../currency/domain/models/app_currency.dart';
import '../../../transactions/domain/models/transaction_model.dart';
import 'analytics_period.dart';

class CategoryExpense {
  const CategoryExpense({
    required this.category,
    required this.amountMinor,
    required this.share,
  });

  final TransactionCategory category;
  final int? amountMinor;
  final double? share;
}

class AnalyticsSummary {
  const AnalyticsSummary({
    required this.period,
    required this.currency,
    required this.incomeMinor,
    required this.expenseMinor,
    required this.categories,
    required this.transactionCount,
  });

  final AnalyticsPeriod period;
  final AppCurrency currency;
  final int? incomeMinor;
  final int? expenseMinor;
  final List<CategoryExpense> categories;
  final int transactionCount;
}
