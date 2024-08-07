import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart' hide windowManager;

import '../../core/core.dart';
import '../features.dart';

abstract class WindowManagementService {
  WindowManagementService(this.ref);

  final Ref ref;

  static final fallbackDxPosition =
      (720.0 - AppConstants.defaultAppDimensions.width);
  static const fallbackDyPosition = 20.0;

  Future<void> centerWindow() async {
    return await ref.read(windowManagerProvider).center();
  }

  /// Returns the default position of the app window.
  Future<Offset> getDefaultPosition();

  Future<void> setDefaultPosition() async {
    final position = await getDefaultPosition();
    await setPosition(position);
  }

  Future<Offset> getPositionBySize(Size windowSize);

  Future<void> resetWindowToOriginalSettings({
    bool shouldCloseCurrentWindow = false,
    bool isFromNotificationBanner = false,
  });

  Future<void> closeAndResizeWindow(
    Size windowSize, {
    Offset? newPosition,
  });

  Future<void> showHomeWindow();

  Future<void> showSettingsWindow();

  Future<void> showEmojiRainWindow();

  Future<void> showPopup();

  Future<void> setupWindowManagement();

  void handleShowWindowRequest() {
    // Logging Analytics event for window show.
    //
    // Logged when the app gets shown, not when it's hidden.
    // Debounce the event to avoid logging it multiple times.
    ref.read(analyticsServiceProvider).emitEvent('app_opened', {});
  }

  /// Allows the user or the system to resize the window as needed.
  ///
  /// Needed to allow maximazing the settings window.
  void setWindowResizable(bool isResizable) {
    ref.read(windowManagerProvider).setResizable(isResizable);
  }

  void setWindowVisibleOnAllWorkspaces(bool visibleOnAllWorkspaces) {
    ref
        .read(windowManagerProvider)
        .setVisibleOnAllWorkspaces(visibleOnAllWorkspaces);
  }

  /// Shows or hides the window buttons as needed.
  ///
  /// Used when showing the main window, settings window or popups.
  Future<void> toggleWindowButtonsVisibility(bool buttonsShown) async {
    await ref.read(windowManagerProvider).setTitleBarStyle(
          TitleBarStyle.hidden,
          windowButtonVisibility: buttonsShown,
        );

    // Setting the title bar style updates the window's shadow.
    // We need to remove the shadow again here.
    await ref.read(windowManagerProvider).setHasShadow(false);
  }

  /// Modifies the visibility settings of application windows.
  ///
  /// Used when showing the main window, settings window or popups.
  void modifyVisibilitySettings({
    bool? hideOnOutsideClick,
    bool? shouldRemainOnTop,
    bool? isClosable,
  }) {
    final windowManager = ref.read(windowManagerProvider);

    if (hideOnOutsideClick != null) {
      windowManager.setHideOnDeactivate(hideOnOutsideClick);
    }

    if (shouldRemainOnTop != null) {
      windowManager.setAlwaysOnTop(shouldRemainOnTop);
    }

    if (isClosable != null) {
      windowManager.setClosable(isClosable);
    }
  }

  Future<void> setPosition(Offset position) async {
    await ref.read(windowManagerProvider).setPosition(position);
  }

  Future<void> setAllSizes(Size size) {
    final windowManager = ref.read(windowManagerProvider);

    return Future.wait([
      windowManager.setMinimumSize(size),
      windowManager.setMaximumSize(size),
      windowManager.setSize(size),
    ]);
  }

  /// Hides the currently visible window.
  void hideWindow() {
    ref.read(windowManagerProvider)
      ..blur
      ..hide();
  }

  /// Hides the currently visible window from tray.
  ///
  /// Returns true if window gets hidden.
  /// Returns false if window need to be visible.
  Future<bool> hideWindowFromTray() async {
    final windowManager = ref.read(windowManagerProvider);
    final isWindows = defaultTargetPlatform == TargetPlatform.windows;

    // This method(isHideWindowOnDeactivate()) from WindowManager
    // is only applicable for Windows OS
    // for Mac OS, it will default false.
    final isHideWindowOnDeactivate =
        isWindows ? await windowManager.isHideWindowOnDeactivate() : false;

    // This method(isHiddenOnBlur()) from WindowManager
    // is only applicable for Windows OS
    // for Mac OS, it will default false.
    final isHiddenOnBlur =
        isWindows ? await windowManager.isHiddenOnBlur() : false;

    if (isWindows && isHiddenOnBlur && isHideWindowOnDeactivate) {
      // Here we are checking for, window is hidden or not
      // when isHideOnDeactivate is true
      // and if its hidden then there is no need to hide again
      // and we are resetting it to false.
      await windowManager.setHiddenOnBlur(hiddenOnBlur: false);
      return true;
    } else if (await isWindowVisible()) {
      // This Code will works for both platforms
      // and hide window accordingly.

      windowManager
        ..blur
        ..hide();

      return true;
    }

    return false;
  }

  /// Returns true if the app is in the foreground and the window is visible.
  Future<bool> isWindowVisible() async {
    final windowManager = ref.read(windowManagerProvider);
    final appInForeground = await windowManager.isActive();
    final windowIsVisible = await windowManager.isVisible();
    return appInForeground && windowIsVisible;
  }
}
