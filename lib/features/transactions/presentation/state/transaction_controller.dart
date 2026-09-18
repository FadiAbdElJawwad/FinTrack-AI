import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/repositories/firestore_transaction_repository.dart';
import '../../domain/models/transaction_model.dart';

final transactionControllerProvider = StreamNotifierProvider.autoDispose<
  TransactionController,
  List<TransactionModel>
>(TransactionController.new);

class TransactionController
    extends AutoDisposeStreamNotifier<List<TransactionModel>> {
  @override
  Stream<List<TransactionModel>> build() {
    return ref.watch(transactionRepositoryProvider).getTransactionsStream();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await ref.read(transactionRepositoryProvider).addTransaction(transaction);
    } catch (e) {

      throw Exception('Failed to add transaction: $e');
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await ref.read(transactionRepositoryProvider).updateTransaction(
        transaction,
      );
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await ref.read(transactionRepositoryProvider).deleteTransaction(id);
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }
}
