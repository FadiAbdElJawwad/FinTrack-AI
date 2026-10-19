import 'package:fin_track_ai/features/currency/domain/models/app_currency.dart';
import 'package:fin_track_ai/features/transactions/domain/models/transaction_model.dart';
import 'package:fin_track_ai/features/wallets/domain/usecases/wallet_has_transactions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('walletHasTransactions', () {
    test('true when a transaction has the wallet id', () {
      final transactions = [
        TransactionModel(
          id: 't1',
          walletId: 'w1',
          amountMinor: 100,
          currency: AppCurrency.usd,
          type: TransactionType.expense,
          category: TransactionCategory.food,
          title: 'Lunch',
          date: DateTime(2023, 1, 1),
        ),
      ];
      expect(walletHasTransactions(transactions, 'w1'), isTrue);
    });

    test('false when only other wallets transactions exist', () {
      final transactions = [
        TransactionModel(
          id: 't1',
          walletId: 'w2',
          amountMinor: 100,
          currency: AppCurrency.usd,
          type: TransactionType.expense,
          category: TransactionCategory.food,
          title: 'Lunch',
          date: DateTime(2023, 1, 1),
        ),
      ];
      expect(walletHasTransactions(transactions, 'w1'), isFalse);
    });

    test('false for an empty list', () {
      expect(walletHasTransactions([], 'w1'), isFalse);
    });
  });
}
