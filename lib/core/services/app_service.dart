import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/core.dart';
import '../../features/features.dart';

/// A provider of [AppService].
final appServiceProvider = Provider.autoDispose<AppService>(
  (ref) => AppService(ref),
);

class AppService {
  AppService(this._ref);

  static const _tag = 'app_service';

  final Ref _ref;

  /// Opens the Buzz application on the Home window.
  Future<void> openApp() async {
    try {
      final windowManagementService =
          _ref.read(windowManagementServiceProvider);
      final typeOfWindowController = _ref.read(typeOfWindowProvider.notifier);

      // Launch the application on the home window if it's not visible.
      if (!(await windowManagementService.isWindowVisible())) {
        await windowManagementService.resetWindowToOriginalSettings();
        typeOfWindowController.setHomeWindow();
        await windowManagementService.showHomeWindow();
      }
    } catch (error, stackTrace) {
      _ref.read(loggerServiceProvider).captureException(
            error,
            stackTrace: stackTrace,
            tag: _tag,
          );
    }
  }

  /// Hides (but not quits) the Buzz application.
  void hideApp() {
    try {
      _ref.read(windowManagementServiceProvider).hideWindow();
    } catch (error, stackTrace) {
      _ref.read(loggerServiceProvider).captureException(
            error,
            stackTrace: stackTrace,
            tag: _tag,
          );
    }
  }

  /// Returns true if the Buzz application is visible.
  Future<bool> isAppVisible() async {
    try {
      return await _ref.read(windowManagementServiceProvider).isWindowVisible();
    } catch (error, stackTrace) {
      _ref.read(loggerServiceProvider).captureException(
            error,
            stackTrace: stackTrace,
            tag: _tag,
          );
      return false;
    }
  }

  /// Quits the Buzz application.
  void quitApp() {
    try {
      final isWindows = defaultTargetPlatform == TargetPlatform.windows;
      // To exit the Application on Windows
      // as SystemNavigator.pop is not working on windows.
      // Ref-Link: https://github.com/flutter/flutter/issues/66631
      if (isWindows) {
        unawaited(Future.wait([
          _ref.read(windowManagerProvider).destroy(),
          _ref.read(trayManagerProvider).destroy(),
        ]));
        exit(0);
      }
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } catch (error, stackTrace) {
      _ref.read(loggerServiceProvider).captureException(
            error,
            stackTrace: stackTrace,
            tag: _tag,
          );
    }
  }
}
