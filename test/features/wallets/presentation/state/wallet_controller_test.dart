import 'dart:async';

import 'package:fin_track_ai/core/error/wallet_exception.dart';
import 'package:fin_track_ai/features/auth/domain/models/user_model.dart';
import 'package:fin_track_ai/features/auth/presentation/state/auth_controller.dart';
import 'package:fin_track_ai/features/wallets/data/repositories/firestore_wallet_repository.dart';
import 'package:fin_track_ai/features/wallets/data/services/wallet_migration_service.dart';
import 'package:fin_track_ai/features/wallets/domain/models/wallet_model.dart';
import 'package:fin_track_ai/features/wallets/domain/repositories/wallet_repository.dart';
import 'package:fin_track_ai/features/wallets/presentation/state/wallet_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FakeWalletRepo implements WalletRepository {
  @override
  Future<String> addWallet(WalletModel wallet) async => 'id';

  @override
  Future<void> deleteWallet(String id) async {}

  @override
  Stream<List<WalletModel>> getWalletsStream() => Stream.value([
    const WalletModel(id: 'w1', name: 'Cash', icon: 'payments'),
  ]);
}

class FakeMigration extends Fake implements WalletMigrationService {
  FakeMigration({this.failFirstCalls = 0});

  int failFirstCalls;
  int calls = 0;

  @override
  Future<void> runIfNeeded() async {
    calls++;
    if (calls <= failFirstCalls) {
      throw WalletException(WalletErrorType.networkError);
    }
  }
}

const user = UserModel(uid: 'u1', email: 'a@b.c', fullName: 'A B');

ProviderContainer makeContainer(
  FakeMigration migration, {
  UserModel? who = user,
}) {
  final container = ProviderContainer(
    overrides: [
      currentUserProvider.overrideWithValue(who),
      walletRepositoryProvider.overrideWithValue(FakeWalletRepo()),
      walletMigrationProvider.overrideWithValue(migration),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> settle() => Future<void>.delayed(Duration.zero);

void main() {
  group('WalletController migration', () {
    test('emits wallets after the migration completed', () async {
      final migration = FakeMigration();
      final container = makeContainer(migration);
      container.listen(walletControllerProvider, (_, _) {});

      final wallets = await container.read(walletControllerProvider.future);

      expect(wallets.single.id, 'w1');
      expect(migration.calls, 1);
    });

    test(
      'runs exactly once across dispose and re-listen for one uid',
      () async {
        final migration = FakeMigration();
        final container = makeContainer(migration);

        var sub = container.listen(walletControllerProvider, (_, _) {});
        await container.read(walletControllerProvider.future);
        sub.close();
        await settle();

        sub = container.listen(walletControllerProvider, (_, _) {});
        await container.read(walletControllerProvider.future);
        sub.close();
        await settle();

        sub = container.listen(walletControllerProvider, (_, _) {});
        await container.read(walletControllerProvider.future);

        expect(migration.calls, 1);
      },
    );

    test('a failed migration surfaces as AsyncError', () async {
      final migration = FakeMigration(failFirstCalls: 1);
      final container = makeContainer(migration);
      container.listen(walletControllerProvider, (_, _) {});

      await expectLater(
        container.read(walletControllerProvider.future),
        throwsA(isA<WalletException>()),
      );

      final state = container.read(walletControllerProvider);
      expect(state, isA<AsyncError<List<WalletModel>>>());
      expect(
        (state.error! as WalletException).type,
        WalletErrorType.networkError,
      );
    });

    test('a failed migration is retried on the next rebuild', () async {
      final migration = FakeMigration(failFirstCalls: 1);
      final container = makeContainer(migration);

      var sub = container.listen(walletControllerProvider, (_, _) {});
      await expectLater(
        container.read(walletControllerProvider.future),
        throwsA(isA<WalletException>()),
      );
      sub.close();
      await settle();

      sub = container.listen(walletControllerProvider, (_, _) {});
      final wallets = await container.read(walletControllerProvider.future);

      expect(wallets.single.id, 'w1');
      expect(migration.calls, 2);
    });

    test('a different uid runs its own migration', () async {
      final migration = FakeMigration();
      final container = makeContainer(migration);
      container.listen(walletControllerProvider, (_, _) {});
      await container.read(walletControllerProvider.future);

      await container.read(walletMigrationRunProvider('other').future);

      expect(migration.calls, 2);
    });

    test('no current user yields notAuthenticated as AsyncError', () async {
      final migration = FakeMigration();
      final container = makeContainer(migration, who: null);
      container.listen(walletControllerProvider, (_, _) {});

      await expectLater(
        container.read(walletControllerProvider.future),
        throwsA(
          isA<WalletException>().having(
            (e) => e.type,
            'type',
            WalletErrorType.notAuthenticated,
          ),
        ),
      );
      expect(migration.calls, 0);
    });
  });
}
