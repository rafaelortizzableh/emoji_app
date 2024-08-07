import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

    await _ref.read(trayManagerProvider).setContextMenu(
          Menu(
            items: [
              MenuItem.submenu(
                label: 'About',
                submenu: Menu(
                  items: [
                    MenuItem(
                      label:
                          'Version: ${_ref.read(packageInfoProvider)?.version ?? '1.0.0'}',
                      disabled: true,
                    ),
                    MenuItem.separator(),
                    MenuItem(
                      label: '${AppConstants.authorName} | $year',
                    ),
                  ],
                ),
              ),
              MenuItem(
                label: 'Settings',
                onClick: (_) async {
                  final currentWindowType =
                      _ref.read(typeOfWindowProvider).typeOfWindow;
                  _ref.read(analyticsServiceProvider).emitEvent(
                    'settings_button_tapped',
                    <String, dynamic>{
                      'location': 'Menu Bar Item',
                    },
                  );
                  if (currentWindowType == TypeOfWindow.settings) {
                    _ref.read(routerProvider).go(EmptyWindowPage.routePath);
                    await Future.microtask(() {});
                  }
                  _ref.read(typeOfWindowProvider.notifier).setSettingsWindow();
                },
              ),
              MenuItem(
                label: 'Make it rain ${_ref.read(randomEmojiProvider).$1}',
                onClick: (_) async {
                  _ref.read(analyticsServiceProvider).emitEvent(
                    'emoji_rain_button_tapped',
                    <String, dynamic>{
                      'currentEmoji': _ref.read(randomEmojiProvider).$1,
                      'location': 'Menu Bar Item',
                    },
                  );
                  _ref.read(routerProvider).go(EmptyWindowPage.routePath);
                  await Future.delayed(100.milliseconds);
                  _ref.read(routerProvider).go(EmojiRainPage.routePath);
                },
              ),
              MenuItem(
                label: 'New Random Emoji',
                onClick: (_) async {
                  _ref.read(analyticsServiceProvider).emitEvent(
                    'new_emoji_button_tapped',
                    <String, dynamic>{
                      'currentEmoji': _ref.read(randomEmojiProvider).$1,
                      'location': 'Menu Bar Item',
                    },
                  );
                  _ref.read(randomEmojiProvider.notifier).updateEmoji();
                },
              ),
              MenuItem.separator(),
              MenuItem(
                label: 'Quit Emoji App',
                onClick: (_) {
                  _ref.read(appServiceProvider).quitApp();
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
