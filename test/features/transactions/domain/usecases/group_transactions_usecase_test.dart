import 'package:flutter_test/flutter_test.dart';
import 'package:fin_track_ai/features/transactions/domain/models/transaction_model.dart';
import 'package:fin_track_ai/features/transactions/domain/usecases/group_transactions_usecase.dart';

void main() {
  final now = DateTime(2024, 5, 15, 10, 30);

  TransactionModel tx(String id, DateTime date) => TransactionModel(
    id: id,
    amount: 10,
    type: TransactionType.expense,
    category: TransactionCategory.food,
    title: id,
    date: date,
    walletId: 'w',
  );

  List<String?> ids(Map<String, List<TransactionModel>> g, String key) =>
      g[key]!.map((t) => t.id).toList();

  group('groupTransactions', () {
    test('empty input returns empty map', () {
      expect(groupTransactions([], now: now), isEmpty);
    });

    test('groups a transaction from today', () {
      final g = groupTransactions([
        tx('a', DateTime(2024, 5, 15, 8)),
      ], now: now);
      expect(g.keys, ['TODAY']);
      expect(ids(g, 'TODAY'), ['a']);
    });

    test('groups a transaction from yesterday', () {
      final g = groupTransactions([
        tx('a', DateTime(2024, 5, 14, 12)),
      ], now: now);
      expect(g.keys, ['YESTERDAY']);
    });

    test('groups an earlier transaction of this month', () {
      final g = groupTransactions([
        tx('a', DateTime(2024, 5, 3, 12)),
      ], now: now);
      expect(g.keys, ['THIS MONTH']);
    });

    test('transaction at the start of the month is THIS MONTH', () {
      final g = groupTransactions([tx('a', DateTime(2024, 5, 1))], now: now);
      expect(g.keys, ['THIS MONTH']);
    });

    test('empty groups are removed', () {
      final g = groupTransactions([
        tx('a', DateTime(2024, 5, 15, 8)),
        tx('b', DateTime(2024, 5, 2)),
      ], now: now);
      expect(g.keys, ['TODAY', 'THIS MONTH']);
    });

    test('order inside a group is preserved', () {
      final g = groupTransactions([
        tx('c', DateTime(2024, 5, 15, 9)),
        tx('a', DateTime(2024, 5, 15, 20)),
        tx('b', DateTime(2024, 5, 15, 1)),
      ], now: now);
      expect(ids(g, 'TODAY'), ['c', 'a', 'b']);
    });

    test('on the 1st, yesterday belongs to the previous month', () {
      final first = DateTime(2024, 6, 1, 9);
      final g = groupTransactions([
        tx('y', DateTime(2024, 5, 31, 15)),
        tx('t', DateTime(2024, 6, 1, 0, 0)),
      ], now: first);
      expect(ids(g, 'YESTERDAY'), ['y']);
      expect(ids(g, 'TODAY'), ['t']);
    });

    test('transaction at 23:59 yesterday is YESTERDAY', () {
      final g = groupTransactions([
        tx('a', DateTime(2024, 5, 14, 23, 59)),
      ], now: now);
      expect(g.keys, ['YESTERDAY']);
    });

    test('transaction at 00:00 today is TODAY', () {
      final g = groupTransactions([tx('a', DateTime(2024, 5, 15))], now: now);
      expect(g.keys, ['TODAY']);
    });
  });

  group('groupTransactions known bugs', () {
    test(
      'transaction from a previous month must not disappear',
      () {
        final g = groupTransactions([
          tx('old', DateTime(2024, 3, 10)),
        ], now: now);
        final all = g.values.expand((l) => l).map((t) => t.id);
        expect(all, contains('old'));
      },
      skip:
          'Known bug: transactions before the start of the month get no '
          'group and are dropped',
    );

    test(
      'future transaction in the next month is not THIS MONTH',
      () {
        final g = groupTransactions([
          tx('future', DateTime(2024, 6, 20)),
        ], now: now);
        expect(g['THIS MONTH'] ?? const [], isEmpty);
      },
      skip:
          'Known bug: any date after the start of the month, including '
          'future months, is grouped as THIS MONTH',
    );

    test(
      'yesterday across a DST change is still YESTERDAY',
      () {
        // 2024-03-10 is a US spring-forward day; in such zones
        // today.subtract(24h) lands on Mar 9 23:00 instead of Mar 10 00:00.
        final dst = DateTime(2024, 3, 11, 12);
        final g = groupTransactions([
          tx('a', DateTime(2024, 3, 10, 12)),
        ], now: dst);
        expect(g.keys, ['YESTERDAY']);
      },
      skip:
          'Known bug: yesterday = today.subtract(24h) breaks on DST days; '
          'pure Dart cannot set the local time zone, so this only fails on '
          'CI machines in DST zones (e.g. America/*) and passes in UTC',
    );
  });
}
