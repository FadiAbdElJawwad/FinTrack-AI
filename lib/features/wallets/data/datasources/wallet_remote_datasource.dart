import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/error/wallet_exception.dart';
import '../../../../core/providers/firebase_providers.dart';

/// Owns all direct Firestore reads/writes for wallets.
///
/// Repositories consume plain Dart types; Firestore specifics stay inside
/// this class.
final walletRemoteDataSourceProvider = Provider<WalletRemoteDataSource>((ref) {
  return WalletRemoteDataSource(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
  );
});

class WalletRemoteDataSource {
  WalletRemoteDataSource(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw WalletException(
        WalletErrorType.notAuthenticated,
        message: 'User must be logged in to perform wallet operations.',
      );
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _walletsDb =>
      _firestore.collection('users').doc(_userId).collection('wallets');

  /// Creates a document with a Firestore-assigned id and returns it.
  Future<String> create(Map<String, dynamic> data) async {
    final docRef = _walletsDb.doc();
    await docRef.set({...data, 'id': docRef.id});
    return docRef.id;
  }

  /// Lightweight read-model used by the repository for delete-guard rules.
  Future<List<({String id, bool isDefault})>> fetchAll() async {
    final snapshot = await _walletsDb.get();
    return snapshot.docs
        .map((doc) => (id: doc.id, isDefault: doc.data()['isDefault'] == true))
        .toList();
  }

  Future<void> delete(String id) => _walletsDb.doc(id).delete();

  /// Streams raw document maps as stored on Firestore.
  Stream<List<Map<String, dynamic>>> watchAll() {
    return _walletsDb.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }
}
