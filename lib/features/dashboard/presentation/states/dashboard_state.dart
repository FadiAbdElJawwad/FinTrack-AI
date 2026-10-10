import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../currency/domain/models/app_currency.dart';
import '../../../transactions/domain/models/transaction_model.dart';
import '../../../transactions/domain/usecases/group_transactions_usecase.dart';

part 'dashboard_state.freezed.dart';

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default({})
    Map<TransactionGroup, List<TransactionModel>> groupedTransactions,
    @Default(AppCurrency.usd) AppCurrency currency,

    /// Income in minor units of [currency]; `null` when a foreign-currency
    /// part could not be converted because rates are unavailable.
    int? incomeMinor,

    /// Expense in minor units of [currency]; `null` as for [incomeMinor].
    int? expenseMinor,
  }) = _DashboardState;

  const DashboardState._();

  /// `null` when either total is unknown.
  int? get balanceMinor {
    final income = incomeMinor;
    final expense = expenseMinor;
    if (income == null || expense == null) return null;
    return income - expense;
  }
}
