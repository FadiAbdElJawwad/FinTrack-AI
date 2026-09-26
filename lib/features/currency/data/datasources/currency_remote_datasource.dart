import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';

/// Owns all direct Firestore reads/writes for the user's base currency and
/// the batched reconversion of their transactions.
final currencyRemoteDataSourceProvider = Provider<CurrencyRemoteDataSource>((ref) {
  return CurrencyRemoteDataSource(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
  );
});

class CurrencyRemoteDataSource {
  CurrencyRemoteDataSource(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  static const int _batchLimit = 500;

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User must be logged in to perform currency operations.');
    }
    return user.uid;
  }

  DocumentReference<Map<String, dynamic>> get _userDoc =>
      _firestore.collection('users').doc(_userId);

  CollectionReference<Map<String, dynamic>> get _transactionsDb =>
      _userDoc.collection('transactions');

  Stream<String> watchBaseCurrency() {
    debugPrint('[CurrencyDataSource] watchBaseCurrency: '
        'attaching listener to users/$_userId');
    final baseCurrency = _userDoc.snapshots().map(
      (snap) => (snap.data()?['baseCurrency'] as String?) ?? 'USD',
    );
    // Listener failures (e.g. PERMISSION_DENIED) arrive asynchronously on the
    // stream, so they are logged here and re-emitted to keep the error visible
    // to Riverpod.
    return baseCurrency.transform(
      StreamTransformer<String, String>.fromHandlers(
        handleError: (error, stackTrace, sink) {
          debugPrint('[CurrencyDataSource] watchBaseCurrency: '
              'listener error on users/$_userId '
              'code=${error is FirebaseException ? error.code : 'n/a'} '
              'error=$error');
          sink.addError(error, stackTrace);
        },
      ),
    );
  }

  /// Multiplies every transaction's `amount` by [rate], chunked at the
  /// Firestore batch-write limit.
  Future<void> reconvertTransactions(double rate) async {
    final snapshot = await _transactionsDb.get();

    final chunks = <List<QueryDocumentSnapshot<Map<String, dynamic>>>>[];
    var currentChunk = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
    for (final doc in snapshot.docs) {
      currentChunk.add(doc);
      if (currentChunk.length == _batchLimit) {
        chunks.add(currentChunk);
        currentChunk = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
      }
    }
    if (currentChunk.isNotEmpty) {
      chunks.add(currentChunk);
    }

    for (var i = 0; i < chunks.length; i++) {
      final chunk = chunks[i];
      final batch = _firestore.batch();
      for (final doc in chunk) {
        final amount = (doc.data()['amount'] as num?)?.toDouble() ?? 0.0;
        batch.update(doc.reference, {'amount': amount * rate});
      }
      debugPrint('[CurrencyDataSource] reconvertTransactions: '
          'committing batch ${i + 1}/${chunks.length} '
          '(${chunk.length} docs) at path '
          'users/$_userId/transactions/*');
      await batch.commit();
      debugPrint('[CurrencyDataSource] reconvertTransactions: '
          'batch ${i + 1}/${chunks.length} committed OK');
    }
  }

  Future<void> setBaseCurrency(String currency) {
    debugPrint('[CurrencyDataSource] setBaseCurrency: '
        'writing baseCurrency=$currency to path users/$_userId');
    return _userDoc.set({'baseCurrency': currency}, SetOptions(merge: true));
  }
}
