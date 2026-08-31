import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../transactions/data/providers/transaction_providers.dart';
import '../../../transactions/domain/models/transaction_model.dart';
import '../states/dashboard_state.dart';

final dashboardControllerProvider =
    Provider.autoDispose<AsyncValue<DashboardState>>((ref) {
      final transactionsAsync = ref.watch(transactionsStreamProvider);

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
