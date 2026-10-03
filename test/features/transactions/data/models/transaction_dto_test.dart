import 'package:fin_track_ai/features/currency/domain/models/app_currency.dart';
import 'package:fin_track_ai/features/transactions/data/models/transaction_dto.dart';
import 'package:fin_track_ai/features/transactions/domain/models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionModel model({
  AppCurrency currency = AppCurrency.usd,
  int amountMinor = 1234,
}) => TransactionModel(
  id: 't1',
  amountMinor: amountMinor,
  currency: currency,
  type: TransactionType.expense,
  category: TransactionCategory.food,
  title: 'Lunch',
  date: DateTime(2024, 5, 15, 12, 30),
  walletId: 'w1',
);

Map<String, dynamic> validMap() =>
    Map<String, dynamic>.of(TransactionDto.fromModel(model()).toMap());

void main() {
  group('TransactionDto round trip', () {
    for (final currency in AppCurrency.values) {
      test('model -> map -> model for ${currency.code}', () {
        final original = model(currency: currency, amountMinor: 98765);
        final decoded = TransactionDto.fromMap(
          TransactionDto.fromModel(original).toMap(),
        ).toModel();
        expect(decoded, original);
      });
    }

    test('wire format matches the documented fields', () {
      expect(validMap(), {
        'id': 't1',
        'amountMinor': 1234,
        'currency': 'USD',
        'type': 'expense',
        'category': 'food',
        'title': 'Lunch',
        'date': DateTime(2024, 5, 15, 12, 30).toIso8601String(),
        'walletId': 'w1',
      });
    });

    test('toMap never writes the legacy amount field', () {
      for (final currency in AppCurrency.values) {
        final map = TransactionDto.fromModel(model(currency: currency)).toMap();
        expect(map.containsKey('amount'), isFalse);
      }
    });
  });

  group('TransactionDto strict decoding', () {
    test('missing amountMinor is malformed', () {
      final map = validMap()..remove('amountMinor');
      expect(() => TransactionDto.fromMap(map), throwsFormatException);
    });

    test('non-int amountMinor is malformed', () {
      for (final bad in [12.5, '1234', null]) {
        final map = validMap()..['amountMinor'] = bad;
        expect(
          () => TransactionDto.fromMap(map),
          throwsFormatException,
          reason: '$bad',
        );
      }
    });

    test('legacy document with amount but no amountMinor is malformed', () {
      final map = validMap()
        ..remove('amountMinor')
        ..remove('currency')
        ..['amount'] = 12.34;
      expect(() => TransactionDto.fromMap(map), throwsFormatException);
    });

    test('unknown or missing currency is malformed', () {
      for (final bad in ['EUR', 'usd', null, 5]) {
        final map = validMap()..['currency'] = bad;
        expect(
          () => TransactionDto.fromMap(map),
          throwsFormatException,
          reason: '$bad',
        );
      }
    });

    test('unknown or missing type is malformed', () {
      for (final bad in ['transfer', null]) {
        final map = validMap()..['type'] = bad;
        expect(
          () => TransactionDto.fromMap(map),
          throwsFormatException,
          reason: '$bad',
        );
      }
    });

    test('invalid date is malformed', () {
      final map = validMap()..['date'] = 'yesterday';
      expect(() => TransactionDto.fromMap(map), throwsFormatException);
    });

    test('unknown category falls back to other', () {
      final map = validMap()..['category'] = 'crypto';
      expect(
        TransactionDto.fromMap(map).toModel().category,
        TransactionCategory.other,
      );
    });

    test('missing walletId defaults to empty string', () {
      final map = validMap()..remove('walletId');
      expect(TransactionDto.fromMap(map).toModel().walletId, '');
    });

    test('missing id is allowed', () {
      final map = validMap()..remove('id');
      expect(TransactionDto.fromMap(map).toModel().id, isNull);
    });
  });
}
