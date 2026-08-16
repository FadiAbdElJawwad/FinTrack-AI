import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../routing/router_generator.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return RouteGenerator.router;
});
