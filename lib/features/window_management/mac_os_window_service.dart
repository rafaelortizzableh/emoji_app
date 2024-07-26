import 'dart:async';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart' show WindowOptions;

import '../../core/core.dart';
import '../features.dart';

/// MacOS implementation of [WindowManagementService].
class MacOSWindowManagementService extends WindowManagementService {
  MacOSWindowManagementService(super.ref);

  static const _defaultPadding = 5.0;

  @override
  Future<Offset> getDefaultPosition() async {
    return getPositionBySize(AppConstants.defaultAppDimensions);
  }

  @override
  Future<Offset> getPositionBySize(Size windowSize) async {
    final rect = await ref.read(trayManagerProvider).getBounds();

    final menuIconHorizontalPosition =
        rect?.center.dx ?? WindowManagementService.fallbackDxPosition;
    final menuIconVerticalPosition =
        rect?.bottom ?? WindowManagementService.fallbackDyPosition;

    // Set the position so the icon is above the middle of the window.
    final offset = Offset(
      menuIconHorizontalPosition - (windowSize.width / 2),
      menuIconVerticalPosition + _defaultPadding,
    );
    return offset;
  }

  @override
  Future<void> resetWindowToOriginalSettings({
    bool shouldCloseCurrentWindow = false,
    bool isFromNotificationBanner = false,
  }) async {
    modifyVisibilitySettings(
      hideOnOutsideClick: true,
      shouldRemainOnTop: false,
      isClosable: true,
    );
    if (shouldCloseCurrentWindow) {
      await ref.read(windowManagerProvider).close();
    }

    // Remove Notifications and Settings Widgets
    // NOTE (RO): If we add new windows, they'll need to be closed down here.
    // ref.read(notificationsProvider.notifier).removeAllNotifications();
    // ref.read(settingsProvider.notifier).removeWindow();

    ref.read(windowOptionsProvider.notifier).resetWindowOptions();
    await ref
        .read(windowManagerProvider)
        .setSize(AppConstants.defaultAppDimensions);

    await setDefaultPosition();
  }

  @override
  Future<void> closeAndResizeWindow(
    Size windowSize, {
    Offset? newPosition,
  }) async {
    await ref.read(windowManagerProvider).close();
    // Remove Notifications and Settings Widgets
    // NOTE (RO): If we add new windows, they'll need to be closed down here.
    // ref.read(notificationsProvider.notifier).removeAllNotifications();
    // ref.read(settingsProvider.notifier).removeWindow();

    ref.read(windowOptionsProvider.notifier).updateWindowOptions(WindowOptions(
          backgroundColor: Colors.transparent,
          maximumSize: windowSize,
          minimumSize: windowSize,
        ));

    await ref.read(windowManagerProvider).setSize(windowSize);
    final position = await getPositionBySize(windowSize);
    await setPosition(position);
  }

  @override
  Future<void> setupWindowManagement() async {
    await ref.read(windowManagerProvider).ensureInitialized();

    await ref.read(windowManagerProvider).waitUntilReadyToShow(
      ref.read(windowOptionsProvider),
      () async {
        await Future.wait([
          ref.read(windowManagerProvider).setResizable(false),
          ref.read(windowManagerProvider).setHasShadow(false),
          ref
              .read(windowManagerProvider)
              .setSize(AppConstants.defaultAppDimensions),
        ]);

        // Note (rafaelortizzableh):
        // A delay is added here to ensure that `trayManager`
        // will return the correct bounds the first time
        // its `getBounds` method is called.
        await Future.delayed(const Duration(milliseconds: 500));

        await setDefaultPosition();
        ref.read(typeOfWindowProvider.notifier).setHomeWindow();
        await showHomeWindow();
      },
    );
  }

  @override
  Future<void> showSettingsWindow() async {
    setWindowVisibleOnAllWorkspaces(false);
    setWindowResizable(true);
    await toggleWindowButtonsVisibility(true);

    await centerWindow();

    modifyVisibilitySettings(
      hideOnOutsideClick: false,
      isClosable: true,
      shouldRemainOnTop: false,
    );
    ref.read(typeOfWindowProvider.notifier).setSettingsWindow();
    final isFocused = await ref.read(windowManagerProvider).isFocused();
    if (!isFocused) {
      await ref.read(windowManagerProvider).show();
    }
  }

  @override
  Future<void> showEmojiRainWindow() async {
    setWindowVisibleOnAllWorkspaces(true);
    setWindowResizable(false);
    await toggleWindowButtonsVisibility(false);

    modifyVisibilitySettings(
      hideOnOutsideClick: true,
      isClosable: true,
      shouldRemainOnTop: true,
    );
    ref.read(typeOfWindowProvider.notifier).setEmojiRainWindow();
    await ref.read(windowManagerProvider).show();
  }

  @override
  Future<void> showHomeWindow() async {
    modifyVisibilitySettings(
      hideOnOutsideClick: true,
      shouldRemainOnTop: true,
      isClosable: true,
    );

    handleShowWindowRequest();

    setWindowVisibleOnAllWorkspaces(true);
    setWindowResizable(false);
    await toggleWindowButtonsVisibility(false);

    final isFocused = await ref.read(windowManagerProvider).isFocused();
    if (!isFocused) {
      await ref.read(windowManagerProvider).show();
      await ref.read(windowManagerProvider).focus();
    }
  }

  @override
  Future<void> showPopup() async {
    modifyVisibilitySettings(
      hideOnOutsideClick: false,
      isClosable: false,
      shouldRemainOnTop: true,
    );

    setWindowVisibleOnAllWorkspaces(true);
    setWindowResizable(false);
    unawaited(toggleWindowButtonsVisibility(false));

    unawaited(ref.read(windowManagerProvider).show(inactive: true));
  }
}
