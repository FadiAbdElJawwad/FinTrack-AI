import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../transactions/presentation/state/transaction_controller.dart';
import '../../../transactions/domain/usecases/group_transactions_usecase.dart';
import '../../../transactions/domain/models/transaction_model.dart';
import '../states/dashboard_state.dart';

final dashboardControllerProvider =
    Provider.autoDispose<AsyncValue<DashboardState>>((ref) {
      final transactionsAsync = ref.watch(transactionControllerProvider);

      return transactionsAsync.whenData((transactions) {
        double income = 0.0;
        double expense = 0.0;

        for (final tx in transactions) {
          if (tx.type == TransactionType.income) {
            income += tx.amount;
          } else {
            expense += tx.amount;
          }
        }

        return DashboardState(
          groupedTransactions: groupTransactions(transactions),
          totalIncome: income,
          totalExpense: expense,
          currentBalance: income - expense,
        );
      });
    });
