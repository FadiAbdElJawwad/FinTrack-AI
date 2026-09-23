import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/tx_remote_datasource.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return FirestoreTransactionRepository(ref.watch(txRemoteDataSourceProvider));
});

/// Implements [TransactionRepository] on top of [TxRemoteDataSource].
///
/// Owns exception translation and domain-model mapping; Firestore specifics
/// (queries, DocReferences, ordering) live in the data source.
class FirestoreTransactionRepository implements TransactionRepository {
  FirestoreTransactionRepository(this._dataSource);

  final TxRemoteDataSource _dataSource;

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _dataSource.create(transaction.toJson());
    } on FirebaseException catch (e) {
      throw Exception('Firestore error while adding transaction: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while adding transaction: $e');
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      if (transaction.id == null) {
        throw Exception('Transaction ID is required for updates.');
      }
      await _dataSource.update(transaction.id!, transaction.toJson());
    } on FirebaseException catch (e) {
      throw Exception(
        'Firestore error while updating transaction: ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error while updating transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await _dataSource.delete(id);
    } on FirebaseException catch (e) {
      throw Exception(
        'Firestore error while deleting transaction: ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error while deleting transaction: $e');
    }
  }

  @override
  Stream<List<TransactionModel>> getTransactionsStream() {
    try {
      return _dataSource.watchAll().map(
            (docs) => docs.map(TransactionModel.fromJson).toList(),
          );
    } on FirebaseException catch (e) {
      throw Exception(
        'Firestore error while streaming transactions: ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error while streaming transactions: $e');
    }
  }
}