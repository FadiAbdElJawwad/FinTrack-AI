import 'package:fin_track_ai/features/currency/domain/models/app_currency.dart';
import 'package:fin_track_ai/features/currency/domain/usecases/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const usd = AppCurrency.usd;
  const jod = AppCurrency.jod;
  const ils = AppCurrency.ils;

  group('AppCurrency', () {
    test('decimals and minorFactor', () {
      expect([usd.decimals, jod.decimals, ils.decimals], [2, 3, 2]);
      expect(
        [usd.minorFactor, jod.minorFactor, ils.minorFactor],
        [100, 1000, 100],
      );
    });

    test('strict lookup returns null for unknown codes', () {
      expect(appCurrencyTryFromCode('JOD'), jod);
      expect(appCurrencyTryFromCode('EUR'), isNull);
      expect(appCurrencyTryFromCode('usd'), isNull);
    });

    test('lenient lookup still falls back to USD', () {
      expect(appCurrencyFromCode('EUR'), usd);
    });
  });

  group('parseMinorUnits', () {
    test('USD with two decimals', () {
      expect(parseMinorUnits('12.34', usd), 1234);
      expect(parseMinorUnits('12.3', usd), 1230);
      expect(parseMinorUnits('12', usd), 1200);
    });

    test('JOD with three decimals', () {
      expect(parseMinorUnits('1.234', jod), 1234);
      expect(parseMinorUnits('0.005', jod), 5);
      expect(parseMinorUnits('7', jod), 7000);
    });

    test('ILS with two decimals', () {
      expect(parseMinorUnits('99.99', ils), 9999);
    });

    test('trims surrounding whitespace', () {
      expect(parseMinorUnits('  5.10 ', usd), 510);
    });

    test('accepts leading zeros', () {
      expect(parseMinorUnits('007.50', usd), 750);
    });

    test('zero parses to 0 (validity > 0 is the form\'s job)', () {
      expect(parseMinorUnits('0', usd), 0);
      expect(parseMinorUnits('0.00', usd), 0);
    });

    test('rejects more fraction digits than the currency allows', () {
      expect(parseMinorUnits('1.234', usd), isNull);
      expect(parseMinorUnits('1.2345', jod), isNull);
      expect(parseMinorUnits('0.001', ils), isNull);
    });

    test('rejects empty and lone dot', () {
      expect(parseMinorUnits('', usd), isNull);
      expect(parseMinorUnits('   ', usd), isNull);
      expect(parseMinorUnits('.', usd), isNull);
    });

    test('rejects signs, exponents, NaN and Infinity', () {
      for (final text in ['-5', '+5', '1e3', 'NaN', 'Infinity', '-Infinity']) {
        expect(parseMinorUnits(text, usd), isNull, reason: text);
      }
    });

    test('rejects grouping separators and multiple dots', () {
      for (final text in ['1,000', '1 000', '1.000.00', '1..0']) {
        expect(parseMinorUnits(text, usd), isNull, reason: text);
      }
    });

    test('rejects non-ASCII digits', () {
      expect(parseMinorUnits('١٢', usd), isNull);
    });

    test('documented: "1." and ".5" are accepted', () {
      expect(parseMinorUnits('1.', usd), 100);
      expect(parseMinorUnits('.5', usd), 50);
      expect(parseMinorUnits('.005', jod), 5);
    });

    test('accepts the maximum and rejects anything above it', () {
      expect(parseMinorUnits('10000000000.00', usd), maxMinorUnits);
      expect(parseMinorUnits('10000000000.01', usd), isNull);
      expect(parseMinorUnits('1000000000.000', jod), maxMinorUnits);
      expect(parseMinorUnits('1000000000.001', jod), isNull);
    });

    test('rejects huge inputs without overflowing', () {
      expect(parseMinorUnits('9' * 40, usd), isNull);
      expect(parseMinorUnits('0' * 30 + '1', usd), 100);
    });
  });

  group('minorToPlainText', () {
    test('prints exactly the currency decimals', () {
      expect(minorToPlainText(1234, usd), '12.34');
      expect(minorToPlainText(100, usd), '1.00');
      expect(minorToPlainText(5, jod), '0.005');
      expect(minorToPlainText(1230, jod), '1.230');
      expect(minorToPlainText(0, ils), '0.00');
    });

    test('negative values keep their sign', () {
      expect(minorToPlainText(-1205, usd), '-12.05');
    });

    test('round-trips through parseMinorUnits for every currency', () {
      const samples = [0, 1, 9, 10, 99, 100, 101, 1234, 999999, maxMinorUnits];
      for (final currency in AppCurrency.values) {
        for (final minor in samples) {
          expect(
            parseMinorUnits(minorToPlainText(minor, currency), currency),
            minor,
            reason: '$currency $minor',
          );
        }
      }
    });
  });

  group('convertMinorUnits', () {
    test('same currency returns the amount and ignores the rate', () {
      expect(convertMinorUnits(1234, usd, usd, 999.0), 1234);
      expect(convertMinorUnits(1234, jod, jod, double.nan), 1234);
    });

    test('converts with a plain rate', () {
      expect(convertMinorUnits(1000, usd, ils, 2.0), 2000);
    });

    test('rounds half away from zero for positive values', () {
      // 0.005 JOD at rate 1 = 0.5 cent -> 1 cent.
      expect(convertMinorUnits(5, jod, usd, 1.0), 1);
      // 0.015 JOD at rate 1 = 1.5 cents -> 2 cents.
      expect(convertMinorUnits(15, jod, usd, 1.0), 2);
      // 0.004 JOD = 0.4 cent -> 0.
      expect(convertMinorUnits(4, jod, usd, 1.0), 0);
    });

    test('rounds half away from zero for negative values', () {
      expect(convertMinorUnits(-5, jod, usd, 1.0), -1);
      expect(convertMinorUnits(-15, jod, usd, 1.0), -2);
      expect(convertMinorUnits(-4, jod, usd, 1.0), 0);
    });

    test('JOD to USD keeps three-to-two decimal precision', () {
      // 1.234 JOD at 1.5 USD/JOD = 1.851 USD -> 185 cents.
      expect(convertMinorUnits(1234, jod, usd, 1.5), 185);
    });

    test('USD to JOD gains the third decimal', () {
      // 1.23 USD at 0.5 JOD/USD = 0.615 JOD -> 615 fils.
      expect(convertMinorUnits(123, usd, jod, 0.5), 615);
    });

    test('a non-finite result throws', () {
      expect(
        () => convertMinorUnits(100, usd, jod, double.infinity),
        throwsArgumentError,
      );
    });
  });
}
