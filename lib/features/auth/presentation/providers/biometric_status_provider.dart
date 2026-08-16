import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/services/secure_storage_service.dart';

final hasCredentialsProvider = FutureProvider.autoDispose<bool>((ref) async {
  final credentials = await ref.watch(secureStorageServiceProvider).getCredentials();
  return credentials != null;
});
