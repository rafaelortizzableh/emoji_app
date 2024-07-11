import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../../features.dart';

final typeOfWindowRouteAndWindowSettingsListenerProvider =
    Provider.autoDispose<void>(
  (ref) {
    return _listener(ref);
  },
);

void _listener(AutoDisposeProviderRef ref) {
  ref.listen<TypeOfWindow>(
    typeOfWindowProvider.select((tps) => tps.typeOfWindow),
    (previous, nextTypeOfWindow) {
      final currentRoute = ref.read(currentRouteUriProvider);

      typeOfWindowSizeHandler(ref: ref, typeOfWindow: nextTypeOfWindow);
      _updateWindowSettings(ref: ref, typeOfWindow: nextTypeOfWindow);
      _navigateToRoute(
        ref: ref,
        typeOfWindow: nextTypeOfWindow,
        currentRoute: currentRoute,
      );
      _dialogAndOverlayPopper(
        ref: ref,
        previous: previous,
        next: nextTypeOfWindow,
      );
    },
  );
}

void _navigateToRoute({
  required AutoDisposeProviderRef ref,
  required TypeOfWindow typeOfWindow,
  required Uri currentRoute,
}) {
  if (currentRoute.toString() == typeOfWindow.routePath) return;

  final goRouter = ref.read(routerProvider);
  goRouter.go(typeOfWindow.routePath);
}

void _updateWindowSettings({
  required AutoDisposeProviderRef ref,
  required TypeOfWindow typeOfWindow,
}) {
  if (!AppConstants.isDesktopPlatform) return;
  final windowManagementService = ref.read(windowManagementServiceProvider);
  switch (typeOfWindow) {
    case TypeOfWindow.home:
      windowManagementService.showHomeWindow();
      break;
    case TypeOfWindow.settings:
      windowManagementService.showSettingsWindow();
      break;
    case TypeOfWindow.emojiRain:
      windowManagementService.showEmojiRainWindow();
      break;
    case TypeOfWindow.empty:
    case TypeOfWindow.notification:
      windowManagementService.showPopup();
    case TypeOfWindow.selectedTeammate:
      break;
  }
}

/// This listener closes all dialogs when
/// the [TypeOfWindow] changes.
void _dialogAndOverlayPopper({
  required AutoDisposeRef ref,
  required TypeOfWindow? previous,
  required TypeOfWindow next,
}) {
  // Early return if window hasn't changed.
  if (previous == next) return;

  // Getting current Navigation state.
  final currentNavigationState = AppConstants.defaultNavigationKey.currentState;

  // Early return if there's nothing to pop.
  if (currentNavigationState?.canPop() != true) return;

  // Getting current Context from navigation key.
  final buildContext = currentNavigationState?.context;

  // Early return to avoid using the context if it's null.
  if (buildContext == null) return;

  if (next != TypeOfWindow.home) {
    return;
  }

  /// This will close the dialogs when the window type has changed.
  Navigator.of(buildContext).popUntil((route) {
    // Otherwise, dismiss the route.
    return route.isFirst;
  });
}
