import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_track_ai/core/error/wallet_exception.dart';
import 'package:fin_track_ai/features/wallets/data/datasources/wallet_remote_datasource.dart';
import 'package:fin_track_ai/features/wallets/data/repositories/firestore_wallet_repository.dart';
import 'package:fin_track_ai/features/wallets/domain/models/wallet_model.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeWalletDataSource implements WalletRemoteDataSource {
  Object? createError;
  Object? fetchError;
  Object? deleteError;
  Object? watchBuildError;
  List<({String id, bool isDefault})> existing = [
    (id: 'a', isDefault: true),
    (id: 'b', isDefault: false),
  ];
  int deleteCalls = 0;
  final StreamController<List<Map<String, dynamic>>> controller =
      StreamController<List<Map<String, dynamic>>>();

  @override
  Future<String> create(Map<String, dynamic> data) async {
    if (createError != null) throw createError!;
    return 'new-id';
  }

  @override
  Future<void> upsert(String id, Map<String, dynamic> data) async {}

  @override
  Future<List<({String id, bool isDefault})>> fetchAll() async {
    if (fetchError != null) throw fetchError!;
    return existing;
  }

  @override
  Future<void> delete(String id) async {
    deleteCalls++;
    if (deleteError != null) throw deleteError!;
  }

  @override
  Stream<List<Map<String, dynamic>>> watchAll() {
    if (watchBuildError != null) throw watchBuildError!;
    return controller.stream;
  }
}

FirebaseException firebaseError(String code) =>
    FirebaseException(plugin: 'cloud_firestore', code: code, message: 'raw');

Matcher walletError(WalletErrorType type) =>
    isA<WalletException>().having((e) => e.type, 'type', type);

void main() {
  late FakeWalletDataSource dataSource;
  late FirestoreWalletRepository repo;
  const wallet = WalletModel(name: 'Cash', icon: 'payments');

  setUp(() {
    dataSource = FakeWalletDataSource();
    repo = FirestoreWalletRepository(dataSource);
  });

  const mapping = <String, WalletErrorType>{
    'permission-denied': WalletErrorType.permissionDenied,
    'unavailable': WalletErrorType.networkError,
    'deadline-exceeded': WalletErrorType.networkError,
    'not-found': WalletErrorType.notFound,
    'unauthenticated': WalletErrorType.notAuthenticated,
    'invalid-argument': WalletErrorType.invalidData,
    'failed-precondition': WalletErrorType.invalidData,
    'aborted': WalletErrorType.unknown,
  };

  group('FirestoreWalletRepository error mapping', () {
    mapping.forEach((code, expected) {
      test('addWallet maps $code', () {
        dataSource.createError = firebaseError(code);
        expect(repo.addWallet(wallet), throwsA(walletError(expected)));
      });

      test('deleteWallet maps $code from the datasource', () {
        dataSource.deleteError = firebaseError(code);
        expect(repo.deleteWallet('b'), throwsA(walletError(expected)));
      });
    });

    test('non-Firebase error maps to unknown', () {
      dataSource.createError = StateError('boom');
      expect(
        repo.addWallet(wallet),
        throwsA(walletError(WalletErrorType.unknown)),
      );
    });

    test('typed exception passes through unchanged', () {
      final original = WalletException(WalletErrorType.notAuthenticated);
      dataSource.fetchError = original;
      expect(repo.deleteWallet('b'), throwsA(same(original)));
    });

    test('returns the created id on success', () async {
      expect(await repo.addWallet(wallet), 'new-id');
    });
  });

  group('FirestoreWalletRepository delete guards', () {
    test('deleting the only wallet is invalidData', () async {
      dataSource.existing = [(id: 'a', isDefault: true)];
      await expectLater(
        repo.deleteWallet('a'),
        throwsA(walletError(WalletErrorType.invalidData)),
      );
      expect(dataSource.deleteCalls, 0);
    });

    test('deleting the default wallet is invalidData', () async {
      await expectLater(
        repo.deleteWallet('a'),
        throwsA(walletError(WalletErrorType.invalidData)),
      );
      expect(dataSource.deleteCalls, 0);
    });

    test('deleting an unknown wallet is notFound', () {
      expect(
        repo.deleteWallet('zzz'),
        throwsA(walletError(WalletErrorType.notFound)),
      );
    });

    test('deleting a secondary wallet succeeds', () async {
      await repo.deleteWallet('b');
      expect(dataSource.deleteCalls, 1);
    });
  });

  group('FirestoreWalletRepository stream', () {
    test('translates errors that arrive on the stream', () async {
      final expectation = expectLater(
        repo.getWalletsStream(),
        emitsError(walletError(WalletErrorType.networkError)),
      );
      dataSource.controller.addError(firebaseError('unavailable'));
      await expectation;
    });

    test('translates a synchronous error while building the stream', () {
      dataSource.watchBuildError = firebaseError('unauthenticated');
      expect(
        repo.getWalletsStream,
        throwsA(walletError(WalletErrorType.notAuthenticated)),
      );
    });

    test('maps documents to domain models', () async {
      final expectation = expectLater(
        repo.getWalletsStream(),
        emits(isA<List<WalletModel>>().having((l) => l.single.id, 'id', 'w1')),
      );
      dataSource.controller.add([
        const WalletModel(id: 'w1', name: 'Cash', icon: 'payments').toJson(),
      ]);
      await expectation;
    });
  });
}
