import '../models/wallet_model.dart';

abstract class WalletRepository {
  Future<String> addWallet(WalletModel wallet);

  /// Creates or overwrites the wallet stored under the deterministic [id].
  Future<void> upsertWallet(String id, WalletModel wallet);
  Future<void> deleteWallet(String id);
  Stream<List<WalletModel>> getWalletsStream();
}
