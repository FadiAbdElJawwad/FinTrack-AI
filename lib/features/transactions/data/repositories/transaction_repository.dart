import '../../domain/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Stream<List<TransactionModel>> getTransactionsStream();
}
