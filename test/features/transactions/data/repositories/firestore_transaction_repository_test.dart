import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_track_ai/core/error/transaction_exception.dart';
import 'package:fin_track_ai/features/transactions/data/datasources/tx_remote_datasource.dart';
import 'package:fin_track_ai/features/transactions/data/repositories/firestore_transaction_repository.dart';
import 'package:fin_track_ai/features/transactions/domain/models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fin_track_ai/features/currency/domain/models/app_currency.dart';
import 'package:fin_track_ai/features/transactions/data/models/transaction_dto.dart';

class FakeTxDataSource implements TxRemoteDataSource {
  Object? createError;
  Object? updateError;
  Object? deleteError;
  Object? watchBuildError;
  int updateCalls = 0;
  final StreamController<List<Map<String, dynamic>>> controller =
      StreamController<List<Map<String, dynamic>>>();

  @override
  Future<void> create(Map<String, dynamic> data) async {
    if (createError != null) throw createError!;
  }

  @override
  Future<void> update(String id, Map<String, dynamic> data) async {
    updateCalls++;
    if (updateError != null) throw updateError!;
  }

  @override
  Future<void> delete(String id) async {
    if (deleteError != null) throw deleteError!;
  }

  @override
  Stream<List<Map<String, dynamic>>> watchAll() {
    if (watchBuildError != null) throw watchBuildError!;
    return controller.stream;
  }
}

FirebaseException firebaseError(String code) =>
    FirebaseException(plugin: 'cloud_firestore', code: code, message: 'raw');

TransactionModel tx({String? id = 't1'}) => TransactionModel(
  id: id,
  amountMinor: 1000,
  currency: AppCurrency.usd,
  type: TransactionType.expense,
  category: TransactionCategory.food,
  title: 'Lunch',
  date: DateTime(2024, 5, 15),
  walletId: 'w',
);

Matcher transactionError(TransactionErrorType type) =>
    isA<TransactionException>().having((e) => e.type, 'type', type);

void main() {
  late FakeTxDataSource dataSource;
  late FirestoreTransactionRepository repo;

  setUp(() {
    dataSource = FakeTxDataSource();
    repo = FirestoreTransactionRepository(dataSource);
  });

  const mapping = <String, TransactionErrorType>{
    'permission-denied': TransactionErrorType.permissionDenied,
    'unavailable': TransactionErrorType.networkError,
    'deadline-exceeded': TransactionErrorType.networkError,
    'not-found': TransactionErrorType.notFound,
    'unauthenticated': TransactionErrorType.notAuthenticated,
    'invalid-argument': TransactionErrorType.invalidData,
    'failed-precondition': TransactionErrorType.invalidData,
    'aborted': TransactionErrorType.unknown,
  };

  group('FirestoreTransactionRepository error mapping', () {
    mapping.forEach((code, expected) {
      test('addTransaction maps $code', () {
        dataSource.createError = firebaseError(code);
        expect(repo.addTransaction(tx()), throwsA(transactionError(expected)));
      });

      test('updateTransaction maps $code', () {
        dataSource.updateError = firebaseError(code);
        expect(
          repo.updateTransaction(tx()),
          throwsA(transactionError(expected)),
        );
      });

      test('deleteTransaction maps $code', () {
        dataSource.deleteError = firebaseError(code);
        expect(
          repo.deleteTransaction('t1'),
          throwsA(transactionError(expected)),
        );
      });
    });

    test('keeps the Firebase message for debugging', () {
      dataSource.createError = firebaseError('unavailable');
      expect(
        repo.addTransaction(tx()),
        throwsA(
          isA<TransactionException>().having(
            (e) => e.message,
            'message',
            'raw',
          ),
        ),
      );
    });

    test('non-Firebase error maps to unknown', () {
      dataSource.createError = StateError('boom');
      expect(
        repo.addTransaction(tx()),
        throwsA(transactionError(TransactionErrorType.unknown)),
      );
    });

    test('typed exception passes through unchanged', () {
      final original = TransactionException(
        TransactionErrorType.notAuthenticated,
      );
      dataSource.deleteError = original;
      expect(repo.deleteTransaction('t1'), throwsA(same(original)));
    });

    test(
      'update with null id is invalidData and never hits the datasource',
      () async {
        await expectLater(
          repo.updateTransaction(tx(id: null)),
          throwsA(transactionError(TransactionErrorType.invalidData)),
        );
        expect(dataSource.updateCalls, 0);
      },
    );

    test('translation preserves the original stack trace', () async {
      dataSource.createError = firebaseError('unavailable');
      try {
        await repo.addTransaction(tx());
        fail('expected a throw');
      } on TransactionException catch (_, st) {
        expect(st.toString(), contains('FakeTxDataSource.create'));
      }
    });
  });

  group('FirestoreTransactionRepository stream', () {
    test('translates errors that arrive on the stream', () async {
      final stream = repo.getTransactionsStream();
      final expectation = expectLater(
        stream,
        emitsError(transactionError(TransactionErrorType.permissionDenied)),
      );
      dataSource.controller.addError(firebaseError('permission-denied'));
      await expectation;
    });

    test('translates a synchronous error while building the stream', () {
      dataSource.watchBuildError = firebaseError('unauthenticated');
      expect(
        repo.getTransactionsStream,
        throwsA(transactionError(TransactionErrorType.notAuthenticated)),
      );
    });

    test('typed synchronous error is not re-wrapped', () {
      final original = TransactionException(
        TransactionErrorType.notAuthenticated,
      );
      dataSource.watchBuildError = original;
      expect(repo.getTransactionsStream, throwsA(same(original)));
    });

    test('maps documents to domain models', () async {
      final stream = repo.getTransactionsStream();
      final expectation = expectLater(
        stream,
        emits(
          isA<List<TransactionModel>>().having((l) => l.single.id, 'id', 't1'),
        ),
      );
      dataSource.controller.add([TransactionDto.fromModel(tx()).toMap()]);
      await expectation;
    });
  });
}
