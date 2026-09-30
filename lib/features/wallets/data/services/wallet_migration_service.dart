import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../domain/models/wallet_model.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../repositories/firestore_wallet_repository.dart';

final walletMigrationProvider = Provider<WalletMigrationService>((ref) {
  return WalletMigrationService(
    repository: ref.watch(walletRepositoryProvider),
    firestore: ref.watch(firestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
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

/// Seeds default wallets on first launch and backfills legacy transactions
/// that predate wallet support.
///
/// Relocated verbatim from the presentation-layer `WalletController` so that
/// persistence-integrity logic lives in the data layer and no platform SDK
/// types (Firestore/Auth) reach the UI.
class WalletMigrationService {
  WalletMigrationService({
    required this.repository,
    required this.firestore,
    required this.auth,
  });

  final WalletRepository repository;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  static const List<WalletModel> _defaultSecondaryWallets = [
    WalletModel(
      name: 'Bank Account',
      icon: 'account_balance',
      isDefault: false,
    ),
    WalletModel(
      name: 'PayPal',
      icon: 'account_balance_wallet',
      isDefault: false,
    ),
    WalletModel(name: 'Other', icon: 'more_horiz', isDefault: false),
  ];

  /// Wraps [_migrate] so Firebase errors surface as [WalletException].
  Future<void> runIfNeeded() async {
    try {
      await _migrate();
    } catch (e, st) {
      Error.throwWithStackTrace(translateWalletError(e), st);
    }
  }

  Future<void> _migrate() async {
    final wallets = await repository.getWalletsStream().first;

    if (wallets.isEmpty) {
      final cashWallet = WalletModel(
        name: 'Cash',
        icon: 'payments',
        isDefault: true,
      );
      final walletId = await repository.addWallet(cashWallet);

      for (final w in _defaultSecondaryWallets) {
        await repository.addWallet(w);
      }

      final user = auth.currentUser;
      if (user == null) return;

      final txsRef = firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions');
      final snapshot = await txsRef.get();

      final chunks = <List<QueryDocumentSnapshot<Map<String, dynamic>>>>[];
      var currentChunk = <QueryDocumentSnapshot<Map<String, dynamic>>>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        if (!data.containsKey('walletId') ||
            data['walletId'] == null ||
            data['walletId'] == '') {
          currentChunk.add(doc);
          if (currentChunk.length == 500) {
            chunks.add(currentChunk);
            currentChunk = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
          }
        }
      }
      if (currentChunk.isNotEmpty) {
        chunks.add(currentChunk);
      }

      for (final chunk in chunks) {
        final batch = firestore.batch();
        for (final doc in chunk) {
          batch.update(doc.reference, {'walletId': walletId});
        }
        await batch.commit();
      }
    } else if (wallets.length == 1 &&
        wallets.first.name == 'Cash' &&
        wallets.first.isDefault == true) {
      for (final w in _defaultSecondaryWallets) {
        await repository.addWallet(w);
      }
    }
  }
}
