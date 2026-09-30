import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repositories/firestore_transaction_repository.dart';
import '../../domain/models/transaction_model.dart';

final transactionControllerProvider =
    StreamNotifierProvider.autoDispose<
      TransactionController,
      List<TransactionModel>
    >(TransactionController.new);

class TransactionController
    extends AutoDisposeStreamNotifier<List<TransactionModel>> {
  @override
  Stream<List<TransactionModel>> build() {
    return ref.watch(transactionRepositoryProvider).getTransactionsStream();
  }

  Future<void> addTransaction(TransactionModel transaction) {
    return ref.read(transactionRepositoryProvider).addTransaction(transaction);
  }

  Future<void> updateTransaction(TransactionModel transaction) {
    return ref
        .read(transactionRepositoryProvider)
        .updateTransaction(transaction);
  }

  Future<void> deleteTransaction(String id) {
    return ref.read(transactionRepositoryProvider).deleteTransaction(id);
  }
}
