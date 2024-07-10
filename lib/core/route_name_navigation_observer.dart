import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/features.dart';

final currentRouteNameProvider = StateProvider.autoDispose<String>(
  (ref) => HomePage.routePath,
);

class RouteNameNavigationObserver extends RouteObserver<PageRoute<dynamic>> {
  RouteNameNavigationObserver(this._ref);
  final AutoDisposeProviderRef _ref;

  void _updateRouteName(Route route) {
    final updatedRouteName = route.settings.name;
    final currentRouteName = _ref.read(currentRouteNameProvider);
    if (currentRouteName == updatedRouteName) return;
    if (updatedRouteName == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ref.read(currentRouteNameProvider.notifier).state = updatedRouteName;
    });
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _updateRouteName(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    if (previousRoute == null) return;
    _updateRouteName(previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _updateRouteName(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute == null) return;
    _updateRouteName(newRoute);
  }
}
