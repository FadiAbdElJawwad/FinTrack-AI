import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../transactions/domain/models/transaction_model.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default({}) Map<String, List<TransactionModel>> groupedTransactions,
    @Default(0.0) double totalIncome,
    @Default(0.0) double totalExpense,
    @Default(0.0) double currentBalance,
  }) = _DashboardState;
}
