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

  Future<void> runIfNeeded() async {
    final wallets = await repository.getWalletsStream().first;

    if (wallets.isEmpty) {
      final cashWallet = WalletModel(
        name: 'Cash',
        icon: 'payments',
        isDefault: true,
      );
      final walletId = await repository.addWallet(cashWallet);

      final otherWallets = [
        const WalletModel(
          name: 'Bank Account',
          icon: 'account_balance',
          isDefault: false,
        ),
        const WalletModel(
          name: 'PayPal',
          icon: 'account_balance_wallet',
          isDefault: false,
        ),
        const WalletModel(
          name: 'Other',
          icon: 'more_horiz',
          isDefault: false,
        ),
      ];

      for (final w in otherWallets) {
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
      final otherWallets = [
        const WalletModel(
          name: 'Bank Account',
          icon: 'account_balance',
          isDefault: false,
        ),
        const WalletModel(
          name: 'PayPal',
          icon: 'account_balance_wallet',
          isDefault: false,
        ),
        const WalletModel(
          name: 'Other',
          icon: 'more_horiz',
          isDefault: false,
        ),
      ];

      for (final w in otherWallets) {
        await repository.addWallet(w);
      }
    }
  }
}