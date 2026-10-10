import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Time source, overridable in tests.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
