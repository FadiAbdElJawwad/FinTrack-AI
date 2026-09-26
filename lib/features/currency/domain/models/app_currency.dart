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
}

AppCurrency appCurrencyFromCode(String code) {
  return AppCurrency.values.firstWhere(
    (currency) => currency.code == code,
    orElse: () => AppCurrency.usd,
  );
}
