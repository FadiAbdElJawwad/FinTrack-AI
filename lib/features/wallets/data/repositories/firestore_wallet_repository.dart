import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/error/wallet_exception.dart';
import '../../domain/models/wallet_model.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_datasource.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return FirestoreWalletRepository(ref.watch(walletRemoteDataSourceProvider));
});

/// Translates any error into a [WalletException].
///
/// An already typed exception is returned as-is (never re-wrapped).
/// `FirebaseException.message` is kept for debugging only; it is never shown
/// to users.
WalletException translateWalletError(Object error) {
  if (error is WalletException) return error;
  if (error is FirebaseException) {
    return WalletException(_typeForCode(error.code), message: error.message);
  }
  return WalletException(WalletErrorType.unknown, message: error.toString());
}

WalletErrorType _typeForCode(String code) {
  switch (code) {
    case 'permission-denied':
      return WalletErrorType.permissionDenied;
    case 'unavailable':
    case 'deadline-exceeded':
      return WalletErrorType.networkError;
    case 'not-found':
      return WalletErrorType.notFound;
    case 'unauthenticated':
      return WalletErrorType.notAuthenticated;
    case 'invalid-argument':
    case 'failed-precondition':
      return WalletErrorType.invalidData;
    default:
      return WalletErrorType.unknown;
  }
}

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
    } catch (e, st) {
      Error.throwWithStackTrace(translateWalletError(e), st);
    }
  }

  @override
  Future<void> upsertWallet(String id, WalletModel wallet) async {
    try {
      await _dataSource.upsert(id, wallet.toJson());
    } catch (e, st) {
      Error.throwWithStackTrace(translateWalletError(e), st);
    }
  }

  @override
  Future<void> deleteWallet(String id) async {
    try {
      final wallets = await _dataSource.fetchAll();
      if (wallets.length <= 1) {
        throw WalletException(
          WalletErrorType.invalidData,
          message: 'Cannot delete the only wallet.',
        );
      }
      final wallet = wallets.firstWhere(
        (w) => w.id == id,
        orElse: () => throw WalletException(
          WalletErrorType.notFound,
          message: 'Wallet $id does not exist.',
        ),
      );
      if (wallet.isDefault) {
        throw WalletException(
          WalletErrorType.invalidData,
          message: 'Cannot delete the default wallet.',
        );
      }
      await _dataSource.delete(id);
    } catch (e, st) {
      Error.throwWithStackTrace(translateWalletError(e), st);
    }
  }

  @override
  Stream<List<WalletModel>> getWalletsStream() {
    try {
      return _dataSource
          .watchAll()
          .map((docs) => docs.map(WalletModel.fromJson).toList())
          .transform(
            StreamTransformer<
              List<WalletModel>,
              List<WalletModel>
            >.fromHandlers(
              handleError: (error, stackTrace, sink) {
                sink.addError(translateWalletError(error), stackTrace);
              },
            ),
          );
    } catch (e, st) {
      Error.throwWithStackTrace(translateWalletError(e), st);
    }
  }
}
