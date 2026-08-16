import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constant/shared_prefs_keys.dart';
import '../../../../core/providers/shared_prefs_provider.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/repositories/auth_repository.dart';

final authControllerProvider = StateNotifierProvider.autoDispose<AuthController, AsyncValue<void>>((ref) {
  return AuthController(
    ref.watch(authRepositoryProvider),
    ref,
  );
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthController(this._repository, this._ref) : super(const AsyncData(null));

  Future<void> login(String email, String password, {required bool isBiometricOptIn}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => _repository.signIn(email, password));
    
    if (!result.hasError) {
      await _handlePostAuth(isBiometricOptIn: isBiometricOptIn, email: email, password: password);
    }
    
    state = result;
  }

  Future<void> loginWithBiometrics() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.biometricSignIn());
  }

  Future<void> register(String fullName, String email, String password, {required bool isBiometricOptIn}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => _repository.signUp(fullName, email, password));
    
    if (!result.hasError) {
      await _handlePostAuth(isBiometricOptIn: isBiometricOptIn, email: email, password: password);
    }
    
    state = result;
  }

  Future<void> loginWithGoogle({required bool isGoogleAuthTriggered}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() => _repository.signInWithGoogle());
    
    if (!result.hasError) {
      await _handlePostAuth(isBiometricOptIn: false, isGoogleAuthTriggered: isGoogleAuthTriggered);
    }
    
    state = result;
  }

  Future<void> _handlePostAuth({
    required bool isBiometricOptIn,
    bool isGoogleAuthTriggered = false,
    String? email,
    String? password,
  }) async {
    final prefs = _ref.read(sharedPrefsProvider);
    final biometricService = _ref.read(biometricServiceProvider);

    if (isBiometricOptIn || isGoogleAuthTriggered) {
      final authenticated = await biometricService.authenticate();
      await prefs.setBool(SharedPrefsKeys.isBiometricEnabledKey, authenticated);

      if (authenticated && isBiometricOptIn && email != null && password != null) {
        await _ref.read(secureStorageServiceProvider).saveCredentials(email, password);
      }
    } else {
      await prefs.setBool(SharedPrefsKeys.isBiometricEnabledKey, false);
    }
  }
}
