import 'package:flutter_test/flutter_test.dart';
import 'package:fin_track_ai/features/currency/domain/models/app_currency.dart';
import 'package:fin_track_ai/features/transactions/domain/models/transaction_model.dart';
import 'package:fin_track_ai/features/transactions/domain/usecases/calculate_totals_usecase.dart';

void main() {
  TransactionModel tx(
    TransactionType type,
    int amountMinor, {
    AppCurrency currency = AppCurrency.usd,
  }) => TransactionModel(
    amountMinor: amountMinor,
    currency: currency,
    type: type,
    category: TransactionCategory.other,
    title: 't',
    date: DateTime(2024, 5, 15),
    walletId: 'w',
  );

  group('calculateTotals', () {
    test('empty list returns no totals', () {
      expect(calculateTotals([]), isEmpty);
    });

    test('only income', () {
      final t = calculateTotals([
        tx(TransactionType.income, 10000),
        tx(TransactionType.income, 5050),
      ])[AppCurrency.usd]!;
      expect(t.incomeMinor, 15050);
      expect(t.expenseMinor, 0);
      expect(t.balanceMinor, 15050);
    });

    test('only expense', () {
      final t = calculateTotals([
        tx(TransactionType.expense, 3000),
        tx(TransactionType.expense, 2000),
      ])[AppCurrency.usd]!;
      expect(t.incomeMinor, 0);
      expect(t.expenseMinor, 5000);
      expect(t.balanceMinor, -5000);
    });

    test('mixed keeps income and expense separate', () {
      final t = calculateTotals([
        tx(TransactionType.income, 20000),
        tx(TransactionType.expense, 7500),
        tx(TransactionType.income, 5000),
        tx(TransactionType.expense, 2500),
      ])[AppCurrency.usd]!;
      expect(t.incomeMinor, 25000);
      expect(t.expenseMinor, 10000);
      expect(t.balanceMinor, 15000);
    });

    test('balance is negative when expense exceeds income', () {
      final t = calculateTotals([
        tx(TransactionType.income, 1000),
        tx(TransactionType.expense, 4000),
      ])[AppCurrency.usd]!;
      expect(t.balanceMinor, -3000);
      expect(t.balanceMinor, isNegative);
    });

    test('decimal amounts accumulate exactly', () {
      final t = calculateTotals([
        tx(TransactionType.expense, 10),
        tx(TransactionType.expense, 20),
      ])[AppCurrency.usd]!;
      expect(t.expenseMinor, 30);
    });
  });

  group('calculateTotals per currency', () {
    test('keeps one entry per original currency', () {
      final totals = calculateTotals([
        tx(TransactionType.income, 1000),
        tx(TransactionType.income, 2500, currency: AppCurrency.jod),
        tx(TransactionType.expense, 300, currency: AppCurrency.ils),
      ]);
      expect(totals.keys.toSet(), {
        AppCurrency.usd,
        AppCurrency.jod,
        AppCurrency.ils,
      });
      expect(totals[AppCurrency.usd]!.incomeMinor, 1000);
      expect(totals[AppCurrency.jod]!.incomeMinor, 2500);
      expect(totals[AppCurrency.ils]!.expenseMinor, 300);
    });

    test('never adds amounts of different currencies together', () {
      final totals = calculateTotals([
        tx(TransactionType.expense, 1000),
        tx(TransactionType.expense, 1000, currency: AppCurrency.jod),
      ]);
      expect(totals[AppCurrency.usd]!.expenseMinor, 1000);
      expect(totals[AppCurrency.jod]!.expenseMinor, 1000);
    });

    test('income and expense stay separate within each currency', () {
      final jod = calculateTotals([
        tx(TransactionType.income, 5000, currency: AppCurrency.jod),
        tx(TransactionType.expense, 1250, currency: AppCurrency.jod),
      ])[AppCurrency.jod]!;
      expect(jod.incomeMinor, 5000);
      expect(jod.expenseMinor, 1250);
      expect(jod.balanceMinor, 3750);
    });

    test('a currency with only one type has zero for the other', () {
      final ils = calculateTotals([
        tx(TransactionType.expense, 999, currency: AppCurrency.ils),
      ])[AppCurrency.ils]!;
      expect(ils.incomeMinor, 0);
      expect(ils.balanceMinor, -999);
    });
  });
}
