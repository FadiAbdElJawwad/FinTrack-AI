import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/error/transaction_exception.dart';
import '../../domain/models/transaction_model.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/tx_remote_datasource.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return FirestoreTransactionRepository(ref.watch(txRemoteDataSourceProvider));
});

/// Translates any error into a [TransactionException].
///
/// An already typed exception is returned as-is (never re-wrapped).
/// `FirebaseException.message` is kept for debugging only; it is never shown
/// to users.
TransactionException translateTransactionError(Object error) {
  if (error is TransactionException) return error;
  if (error is FirebaseException) {
    return TransactionException(
      _typeForCode(error.code),
      message: error.message,
    );
  }
  return TransactionException(
    TransactionErrorType.unknown,
    message: error.toString(),
  );
}

TransactionErrorType _typeForCode(String code) {
  switch (code) {
    case 'permission-denied':
      return TransactionErrorType.permissionDenied;
    case 'unavailable':
    case 'deadline-exceeded':
      return TransactionErrorType.networkError;
    case 'not-found':
      return TransactionErrorType.notFound;
    case 'unauthenticated':
      return TransactionErrorType.notAuthenticated;
    case 'invalid-argument':
    case 'failed-precondition':
      return TransactionErrorType.invalidData;
    default:
      return TransactionErrorType.unknown;
  }
}

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
    } catch (e, st) {
      Error.throwWithStackTrace(translateTransactionError(e), st);
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    final id = transaction.id;
    if (id == null) {
      throw TransactionException(
        TransactionErrorType.invalidData,
        message: 'Transaction ID is required for updates.',
      );
    }
    try {
      await _dataSource.update(id, transaction.toJson());
    } catch (e, st) {
      Error.throwWithStackTrace(translateTransactionError(e), st);
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await _dataSource.delete(id);
    } catch (e, st) {
      Error.throwWithStackTrace(translateTransactionError(e), st);
    }
  }

  @override
  Stream<List<TransactionModel>> getTransactionsStream() {
    try {
      return _dataSource
          .watchAll()
          .map((docs) => docs.map(TransactionModel.fromJson).toList())
          .transform(
            StreamTransformer<
              List<TransactionModel>,
              List<TransactionModel>
            >.fromHandlers(
              handleError: (error, stackTrace, sink) {
                sink.addError(translateTransactionError(error), stackTrace);
              },
            ),
          );
    } catch (e, st) {
      Error.throwWithStackTrace(translateTransactionError(e), st);
    }
  }
}
