import '../models/wallet_model.dart';

abstract class WalletRepository {
  Future<String> addWallet(WalletModel wallet);
  Future<void> deleteWallet(String id);
  Stream<List<WalletModel>> getWalletsStream();
}
