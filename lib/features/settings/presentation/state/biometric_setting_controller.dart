import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constant/shared_prefs_keys.dart';
import '../../../../core/providers/shared_prefs_provider.dart';
import '../../../../core/services/biometric_service.dart';

final biometricSettingProvider =
    NotifierProvider.autoDispose<BiometricSettingController, bool>(
      BiometricSettingController.new,
    );

class BiometricSettingController extends AutoDisposeNotifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return prefs.getBool(SharedPrefsKeys.isBiometricEnabledKey) ?? false;
  }

  Future<bool> setEnabled(bool enabled) async {
    final prefs = ref.read(sharedPrefsProvider);

    if (!enabled) {
      await prefs.setBool(SharedPrefsKeys.isBiometricEnabledKey, false);
      state = false;
      return false;
    }

    try {
      final authenticated = await ref
          .read(biometricServiceProvider)
          .authenticate();
      if (authenticated) {
        await prefs.setBool(SharedPrefsKeys.isBiometricEnabledKey, true);
        state = true;
        return true;
      }
    } catch (_) {}

    await prefs.setBool(SharedPrefsKeys.isBiometricEnabledKey, false);
    state = false;
    return false;
  }
}
