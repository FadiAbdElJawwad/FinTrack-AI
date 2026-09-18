import 'package:hooks_riverpod/hooks_riverpod.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

class SecureStorageService {
  // Storage ready for future secure tokens (e.g. API keys, refresh tokens).
  // Raw user credentials (email/password) have been removed for security.
}
