import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appLockNotifierProvider = Provider<AppLockNotifier>((ref) {
  throw UnimplementedError('appLockNotifierProvider must be overridden');
});

class AppLockNotifier extends ChangeNotifier {
  static const Duration lockTimeout = Duration(seconds: 30);

  bool _isLocked;

  AppLockNotifier({required bool initialLocked}) : _isLocked = initialLocked;

  bool get isLocked => _isLocked;

  void lock() {
    if (!_isLocked) {
      _isLocked = true;
      notifyListeners();
    }
  }

  void unlock() {
    if (_isLocked) {
      _isLocked = false;
      notifyListeners();
    }
  }
}
