import 'package:fin_track_ai/features/currency/data/datasources/currency_remote_datasource.dart';
import 'package:fin_track_ai/features/currency/data/repositories/firestore_currency_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records every call. The real datasource no longer has any transaction
/// read or write; a [Fake] would throw on any unexpected member.
class RecordingCurrencyDataSource extends Fake
    implements CurrencyRemoteDataSource {
  final writes = <String>[];

  @override
  Future<void> setBaseCurrency(String currency) async => writes.add(currency);

  @override
  Stream<String> watchBaseCurrency() => Stream.value('USD');
}

void main() {
  test('setBaseCurrency performs exactly one baseCurrency write', () async {
    final dataSource = RecordingCurrencyDataSource();
    final repo = FirestoreCurrencyRepository(dataSource);

    await repo.setBaseCurrency('JOD');

    expect(dataSource.writes, ['JOD']);
  });

  test('watchBaseCurrency delegates to the datasource', () async {
    final repo = FirestoreCurrencyRepository(RecordingCurrencyDataSource());
    expect(await repo.watchBaseCurrency().first, 'USD');
  });
}
