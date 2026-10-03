import 'dart:async';

import 'package:fin_track_ai/core/error/transaction_exception.dart';
import 'package:fin_track_ai/features/currency/domain/models/app_currency.dart';
import 'package:fin_track_ai/features/transactions/data/datasources/tx_remote_datasource.dart';
import 'package:fin_track_ai/features/transactions/data/models/transaction_dto.dart';
import 'package:fin_track_ai/features/transactions/data/repositories/firestore_transaction_repository.dart';
import 'package:fin_track_ai/features/transactions/domain/models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

class StreamTxDataSource implements TxRemoteDataSource {
  final controller = StreamController<List<Map<String, dynamic>>>();
  final written = <Map<String, dynamic>>[];

  @override
  Future<void> create(Map<String, dynamic> data) async => written.add(data);

  @override
  Future<void> update(String id, Map<String, dynamic> data) async =>
      written.add(data);

  @override
  Future<void> delete(String id) async {}

  @override
  Stream<List<Map<String, dynamic>>> watchAll({
    required String fromIsoDate,
    required int limit,
  }) => controller.stream;
}

TransactionModel tx(String id, {AppCurrency currency = AppCurrency.usd}) =>
    TransactionModel(
      id: id,
      amountMinor: 1500,
      currency: currency,
      type: TransactionType.income,
      category: TransactionCategory.salary,
      title: id,
      date: DateTime(2024, 5, 15),
      walletId: 'w',
    );

Map<String, dynamic> doc(TransactionModel model) =>
    TransactionDto.fromModel(model).toMap();

void main() {
  late StreamTxDataSource dataSource;
  late FirestoreTransactionRepository repo;

  setUp(() {
    dataSource = StreamTxDataSource();
    repo = FirestoreTransactionRepository(dataSource);
  });

  tearDown(() => unawaited(dataSource.controller.close()));

  group('FirestoreTransactionRepository decoding', () {
    test('skips malformed documents and keeps valid ones', () async {
      final expectation = expectLater(
        repo.getTransactionsStream(),
        emits(
          isA<List<TransactionModel>>().having(
            (l) => l.map((t) => t.id).toList(),
            'ids',
            ['ok1', 'ok2'],
          ),
        ),
      );
      dataSource.controller.add([
        doc(tx('ok1')),
        {'id': 'legacy', 'amount': 12.5, 'type': 'expense'},
        doc(tx('bad-currency'))..['currency'] = 'EUR',
        doc(tx('ok2', currency: AppCurrency.jod)),
      ]);
      await expectation;
    });

    test('a list of only malformed documents emits an empty list', () async {
      final expectation = expectLater(
        repo.getTransactionsStream(),
        emits(isEmpty),
      );
      dataSource.controller.add([
        {'id': 'x'},
      ]);
      await expectation;
    });

    test('the stream keeps working after a malformed snapshot', () async {
      final expectation = expectLater(
        repo.getTransactionsStream(),
        emitsInOrder([
          isEmpty,
          isA<List<TransactionModel>>().having((l) => l.single.id, 'id', 'a'),
        ]),
      );
      dataSource.controller
        ..add([
          {'id': 'broken', 'amountMinor': 'nope'},
        ])
        ..add([doc(tx('a'))]);
      await expectation;
    });

    test('stream errors are still translated', () async {
      final expectation = expectLater(
        repo.getTransactionsStream(),
        emitsError(isA<TransactionException>()),
      );
      dataSource.controller.addError(StateError('boom'));
      await expectation;
    });

    test('writes use the DTO wire format without amount', () async {
      await repo.addTransaction(tx('a', currency: AppCurrency.ils));
      await repo.updateTransaction(tx('a'));
      expect(dataSource.written, hasLength(2));
      expect(dataSource.written.first['amountMinor'], 1500);
      expect(dataSource.written.first['currency'], 'ILS');
      for (final map in dataSource.written) {
        expect(map.containsKey('amount'), isFalse);
      }
    });
  });
}
