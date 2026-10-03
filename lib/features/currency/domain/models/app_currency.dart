enum AppCurrency { usd, jod, ils }

extension AppCurrencyX on AppCurrency {
  String get code => switch (this) {
    AppCurrency.usd => 'USD',
    AppCurrency.jod => 'JOD',
    AppCurrency.ils => 'ILS',
  };

  String get symbol => switch (this) {
    AppCurrency.usd => r'$',
    AppCurrency.jod => 'JD',
    AppCurrency.ils => '₪',
  };

  /// Number of fraction digits of the currency's minor unit.
  int get decimals => switch (this) {
    AppCurrency.usd => 2,
    AppCurrency.jod => 3,
    AppCurrency.ils => 2,
  };

  /// Minor units per major unit (`10^decimals`).
  int get minorFactor => switch (this) {
    AppCurrency.usd => 100,
    AppCurrency.jod => 1000,
    AppCurrency.ils => 100,
  };
}

AppCurrency appCurrencyFromCode(String code) {
  return AppCurrency.values.firstWhere(
    (currency) => currency.code == code,
    orElse: () => AppCurrency.usd,
  );
}

/// Strict lookup: returns `null` for unknown codes (no silent fallback).
AppCurrency? appCurrencyTryFromCode(String code) {
  for (final currency in AppCurrency.values) {
    if (currency.code == code) return currency;
  }
  return null;
}
