import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/error/wallet_exception.dart';
import '../../../auth/presentation/state/auth_controller.dart';
import '../../data/repositories/firestore_wallet_repository.dart';
import '../../data/services/wallet_migration_service.dart';
import '../../domain/models/wallet_model.dart';

final walletControllerProvider =
    StreamNotifierProvider.autoDispose<WalletController, List<WalletModel>>(
      WalletController.new,
    );

class WalletController extends AutoDisposeStreamNotifier<List<WalletModel>> {
  @override
  Stream<List<WalletModel>> build() async* {
    var disposed = false;
    ref.onDispose(() => disposed = true);

    final user = ref.watch(currentUserProvider);
    if (user == null) {
      throw WalletException(WalletErrorType.notAuthenticated);
    }

    final migration = walletMigrationRunProvider(user.uid);
    try {
      await ref.read(migration.future);
    } catch (_) {
      if (!disposed) ref.invalidate(migration);
      rethrow;
    }
    if (disposed) return;

    yield* ref.watch(walletRepositoryProvider).getWalletsStream();
  }
}
