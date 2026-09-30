import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../transactions/presentation/state/transaction_controller.dart';
import '../../../transactions/domain/usecases/group_transactions_usecase.dart';
import '../../../transactions/domain/usecases/calculate_totals_usecase.dart';
import '../states/dashboard_state.dart';

final dashboardControllerProvider =
    Provider.autoDispose<AsyncValue<DashboardState>>((ref) {
      final transactionsAsync = ref.watch(transactionControllerProvider);

      return transactionsAsync.whenData((transactions) {
        final totals = calculateTotals(transactions);

        return DashboardState(
          groupedTransactions: groupTransactions(transactions),
          totalIncome: totals.income,
          totalExpense: totals.expense,
          currentBalance: totals.balance,
        );
      });
    });
