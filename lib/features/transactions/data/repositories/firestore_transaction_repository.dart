import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/transaction_model.dart';
import 'transaction_repository.dart';

class FirestoreTransactionRepository implements TransactionRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirestoreTransactionRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

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

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      final docRef = _transactionsDb.doc();
      final txWithId = transaction.copyWith(id: docRef.id);
      await docRef.set(txWithId.toJson());
    } on FirebaseException catch (e) {
      throw Exception('Firestore error while adding transaction: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while adding transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await _transactionsDb.doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception(
        'Firestore error while deleting transaction: ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error while deleting transaction: $e');
    }
  }

  @override
  Stream<List<TransactionModel>> getTransactionsStream() {
    try {
      return _transactionsDb.orderBy('date', descending: true).snapshots().map((
        snapshot,
      ) {
        return snapshot.docs.map((doc) {
          return TransactionModel.fromJson(doc.data());
        }).toList();
      });
    } on FirebaseException catch (e) {
      throw Exception(
        'Firestore error while streaming transactions: ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error while streaming transactions: $e');
    }
  }
}
