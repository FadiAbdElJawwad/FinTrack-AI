import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repositories/firestore_wallet_repository.dart';
import '../../data/services/wallet_migration_service.dart';
import '../../domain/models/wallet_model.dart';

final walletControllerProvider = StreamNotifierProvider.autoDispose<
  WalletController,
  List<WalletModel>
>(WalletController.new);

class WalletController extends AutoDisposeStreamNotifier<List<WalletModel>> {
  Future<void>? _migrationTask;

  @override
  Stream<List<WalletModel>> build() {
    _migrationTask ??= ref.read(walletMigrationProvider).runIfNeeded();
    return ref.watch(walletRepositoryProvider).getWalletsStream();
  }
}