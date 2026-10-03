abstract class CurrencyRepository {
  /// Streams the user's `baseCurrency` (defaults to 'USD' when unset).
  Stream<String> watchBaseCurrency();

  /// Writes the user's `baseCurrency`. Transactions keep their original
  /// currency and are converted only at display time.
  Future<void> setBaseCurrency(String currency);
}
