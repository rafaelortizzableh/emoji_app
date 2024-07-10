import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tray_manager/tray_manager.dart' hide trayManager;

import '../../core/core.dart';
import '../features.dart';

/// A provider of our custom [TrayClickListener].
final trayIconListenerProvider = Provider.autoDispose<TrayListener>(
  (ref) => TrayClickListener(
    ref,
  ),
);

class TrayClickListener extends TrayListener {
  TrayClickListener(this._ref);

  final Ref _ref;

  @override
  void onTrayIconMouseDown() {
    // Added this condition as in the windows only down method getting called.
    final isWindows = defaultTargetPlatform == TargetPlatform.windows;
    if (isWindows) {
      onTrayIconMouseUp();
    }
  }

  @override
  Future<void> onTrayIconMouseUp() async {
    // Hide the app if the window is currently visible.
    if (await _ref.read(windowManagementServiceProvider).hideWindowFromTray()) {
      return;
    }

    // Otherwise, open the app.
    _ref.read(typeOfWindowProvider.notifier).setHomeWindow();
    await _ref.read(appServiceProvider).openApp();
  }

  @override
  void onTrayIconRightMouseUp() async {
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    if (isMacOS) {
      await _ref.read(trayManagerProvider).popUpContextMenu();
    }
  }

  @override
  void onTrayIconRightMouseDown() async {
    final year = DateTime.now().year;
    // final l10n = defaultNavigationKey.currentContext?.l10n;

    await _ref.read(trayManagerProvider).setContextMenu(
          Menu(
            items: [
              MenuItem.submenu(
                label:
                    // l10n?.aboutMenuItemTitle ??
                    'About',
                submenu: Menu(
                  items: [
                    MenuItem(
                      label:
                          // l10n?.versionSubmenuItemTitle(packageInfo.version) ??
                          //     'Version: ${packageInfo.version}',
                          'Version: 1.0.0',
                      disabled: true,
                    ),
                    MenuItem.separator(),
                    MenuItem(
                      label: 'Emoji App | $year',
                    ),
                  ],
                ),
              ),
              MenuItem.separator(),
              MenuItem(
                label:
                    // l10n?.quitMenuItemTitle(packageInfo.appName) ??
                    'Quit Emoji App',
                onClick: (_) {
                  // _ref.read(appServiceProvider).quitApp();
                },
              ),
            ],
          ),
        );

    // Added this condition as in the windows up method not getting called
    final isWindows = defaultTargetPlatform == TargetPlatform.windows;
    if (isWindows) {
      await _ref.read(trayManagerProvider).popUpContextMenu();
    }
  }
}
