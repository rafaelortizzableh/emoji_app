import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../../features.dart';

final typeOfWindowNavigationListener = Provider.autoDispose<void>(
  (ref) {
    return _listener(ref);
  },
);

void _listener(AutoDisposeRef ref) {
  ref.listen(
    currentRouteUriProvider,
    (previous, next) {
      _syncTypeOfWindowWithCurrentRoute(ref);
    },
  );
}

void _syncTypeOfWindowWithCurrentRoute(AutoDisposeRef ref) {
  final currentRoute = ref.read(currentRouteUriProvider);
  final typeOfWindow = ref.read(typeOfWindowProvider).typeOfWindow;

  if (currentRoute.toString() == typeOfWindow.routePath) return;

  final newTypeOfWindow = TypeOfWindow.fromRoutePath(currentRoute.toString());
  if (newTypeOfWindow == typeOfWindow) return;

  switch (newTypeOfWindow) {
    case TypeOfWindow.home:
      ref.read(typeOfWindowProvider.notifier).setHomeWindow();
      break;
    case TypeOfWindow.settings:
      ref.read(typeOfWindowProvider.notifier).setSettingsWindow();
      break;
    case TypeOfWindow.emojiRain:
      ref.read(typeOfWindowProvider.notifier).setEmojiRainWindow();
      break;
    case TypeOfWindow.notification:
    case TypeOfWindow.selectedTeammate:
      break;
  }
}
