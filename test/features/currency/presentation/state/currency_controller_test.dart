import 'dart:async';

import 'package:fin_track_ai/features/currency/data/repositories/firestore_currency_repository.dart';
import 'package:fin_track_ai/features/currency/data/services/exchange_rate_service.dart';
import 'package:fin_track_ai/features/currency/domain/repositories/currency_repository.dart';
import 'package:fin_track_ai/features/currency/presentation/state/currency_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecordingCurrencyRepository implements CurrencyRepository {
  RecordingCurrencyRepository(this.base);

  final String base;
  final writes = <String>[];

  @override
  Stream<String> watchBaseCurrency() => Stream.value(base);

  @override
  Future<void> setBaseCurrency(String currency) async => writes.add(currency);
}

/// Any use of the rate service fails the test: changing currency must not
/// load or read rates any more.
class UntouchableRateService extends Fake implements ExchangeRateService {}

void main() {
  late RecordingCurrencyRepository repo;
  late ProviderContainer container;

  setUp(() async {
    repo = RecordingCurrencyRepository('USD');
    container = ProviderContainer(
      overrides: [
        currencyRepositoryProvider.overrideWithValue(repo),
        exchangeRateServiceProvider.overrideWithValue(UntouchableRateService()),
      ],
    );
    addTearDown(container.dispose);
    container.listen(currencyControllerProvider, (_, _) {});
    await container.read(currencyControllerProvider.future);
  });

  test('changeCurrency writes only the base currency, once', () async {
    await container
        .read(currencyControllerProvider.notifier)
        .changeCurrency('JOD');
    expect(repo.writes, ['JOD']);
  });

  test('changeCurrency to the current value writes nothing', () async {
    await container
        .read(currencyControllerProvider.notifier)
        .changeCurrency('USD');
    expect(repo.writes, isEmpty);
  });
}
