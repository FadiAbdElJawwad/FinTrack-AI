import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_track_ai/core/error/transaction_exception.dart';
import 'package:fin_track_ai/features/transactions/data/datasources/tx_remote_datasource.dart';
import 'package:fin_track_ai/features/transactions/data/repositories/firestore_transaction_repository.dart';
import 'package:fin_track_ai/features/transactions/domain/models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fin_track_ai/features/currency/domain/models/app_currency.dart';

/// Writes are controlled by completers, so each test decides whether (and
/// when) the "server acknowledgement" arrives.
class ControlledTxDataSource implements TxRemoteDataSource {
  final createCompleter = Completer<void>();
  final updateCompleter = Completer<void>();
  final deleteCompleter = Completer<void>();

  @override
  Future<void> create(Map<String, dynamic> data) => createCompleter.future;

  @override
  Future<void> update(String id, Map<String, dynamic> data) =>
      updateCompleter.future;

  @override
  Future<void> delete(String id) => deleteCompleter.future;

  @override
  Stream<List<Map<String, dynamic>>> watchAll() => const Stream.empty();
}

const shortTimeout = Duration(milliseconds: 50);

TransactionModel tx() => TransactionModel(
  id: 't1',
  amountMinor: 1000,
  currency: AppCurrency.usd,
  type: TransactionType.expense,
  category: TransactionCategory.food,
  title: 'Lunch',
  date: DateTime(2024, 5, 15),
  walletId: 'w',
);

FirebaseException firebaseError(String code) =>
    FirebaseException(plugin: 'cloud_firestore', code: code);

void main() {
  late ControlledTxDataSource dataSource;
  late FirestoreTransactionRepository repo;

  setUp(() {
    dataSource = ControlledTxDataSource();
    repo = FirestoreTransactionRepository(
      dataSource,
      writeTimeout: shortTimeout,
    );
  });

  group('write acknowledgement timeout', () {
    test('addTransaction completes normally when never acknowledged', () async {
      await repo.addTransaction(tx());
    });

    test(
      'updateTransaction completes normally when never acknowledged',
      () async {
        await repo.updateTransaction(tx());
      },
    );

    test(
      'deleteTransaction completes normally when never acknowledged',
      () async {
        await repo.deleteTransaction('t1');
      },
    );

    test('success before the timeout works as before', () async {
      dataSource.createCompleter.complete();
      await repo.addTransaction(tx());
    });

    test('error before the timeout is translated', () async {
      dataSource.updateCompleter.completeError(firebaseError('unavailable'));
      await expectLater(
        repo.updateTransaction(tx()),
        throwsA(
          isA<TransactionException>().having(
            (e) => e.type,
            'type',
            TransactionErrorType.networkError,
          ),
        ),
      );
    });

    test('immediate delete error keeps its mapped type', () async {
      dataSource.deleteCompleter.completeError(
        firebaseError('permission-denied'),
      );
      await expectLater(
        repo.deleteTransaction('t1'),
        throwsA(
          isA<TransactionException>().having(
            (e) => e.type,
            'type',
            TransactionErrorType.permissionDenied,
          ),
        ),
      );
    });

    test('typed exception before the timeout is not re-wrapped', () async {
      final original = TransactionException(
        TransactionErrorType.notAuthenticated,
      );
      dataSource.createCompleter.completeError(original);
      await expectLater(repo.addTransaction(tx()), throwsA(same(original)));
    });

    test(
      'an error arriving after the timeout is not an uncaught error',
      () async {
        final uncaught = <Object>[];
        await runZonedGuarded(() async {
          // Built inside the guarded zone, like the real SDK future that is
          // created by the call itself.
          final late = ControlledTxDataSource();
          final lateRepo = FirestoreTransactionRepository(
            late,
            writeTimeout: shortTimeout,
          );
          await lateRepo.addTransaction(tx());
          await lateRepo.updateTransaction(tx());
          await lateRepo.deleteTransaction('t1');

          late.createCompleter.completeError(
            firebaseError('permission-denied'),
          );
          late.updateCompleter.completeError(firebaseError('unavailable'));
          late.deleteCompleter.completeError(StateError('late'));

          await Future<void>.delayed(const Duration(milliseconds: 100));
        }, (error, stack) => uncaught.add(error));

        expect(uncaught, isEmpty);
      },
    );

    test('the null-id guard still fires before any write', () async {
      await expectLater(
        repo.updateTransaction(
          TransactionModel(
            amountMinor: 100,
            currency: AppCurrency.usd,
            type: TransactionType.expense,
            category: TransactionCategory.food,
            title: 't',
            date: DateTime(2024, 5, 15),
            walletId: 'w',
          ),
        ),
        throwsA(
          isA<TransactionException>().having(
            (e) => e.type,
            'type',
            TransactionErrorType.invalidData,
          ),
        ),
      );
    });
  });
}
