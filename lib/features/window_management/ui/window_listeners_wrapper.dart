import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../../features.dart';

class WindowListenersWrapper extends ConsumerWidget {
  const WindowListenersWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Maintains the `currentRouteUriProvider` active.
    ref.watch(currentRouteUriProvider);

    /// Syncs the TypeOfWindow with the current route.
    ref.watch(typeOfWindowNavigationListener);

    /// Listens to the TypeOfWindow and updates the
    /// window settings and navigates if needed.
    ref.watch(typeOfWindowRouteAndWindowSettingsListenerProvider);

    if (!AppConstants.isDesktopPlatform) {
      return child;
    }

    /// Listens to the `randomEmojiProvider`
    /// and updates the tray icon message if needed.
    ref.watch(trayIconUpdaterListenerProvider);

    /// Keeps the `windowOptionsProvider` active.
    ref.watch(windowOptionsProvider);

    return child;
  }
}
