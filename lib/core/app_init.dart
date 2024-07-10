import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/features.dart';
import 'core.dart';

/// A future that is loaded as an initialization step
/// of the [BuzzBuzzerApp].
///
/// When loading, the [AppInitialLoader] is shown.
final initApplicationFuture = FutureProvider<void>(
  (ref) async => await _initApplication(ref),
);

Future<void> _initApplication(Ref ref) async {
  if (!AppConstants.isDesktopPlatform) {
    return;
  }
  await _initTrayManager(ref);
  await _initWindowManager(ref);
}

/// Initialize the window management service and add its listener.
Future<void> _initWindowManager(Ref ref) async {
  // Added window event listener to observe window events
  // from the very start of our application.
  //
  // This will also enable users to hide the window
  // on the outside click on Windows.
  ref.read(windowManagerProvider).addListener(ref.read(windowListenerProvider));

  final windowService = ref.read(windowManagementServiceProvider);

  await windowService.setupWindowManagement();
}

/// Initialize the `trayManager` and add its listener.
Future<void> _initTrayManager(Ref ref) async {
  final trayManager = ref.read(trayManagerProvider);

  // Initialize the type of tray icon controller.
  await ref.read(trayIconTypeProvider.notifier).init();

  final trayIconListener = ref.read(trayIconListenerProvider);
  trayManager.addListener(trayIconListener);
}
