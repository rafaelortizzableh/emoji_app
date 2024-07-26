import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors, Size;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart' hide windowManager;
import 'package:window_size/window_size.dart' as window_size;

import '../../../core/core.dart';
import '../../features.dart';

final _resizeNotificationsWindowBasedOnNotificationsProvider =
    Provider.autoDispose<void>(
  (ref) {
    final typeOfWindow = ref.watch(
      typeOfWindowProvider.select(
        (state) => state.typeOfWindow,
      ),
    );
    if (typeOfWindow != TypeOfWindow.notification) return;

    // If the current window is a notification window,
    // listen to notifications updates and resize the window
    // to fit the number of notifications.
    // ref.listen(
    //   notificationsProvider,
    //   (_, notifications) async {
    //     await _setNotificationsWindowSize(
    //       ref: ref,
    //       notifications: notifications,
    //     );
    //   },
    // );
  },
);

Future<void> typeOfWindowSizeHandler({
  required Ref ref,
  required TypeOfWindow typeOfWindow,
}) async {
  final windowManager = ref.read(windowManagerProvider);
  final windowOptionsController = ref.read(windowOptionsProvider.notifier);
  final windowManagementService = ref.read(windowManagementServiceProvider);
  final isWindows = defaultTargetPlatform == TargetPlatform.windows;

  switch (typeOfWindow) {
    case TypeOfWindow.settings:
      await _handleSettingsWindowResize(
        windowManager: windowManager,
        windowOptionsController: windowOptionsController,
        isWindows: isWindows,
      );
      break;
    case TypeOfWindow.notification:
      await _handleNotificationsResize(
        windowManager: windowManager,
        windowManagementService: windowManagementService,
        isWindows: isWindows,
        ref: ref,
      );
      break;
    case TypeOfWindow.home:
      await _handleHomeWindowResize(
        windowManager: windowManager,
        windowManagementService: windowManagementService,
        isWindows: isWindows,
      );
      break;

    case TypeOfWindow.emojiRain:
      await _handleEmojiRainWindowResize(
        windowManager: windowManager,
        windowManagementService: windowManagementService,
        windowOptionsController: windowOptionsController,
      );
      break;
    case TypeOfWindow.empty:
      break;
    case TypeOfWindow.selectedTeammate:
      // await _handleTeammateSelectedWindowResize(
      //   windowManager: windowManager,
      //   windowOptionsController: windowOptionsController,
      //   windowManagementService: windowManagementService,
      //   typeOfWindowController: ref.read(typeOfWindowProvider.notifier),
      //   isWindows: isWindows,
      // );
      break;
  }
}

Future<void> _handleNotificationsResize({
  required WindowManager windowManager,
  required Ref ref,
  required WindowManagementService windowManagementService,
  required bool isWindows,
}) async {
  // Scheduling a microtask so that the [TypeOfWindowState]
  // is updated before the notifications are fetched.
  await Future.microtask(() {});

  // Set initial notifications window size when the state changes.
  // final notifications = ref.read(appNotificationsProvider);
  // await _setNotificationsWindowSize(ref: ref, notifications: notifications);

  // Listen to notifications updates to change the size as needed.
  ref.read(_resizeNotificationsWindowBasedOnNotificationsProvider);
}

Future<void> _handleHomeWindowResize({
  required WindowManager windowManager,
  required WindowManagementService windowManagementService,
  required bool isWindows,
}) async {
  // Due to an issue with flickering when resizing/repositioning the window on Windows,
  // the window has the same size and position for both [TypeOfWindow.home] and
  // [TypeOfWindow.selectedTeammate] on Windows.

  final position = isWindows
      ? await windowManagementService.getDefaultPosition()
      : await windowManagementService
          .getPositionBySize(AppConstants.mainWindowDimensions);

  await windowManager.setBounds(
    null,
    size: AppConstants.defaultAppDimensions,
    position: position,
  );
}

Future<void> _handleEmojiRainWindowResize({
  required WindowManager windowManager,
  required WindowManagementService windowManagementService,
  required WindowOptionsController windowOptionsController,
}) async {
  final size = (await window_size.getCurrentScreen())?.visibleFrame.size ??
      AppConstants.defaultSettingsWindowDimensions;

  await windowManager.setSize(size);

  await Future.microtask(() {});
  await windowManager.center();
  windowOptionsController.updateWindowOptions(
    WindowOptions(
      backgroundColor: Colors.transparent,
      maximumSize: size,
      minimumSize: size,
      size: size,
    ),
  );
}

// Future<void> _handleTeammateSelectedWindowResize({
//   required WindowManager windowManager,
//   required WindowOptionsController windowOptionsController,
//   required WindowManagementService windowManagementService,
//   required TypeOfWindowController typeOfWindowController,
//   required bool isWindows,
// }) async {
//   // Scheduling a microtask so that the [TypeOfWindowState]
//   // is updated before the window is resized.
//   await Future.microtask(() {});

//   // Due to an issue with flickering when resizing/repositioning the window on Windows,
//   // the window has the same size and position for both [TypeOfWindow.home] and
//   // [TypeOfWindow.selectedTeammate] on Windows.
//   if (isWindows) {
//     typeOfWindowController.toggleIsResizingToSecondWindow(false);
//     return;
//   }

//   final size = _assignTeammateSelectedWindowSize();

//   final position = await getPositionForSelectedTeammateWindow(
//     windowManagementService,
//   );

//   await windowManager.setBounds(
//     null,
//     size: size,
//     position: position,
//   );

//   typeOfWindowController.toggleIsResizingToSecondWindow(false);
// }

