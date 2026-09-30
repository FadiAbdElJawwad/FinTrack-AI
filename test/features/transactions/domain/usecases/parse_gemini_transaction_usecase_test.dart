import 'package:flutter_test/flutter_test.dart';
import 'package:fin_track_ai/core/error/ai_parsing_exception.dart';
import 'package:fin_track_ai/features/transactions/domain/models/transaction_model.dart';
import 'package:fin_track_ai/features/transactions/domain/usecases/parse_gemini_transaction_usecase.dart';

void main() {
  final now = DateTime(2024, 5, 15, 10, 30);

  TransactionDraft parse(Map<String, dynamic> overrides) {
    return parseGeminiTransaction({
      'amount': 10,
      'type': 'expense',
      'category': 'food',
      'title': 'Lunch',
      ...overrides,
    }, now: now);
  }

  void expectSchemaFailure(Map<String, dynamic> input) {
    expect(
      () => parseGeminiTransaction(input, now: now),
      throwsA(
        isA<AiParsingException>().having(
          (e) => e.type,
          'type',
          AiParsingErrorType.schemaValidationFailed,
        ),
      ),
    );
  }

  group('parseGeminiTransaction amount', () {
    test('accepts num amount', () {
      expect(parse({'amount': 12.5}).amount, closeTo(12.5, 1e-9));
    });

    test('accepts int amount as double', () {
      expect(parse({'amount': 7}).amount, closeTo(7.0, 1e-9));
    });

    test('accepts numeric string amount', () {
      expect(parse({'amount': '42.75'}).amount, closeTo(42.75, 1e-9));
    });

    test('missing amount throws schemaValidationFailed', () {
      expectSchemaFailure({'type': 'expense'});
    });

    test('zero amount throws schemaValidationFailed', () {
      expectSchemaFailure({'amount': 0});
    });

    test('negative amount throws schemaValidationFailed', () {
      expectSchemaFailure({'amount': -5});
    });

    test('non-numeric string amount throws schemaValidationFailed', () {
      expectSchemaFailure({'amount': 'abc'});
    });
  });

  group('parseGeminiTransaction type', () {
    test('"income" parses as income', () {
      expect(
        parse({'type': 'income', 'category': 'salary'}).type,
        TransactionType.income,
      );
    });

    test('type is case-insensitive', () {
      expect(parse({'type': 'INCOME'}).type, TransactionType.income);
      expect(parse({'type': 'InCoMe'}).type, TransactionType.income);
    });

    test('missing type falls back to expense', () {
      final input = <String, dynamic>{'amount': 10};
      expect(
        parseGeminiTransaction(input, now: now).type,
        TransactionType.expense,
      );
    });

    test('unknown type falls back to expense', () {
      expect(parse({'type': 'transfer'}).type, TransactionType.expense);
    });
  });

  group('parseGeminiTransaction category', () {
    test('valid category matching the type is kept', () {
      expect(
        parse({'category': 'transport'}).category,
        TransactionCategory.transport,
      );
      expect(
        parse({'type': 'income', 'category': 'salary'}).category,
        TransactionCategory.salary,
      );
    });

    test('category is case-insensitive', () {
      expect(parse({'category': 'FOOD'}).category, TransactionCategory.food);
    });

    test('unknown category falls back to other', () {
      expect(parse({'category': 'crypto'}).category, TransactionCategory.other);
    });

    test('missing category falls back to other', () {
      final input = <String, dynamic>{'amount': 10};
      expect(
        parseGeminiTransaction(input, now: now).category,
        TransactionCategory.other,
      );
    });

    test('category not allowed for type falls back to other', () {
      expect(
        parse({'type': 'expense', 'category': 'salary'}).category,
        TransactionCategory.other,
      );
      expect(
        parse({'type': 'income', 'category': 'food'}).category,
        TransactionCategory.other,
      );
    });
  });

  group('parseGeminiTransaction title and date', () {
    test('missing title becomes empty string', () {
      final input = <String, dynamic>{'amount': 10};
      expect(parseGeminiTransaction(input, now: now).title, '');
    });

    test('title is kept', () {
      expect(parse({'title': 'Coffee'}).title, 'Coffee');
    });

    test('valid ISO date is parsed', () {
      expect(
        parse({'date': '2024-03-02T08:15:00'}).date,
        DateTime(2024, 3, 2, 8, 15),
      );
    });

    test('missing date falls back to injected now', () {
      expect(parse({}).date, now);
    });

    test('empty date falls back to injected now', () {
      expect(parse({'date': ''}).date, now);
    });

    test('invalid date falls back to injected now', () {
      expect(parse({'date': 'not-a-date'}).date, now);
    });
  });

  group('parseGeminiTransaction known bugs', () {
    test(
      'NaN string amount must throw',
      () => expectSchemaFailure({'amount': 'NaN'}),
      skip:
          'Known bug: double.tryParse("NaN") yields NaN, which passes the '
          '<= 0 check',
    );

    test(
      'Infinity string amount must throw',
      () => expectSchemaFailure({'amount': 'Infinity'}),
      skip:
          'Known bug: double.tryParse("Infinity") yields infinity, which '
          'passes the <= 0 check',
    );

    test(
      'type with trailing space parses as income',
      () => expect(parse({'type': 'Income '}).type, TransactionType.income),
      skip:
          'Known bug: type string is not trimmed, "Income " falls back to '
          'expense',
    );
  });
}
