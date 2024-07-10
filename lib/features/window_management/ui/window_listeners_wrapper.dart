import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../../features.dart';

class WindowListenersWrapper extends HookConsumerWidget {
  const WindowListenersWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!AppConstants.isDesktopPlatform) {
      return child;
    }
    final goRouter = ref.watch(routerProvider);
    final currentRouteInfo =
        useValueListenable(goRouter.routeInformationProvider);

    ref.watch(trayIconUpdaterListenerProvider);
    ref.watch(windowOptionsProvider);
    ref.watch(typeOfWindowSizeListenerProvider);
    ref.watch(popDialogsOnWindowChangedListenerProvider);
    ref.watch(currentRouteNameProvider);
    ref.listen<TypeOfWindow>(
      typeOfWindowProvider.select((tps) => tps.typeOfWindow),
      (previous, next) {
        final currentRoutePath = currentRouteInfo.uri;

        if (next.routePath == currentRoutePath.path) return;
        goRouter.goNamed(next.routeName);
      },
    );

    return child;
  }
}
