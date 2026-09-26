import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repositories/firestore_currency_repository.dart';
import '../../data/services/exchange_rate_service.dart';

final currencyControllerProvider =
    StreamNotifierProvider.autoDispose<CurrencyController, String>(
  CurrencyController.new,
);

class CurrencyController extends AutoDisposeStreamNotifier<String> {
  @override
  Stream<String> build() {
    return ref.watch(currencyRepositoryProvider).watchBaseCurrency();
  }

  /// Converts every transaction from the current base currency to
  /// [newCurrency] and only then flips the app's base currency.
  Future<void> changeCurrency(String newCurrency) async {
    final source = state.valueOrNull ?? await future;
    if (source == newCurrency) return;

    final rateService = ref.read(exchangeRateServiceProvider);
    await rateService.ensureLoaded();
    final rate = rateService.rateBetween(source, newCurrency);

    await ref.read(currencyRepositoryProvider).changeCurrency(
          from: source,
          to: newCurrency,
          rate: rate,
        );
  }
}
