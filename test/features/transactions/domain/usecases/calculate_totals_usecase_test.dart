import 'package:flutter_test/flutter_test.dart';
import 'package:fin_track_ai/features/transactions/domain/models/transaction_model.dart';
import 'package:fin_track_ai/features/transactions/domain/usecases/calculate_totals_usecase.dart';

void main() {
  TransactionModel tx(TransactionType type, double amount) => TransactionModel(
    amount: amount,
    type: type,
    category: TransactionCategory.other,
    title: 't',
    date: DateTime(2024, 5, 15),
    walletId: 'w',
  );

  group('calculateTotals', () {
    test('empty list returns zeros', () {
      final t = calculateTotals([]);
      expect(t.income, closeTo(0, 1e-9));
      expect(t.expense, closeTo(0, 1e-9));
      expect(t.balance, closeTo(0, 1e-9));
    });

    test('only income', () {
      final t = calculateTotals([
        tx(TransactionType.income, 100),
        tx(TransactionType.income, 50.5),
      ]);
      expect(t.income, closeTo(150.5, 1e-9));
      expect(t.expense, closeTo(0, 1e-9));
      expect(t.balance, closeTo(150.5, 1e-9));
    });

    test('only expense', () {
      final t = calculateTotals([
        tx(TransactionType.expense, 30),
        tx(TransactionType.expense, 20),
      ]);
      expect(t.income, closeTo(0, 1e-9));
      expect(t.expense, closeTo(50, 1e-9));
      expect(t.balance, closeTo(-50, 1e-9));
    });

    test('mixed keeps income and expense separate', () {
      final t = calculateTotals([
        tx(TransactionType.income, 200),
        tx(TransactionType.expense, 75),
        tx(TransactionType.income, 50),
        tx(TransactionType.expense, 25),
      ]);
      expect(t.income, closeTo(250, 1e-9));
      expect(t.expense, closeTo(100, 1e-9));
      expect(t.balance, closeTo(150, 1e-9));
    });

    test('balance is negative when expense exceeds income', () {
      final t = calculateTotals([
        tx(TransactionType.income, 10),
        tx(TransactionType.expense, 40),
      ]);
      expect(t.balance, closeTo(-30, 1e-9));
      expect(t.balance, isNegative);
    });

    test('decimal amounts accumulate within tolerance', () {
      final t = calculateTotals([
        tx(TransactionType.expense, 0.1),
        tx(TransactionType.expense, 0.2),
      ]);
      expect(t.expense, closeTo(0.3, 1e-9));
    });
  });
}
