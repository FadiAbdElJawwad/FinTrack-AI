import 'dart:async';

import 'package:fin_track_ai/features/currency/domain/models/app_currency.dart';
import 'package:fin_track_ai/features/transactions/data/datasources/tx_remote_datasource.dart';
import 'package:fin_track_ai/features/transactions/data/models/transaction_dto.dart';
import 'package:fin_track_ai/features/transactions/data/repositories/firestore_transaction_repository.dart';
import 'package:fin_track_ai/features/transactions/domain/models/transaction_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records the window arguments of every listener request.
class WindowRecordingDataSource extends Fake implements TxRemoteDataSource {
  final requests = <({String fromIsoDate, int limit})>[];
  final controller = StreamController<List<Map<String, dynamic>>>.broadcast();

  @override
  Stream<List<Map<String, dynamic>>> watchAll({
    required String fromIsoDate,
    required int limit,
  }) {
    requests.add((fromIsoDate: fromIsoDate, limit: limit));
    return controller.stream;
  }
}

Map<String, dynamic> doc(int i) => TransactionDto.fromModel(
  TransactionModel(
    id: 't$i',
    amountMinor: 100,
    currency: AppCurrency.usd,
    type: TransactionType.expense,
    category: TransactionCategory.food,
    title: 't$i',
    date: DateTime(2026, 9, 1),
    walletId: 'w',
  ),
).toMap();

void main() {
  late WindowRecordingDataSource dataSource;

  setUp(() => dataSource = WindowRecordingDataSource());
  tearDown(() => unawaited(dataSource.controller.close()));

  FirestoreTransactionRepository repoAt(
    DateTime now, {
    int windowMonths = 12,
    int maxDocuments = 1000,
  }) => FirestoreTransactionRepository(
    dataSource,
    windowMonths: windowMonths,
    maxDocuments: maxDocuments,
    clock: () => now,
  );

  String cutoffFor(DateTime now, {int windowMonths = 12}) {
    repoAt(now, windowMonths: windowMonths).getTransactionsStream();
    return dataSource.requests.last.fromIsoDate;
  }

  group('listener window cutoff', () {
    test('default 12 months starts on the 1st, 11 months back', () {
      expect(
        cutoffFor(DateTime(2026, 10, 3, 15, 45)),
        DateTime(2025, 11, 1).toIso8601String(),
      );
    });

    test('cutoff is midnight on the first day of the month', () {
      expect(
        cutoffFor(DateTime(2026, 10, 31, 23, 59)),
        '2025-11-01T00:00:00.000',
      );
    });

    test('January crosses into the previous year', () {
      expect(
        cutoffFor(DateTime(2026, 1, 15)),
        DateTime(2025, 2, 1).toIso8601String(),
      );
    });

    test('a window longer than the current month count spans two years', () {
      expect(
        cutoffFor(DateTime(2026, 1, 1), windowMonths: 14),
        DateTime(2024, 12, 1).toIso8601String(),
      );
    });

    test('a three-month window in February starts in December', () {
      expect(
        cutoffFor(DateTime(2026, 2, 28), windowMonths: 3),
        DateTime(2025, 12, 1).toIso8601String(),
      );
    });

    test('a one-month window starts on the 1st of the current month', () {
      expect(
        cutoffFor(DateTime(2026, 3, 20), windowMonths: 1),
        DateTime(2026, 3, 1).toIso8601String(),
      );
    });

    test('the clock is read when the listener is created', () {
      var now = DateTime(2026, 5, 10);
      final repo = FirestoreTransactionRepository(dataSource, clock: () => now);
      repo.getTransactionsStream();
      now = DateTime(2026, 6, 2);
      repo.getTransactionsStream();
      expect(dataSource.requests.map((r) => r.fromIsoDate), [
        DateTime(2025, 6, 1).toIso8601String(),
        DateTime(2025, 7, 1).toIso8601String(),
      ]);
    });
  });

  group('listener document cap', () {
    test('the default cap of 1000 is passed to the data source', () {
      repoAt(DateTime(2026, 10, 3)).getTransactionsStream();
      expect(dataSource.requests.single.limit, 1000);
    });

    test('a custom cap is passed to the data source', () {
      repoAt(DateTime(2026, 10, 3), maxDocuments: 25).getTransactionsStream();
      expect(dataSource.requests.single.limit, 25);
    });

    group('warning', () {
      late List<String?> logs;
      late DebugPrintCallback original;

      setUp(() {
        logs = [];
        original = debugPrint;
        debugPrint = (message, {wrapWidth}) => logs.add(message);
      });
      tearDown(() => debugPrint = original);

      test('logs when exactly the cap is returned, and still emits', () async {
        final stream = repoAt(
          DateTime(2026, 10, 3),
          maxDocuments: 3,
        ).getTransactionsStream();
        final expectation = expectLater(stream, emits(hasLength(3)));
        dataSource.controller.add([doc(1), doc(2), doc(3)]);
        await expectation;
        expect(
          logs,
          contains(
            '[TransactionRepository] listener hit the document cap (3); '
            'older transactions are not included',
          ),
        );
      });

      test('does not log below the cap', () async {
        final stream = repoAt(
          DateTime(2026, 10, 3),
          maxDocuments: 3,
        ).getTransactionsStream();
        final expectation = expectLater(stream, emits(hasLength(2)));
        dataSource.controller.add([doc(1), doc(2)]);
        await expectation;
        expect(logs.where((l) => l!.contains('document cap')), isEmpty);
      });
    });
  });
}
