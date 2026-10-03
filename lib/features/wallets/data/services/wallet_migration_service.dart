import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/models/wallet_model.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../repositories/firestore_wallet_repository.dart';

final walletMigrationProvider = Provider<WalletMigrationService>((ref) {
  return WalletMigrationService(
    repository: ref.watch(walletRepositoryProvider),
  );
});

/// Runs [WalletMigrationService.runIfNeeded] at most once per uid per app
/// process.
///
/// Deliberately not autoDispose: the result must survive controller dispose
/// and rebuild. Consumers must `ref.read(provider(uid).future)` and, on
/// failure, `ref.invalidate(provider(uid))` so the next rebuild retries.
final walletMigrationRunProvider = FutureProvider.family<void, String>((
  ref,
  uid,
) {
  return ref.read(walletMigrationProvider).runIfNeeded();
});

/// Seeds the default wallets on first launch.
///
/// Idempotent: every default wallet has a deterministic document id, so a
/// repeated or concurrent run (second device, retry) overwrites the same
/// documents instead of creating duplicates. Talks only to
/// [WalletRepository]; no Firestore or Auth types.
class WalletMigrationService {
  WalletMigrationService({required this.repository});

  final WalletRepository repository;

  static const String cashWalletId = 'cash';

  static const WalletModel _cashWallet = WalletModel(
    name: 'Cash',
    icon: 'payments',
    isDefault: true,
  );

  static const Map<String, WalletModel> _defaultSecondaryWallets = {
    'bank': WalletModel(
      name: 'Bank Account',
      icon: 'account_balance',
      isDefault: false,
    ),
    'paypal': WalletModel(
      name: 'PayPal',
      icon: 'account_balance_wallet',
      isDefault: false,
    ),
    'other': WalletModel(name: 'Other', icon: 'more_horiz', isDefault: false),
  };

  /// Wraps [_seed] so Firebase errors surface as typed wallet exceptions.
  Future<void> runIfNeeded() async {
    try {
      await _seed();
    } catch (e, st) {
      Error.throwWithStackTrace(translateWalletError(e), st);
    }
  }

  Future<void> _seed() async {
    final wallets = await repository.getWalletsStream().first;

    if (wallets.isEmpty) {
      await repository.upsertWallet(cashWalletId, _cashWallet);
      await _upsertSecondaryWallets();
    } else if (wallets.length == 1 &&
        wallets.first.name == 'Cash' &&
        wallets.first.isDefault == true) {
      await _upsertSecondaryWallets();
    }
  }

  Future<void> _upsertSecondaryWallets() async {
    for (final MapEntry(key: id, value: wallet)
        in _defaultSecondaryWallets.entries) {
      await repository.upsertWallet(id, wallet);
    }
  }
}
