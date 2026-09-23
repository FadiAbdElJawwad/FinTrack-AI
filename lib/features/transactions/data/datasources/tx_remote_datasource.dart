import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';

/// Owns all direct Firestore reads/writes for transactions.
///
/// Repositories stay free of `QuerySnapshot`/`DocumentSnapshot` details; the
/// outer database interface never leaks past this class.
final txRemoteDataSourceProvider = Provider<TxRemoteDataSource>((ref) {
  return TxRemoteDataSource(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
  );
});

class TxRemoteDataSource {
  TxRemoteDataSource(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception(
        'User must be logged in to perform transaction operations.',
      );
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _transactionsDb =>
      _firestore.collection('users').doc(_userId).collection('transactions');

  /// Creates a document with a Firestore-assigned id, embedding the id in
  /// the payload (preserves legacy write behavior).
  Future<void> create(Map<String, dynamic> data) async {
    final docRef = _transactionsDb.doc();
    await docRef.set({...data, 'id': docRef.id});
  }

  Future<void> update(String id, Map<String, dynamic> data) {
    return _transactionsDb.doc(id).update(data);
  }

  Future<void> delete(String id) {
    return _transactionsDb.doc(id).delete();
  }

  /// Streams raw document maps, newest-first, as stored on Firestore.
  Stream<List<Map<String, dynamic>>> watchAll() {
    return _transactionsDb
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}