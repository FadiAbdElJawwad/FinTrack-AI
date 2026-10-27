import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/presentation/state/auth_controller.dart';
import '../../data/repositories/firestore_currency_repository.dart';

final currencyControllerProvider =
    StreamNotifierProvider.autoDispose<CurrencyController, String>(
      CurrencyController.new,
    );

class CurrencyController extends AutoDisposeStreamNotifier<String> {
  @override
  Stream<String> build() {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return Stream.value('USD');
    }
    return ref.watch(currencyRepositoryProvider).watchBaseCurrency();
  }

  /// Writes only the new base currency. Transactions keep their original
  /// currency; conversion happens at display time.
  Future<void> changeCurrency(String newCurrency) async {
    if (state.valueOrNull == newCurrency) return;
    await ref.read(currencyRepositoryProvider).setBaseCurrency(newCurrency);
  }
}
