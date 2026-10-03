import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_remote_datasource.dart';

final currencyRepositoryProvider = Provider<CurrencyRepository>((ref) {
  return FirestoreCurrencyRepository(
    ref.watch(currencyRemoteDataSourceProvider),
  );
});

/// Implements [CurrencyRepository] on top of [CurrencyRemoteDataSource].
///
/// Owns exception translation; Firestore specifics (DocRefs) live in the
/// data source.
class FirestoreCurrencyRepository implements CurrencyRepository {
  FirestoreCurrencyRepository(this._dataSource);

  final CurrencyRemoteDataSource _dataSource;

  @override
  Stream<String> watchBaseCurrency() {
    try {
      return _dataSource.watchBaseCurrency();
    } on FirebaseException catch (e) {
      throw Exception(
        'Firestore error while streaming base currency: ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error while streaming base currency: $e');
    }
  }

  @override
  Future<void> setBaseCurrency(String currency) async {
    try {
      await _dataSource.setBaseCurrency(currency);
    } on FirebaseException catch (e) {
      debugPrint(
        '[CurrencyRepository] setBaseCurrency FAILED. '
        'code=${e.code} message=${e.message} plugin=${e.plugin}',
      );
      throw Exception('Firestore error while changing currency: ${e.message}');
    } catch (e) {
      debugPrint('[CurrencyRepository] setBaseCurrency unexpected error: $e');
      throw Exception('Unexpected error while changing currency: $e');
    }
  }
}
