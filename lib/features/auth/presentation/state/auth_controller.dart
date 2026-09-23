import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constant/shared_prefs_keys.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../../core/providers/shared_prefs_provider.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/error/auth_exception.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

/// The authenticated user as a pure domain entity, or `null` when signed out.
///
/// Recomputed whenever the auth session changes so consumers never read a
/// stale cached value after sign-in/out.
final currentUserProvider = Provider<UserModel?>((ref) {
  ref.watch(authStateChangesProvider);
  return ref.watch(authRepositoryProvider).currentUser;
});


final isBiometricAvailableProvider = Provider.autoDispose<bool>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return prefs.getBool(SharedPrefsKeys.isBiometricEnabledKey) ?? false;
});

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<void> {
  late AuthRepositoryInterface _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.watch(authRepositoryProvider);
  }

  Future<void> login(
    String email,
    String password, {
    required bool isBiometricOptIn,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => _repository.signIn(email, password),
    );

    if (!result.hasError) {
      await _handlePostAuth(
        isBiometricOptIn: isBiometricOptIn,
      );
    }

    state = result;
  }

  Future<void> unlockWithBiometrics() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final biometricService = ref.read(biometricServiceProvider);
      final authenticated = await biometricService.authenticate();
      if (!authenticated) {
        throw AppAuthException(AuthErrorType.biometricDenied);
      }
      
      if (_repository.currentUser == null) {
        throw AppAuthException(AuthErrorType.sessionExpired);
      }
    });
  }

  Future<void> register(
    String fullName,
    String email,
    String password, {
    required bool isBiometricOptIn,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => _repository.signUp(fullName, email, password),
    );

    if (!result.hasError) {
      await _handlePostAuth(
        isBiometricOptIn: isBiometricOptIn,
      );
    }

    state = result;
  }

  Future<void> loginWithGoogle({required bool isGoogleAuthTriggered}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => _repository.signInWithGoogle());

    if (!result.hasError) {
      await _handlePostAuth(
        isBiometricOptIn: false,
        isGoogleAuthTriggered: isGoogleAuthTriggered,
      );
    }

    state = result;
  }

  /// Signs out of the repository session and clears the biometric-unlock
  /// preference so the lock screen is not re-armed for the next session.
  Future<void> signOut() async {
    await _repository.signOut();
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setBool(SharedPrefsKeys.isBiometricEnabledKey, false);
  }

  Future<void> _handlePostAuth({
    required bool isBiometricOptIn,
    bool isGoogleAuthTriggered = false,
  }) async {
    final prefs = ref.read(sharedPrefsProvider);
    final biometricService = ref.read(biometricServiceProvider);

    if (isBiometricOptIn || isGoogleAuthTriggered) {
      final authenticated = await biometricService.authenticate();
      await prefs.setBool(SharedPrefsKeys.isBiometricEnabledKey, authenticated);
    } else {
      await prefs.setBool(SharedPrefsKeys.isBiometricEnabledKey, false);
    }
  }
}
