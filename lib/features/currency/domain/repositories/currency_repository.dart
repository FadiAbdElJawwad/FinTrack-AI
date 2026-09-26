abstract class CurrencyRepository {
  /// Streams the user's `baseCurrency` (defaults to 'USD' when unset).
  Stream<String> watchBaseCurrency();

  /// Reconverts every transaction's amount by [rate] and, only once that
  /// succeeds, updates the user's base currency to [to]. If reconversion
  /// fails partway through, the base currency is left as [from] so the app
  /// never ends up with a currency that doesn't match its transactions.
  Future<void> changeCurrency({
    required String from,
    required String to,
    required double rate,
  });
}
