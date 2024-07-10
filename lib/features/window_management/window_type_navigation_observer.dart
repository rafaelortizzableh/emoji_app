import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features.dart';

class WindowTypeNavigationObserver extends RouteObserver<PageRoute<dynamic>> {
  WindowTypeNavigationObserver(this._ref);
  final AutoDisposeProviderRef _ref;

  void _updateTypeOfWindow(Route route) {
    final currentType = _ref.read(typeOfWindowProvider).typeOfWindow;
    switch (route.settings.name) {
      case HomePage.routeName:
        if (currentType == TypeOfWindow.home) return;
        _ref.read(windowManagementServiceProvider).showHomeWindow();
        return;
      case SettingsPage.routeName:
        if (currentType == TypeOfWindow.settings) return;
        _ref.read(windowManagementServiceProvider).showSettingsWindow();
        return;
      case EmojiRainPage.routeName:
        if (currentType == TypeOfWindow.emojiRain) return;
        _ref.read(windowManagementServiceProvider).showEmojiRainWindow();
        return;
      default:
        return;
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute == null) return;
    _updateTypeOfWindow(previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _updateTypeOfWindow(route);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _updateTypeOfWindow(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (newRoute == null) return;
    _updateTypeOfWindow(newRoute);
  }
}