Future<void> _handleSettingsWindowResize({
  required WindowManager windowManager,
  required WindowOptionsController windowOptionsController,
  required bool isWindows,
}) async {
  final sizeToSet = await _assignSettingsWindowSize(isWindows: isWindows);
  // To avoid issues with converting between doubles and NSNumbers,
  // the window size is rounded to the nearest double.
  final windowSize = Size(
    sizeToSet.width.roundToDouble(),
    sizeToSet.height.roundToDouble(),
  );
  final maxSize =
      isWindows ? windowSize : AppConstants.defaultMaxSupportedWindowDimensions;

  await Future.wait([
    windowManager.setMinimumSize(windowSize),
    windowManager.setSize(windowSize),
    windowManager.setMaximumSize(maxSize),
  ]);

  await Future.microtask(() {});
  await windowManager.center();
  windowOptionsController.updateWindowOptions(
    WindowOptions(
      backgroundColor: Colors.transparent,
      maximumSize: windowSize,
      minimumSize: windowSize,
      size: windowSize,
    ),
  );
}

Future<Size> _assignSettingsWindowSize({
  required bool isWindows,
}) async {
  // Get the current screen.
  final screen = await window_size.getCurrentScreen();

  // If the screen is null, return the default size.
  if (screen == null) return AppConstants.defaultSettingsWindowDimensions;

  // When on Windows:
  if (isWindows) {
    final scaleFactor = screen.scaleFactor;
    final visibleFrameSize = screen.visibleFrame.size;
    return _assignSettingsSizeForWindows(
      scaleFactor: scaleFactor,
      visibleFrameSize: visibleFrameSize,
    );
  }

  // If the current screen is not null,
  // and the visible frame size is smaller than the default settings size,
  // return a size that is 90% of the visible frame of the screen.
  if (_isVisibleFrameSmallerThanDefaultSettingsWindow(
      screen.visibleFrame.size)) {
    return screen.visibleFrame.size * 0.9;
  }

  // Otherwise, return the default settings size.
  return AppConstants.defaultSettingsWindowDimensions;
}

Size _assignSettingsSizeForWindows({
  required Size visibleFrameSize,
  required double scaleFactor,
}) {
  final normalizedVisibleFrameSize = visibleFrameSize / scaleFactor;
  final visibleFrameSmallerThanDefaultSettingsWindow =
      _isVisibleFrameSmallerThanDefaultSettingsWindow(
    normalizedVisibleFrameSize,
  );

  // If the visible frame is smaller than the default settings size,
  // return a size that is 90% of the visible frame of the screen.
  if (visibleFrameSmallerThanDefaultSettingsWindow) {
    return normalizedVisibleFrameSize * 0.9;
  }

  // Otherwise, return the default settings size.
  return AppConstants.defaultSettingsWindowDimensions;
}

bool _isVisibleFrameSmallerThanDefaultSettingsWindow(Size visibleFrameSize) {
  return visibleFrameSize.isAnyDimensionSmallerThan(
    AppConstants.defaultSettingsWindowDimensions,
  );
}

// Size _assignTeammateSelectedWindowSize() {
//   final widthOfTeammateSelectedWindow =
//       SelectedTeammateWindowWrapper.windowSize.width;
//   final totalWidth = defaultAppDimensions.width +
//       widthOfTeammateSelectedWindow +
//       spacingBetweenWindows;
//   return Size(
//     totalWidth,
//     defaultAppDimensions.height,
//   );
// }

// Future<Offset> getPositionForSelectedTeammateWindow(
//   WindowManagementService windowManagementService,
// ) async {
//   // Calculate the width of the window
//   // so it's centered in the middle
//   // of the tray icon.
//   final secondWindowSize =
//       (SelectedTeammateWindowWrapper.windowSize.width + spacingBetweenWindows) *
//           2;
//   final newWidth = secondWindowSize + mainWindowDimensions.width;

//   final newSize = Size(
//     newWidth,
//     defaultAppDimensions.height,
//   );

//   return await windowManagementService.getPositionBySize(newSize);
// }

// Future<void> _setNotificationsWindowSize({
//   required Ref ref,
//   required Set<AppNotification> notifications,
// }) async {
//   if (notifications.isEmpty) return;
//   final windowManagementService = ref.read(windowManagementServiceProvider);
//   final windowManager = ref.read(windowManagerProvider);
//   final isWindows = ref.read(localPlatformProvider).isWindows;
//   final windowSize = notifications.windowSize(isWindows);
//   final position = await windowManagementService.getPositionBySize(
//     windowSize,
//   );

//   await windowManager.setBounds(
//     null,
//     size: windowSize,
//     position: position,
//   );
// }

// extension on Set<AppNotification> {
//   Size windowSize(bool isWindows) {
//     // Height should be the sum of all the heights
//     // of the notifications and vertical padding
//     // for each notification.
//     const verticalPaddingBetweenNotifications = 4.0;
//     final notificationsHeight = fold<double>(
//           0.0,
//           (previousValue, notification) =>
//               (previousValue + notification.size.height),
//         ) +
//         verticalPaddingBetweenNotifications * (length - 1);

//     // Width should be the max of all the widths
//     // of the notifications.
//     final notificationWindowWidth = fold<double>(
//       0.0,
//       (previousValue, notification) =>
//           max(previousValue, notification.size.width),
//     );

//     // The height of the notifications window
//     // should be the min of the
//     // notifications height and the default app height.
//     final notificationWindowHeight = min(
//       notificationsHeight,
//       defaultAppDimensions.height,
//     );

//     return Size(
//       notificationWindowWidth.roundToDouble(),
//       notificationWindowHeight.roundToDouble(),
//     );
//   }
// }
