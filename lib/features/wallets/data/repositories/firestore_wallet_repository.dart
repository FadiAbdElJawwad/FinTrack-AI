import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/models/wallet_model.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_datasource.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return FirestoreWalletRepository(ref.watch(walletRemoteDataSourceProvider));
});

/// Implements [WalletRepository] on top of [WalletRemoteDataSource].
///
/// Owns domain rules (delete guards) and exception translation; Firestore
/// specifics live in the data source.
class FirestoreWalletRepository implements WalletRepository {
  FirestoreWalletRepository(this._dataSource);

  final WalletRemoteDataSource _dataSource;

  @override
  Future<String> addWallet(WalletModel wallet) async {
    try {
      return await _dataSource.create(wallet.toJson());
    } on FirebaseException catch (e) {
      throw Exception('Firestore error while adding wallet: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while adding wallet: $e');
    }
  }

  @override
  Future<void> deleteWallet(String id) async {
    try {
      final wallets = await _dataSource.fetchAll();
      if (wallets.length <= 1) {
        throw Exception('Cannot delete the only wallet.');
      }
      final wallet = wallets.firstWhere((w) => w.id == id);
      if (wallet.isDefault) {
        throw Exception('Cannot delete the default wallet.');
      }
      await _dataSource.delete(id);
    } on FirebaseException catch (e) {
      throw Exception('Firestore error while deleting wallet: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while deleting wallet: $e');
    }
  }

  @override
  Stream<List<WalletModel>> getWalletsStream() {
    try {
      return _dataSource.watchAll().map(
            (docs) => docs.map(WalletModel.fromJson).toList(),
          );
    } on FirebaseException catch (e) {
      throw Exception('Firestore error while streaming wallets: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while streaming wallets: $e');
    }
  }
}