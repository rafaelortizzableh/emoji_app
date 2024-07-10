import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart' hide windowManager;

import '../features.dart';

final windowListenerProvider = Provider.autoDispose<WindowEventsListener>(
  (ref) => WindowEventsListener(ref),
);

class WindowEventsListener extends WindowListener {
  WindowEventsListener(this._ref) {
    unawaited(_updateWindowFocus());
  }

  final Ref _ref;

  @override
  void onWindowEvent(String eventName) async {
    super.onWindowEvent(eventName);
    unawaited(_updateWindowFocus());

    // To prevent issue of showing window after
    // the user clicks outside of the window,
    // this will hide the window if `isHideWindowOnDeactivate` is true
    // and after that it will set and reset the value of hiddenOnBlur flag.
    final isWindows = defaultTargetPlatform == TargetPlatform.windows;
    if (isWindows) return;
    if (eventName.toLowerCase() == 'blur') {
      await _hideWindowOnBlurEvent();
    }
    // _ref.read(windowsWhiteScreenWorkaroundProvider.notifier).updateState();
  }

  @override
  void onWindowFocus() {
    super.onWindowFocus();

    // Updating this provider whenever the app gets focused
    // so we can observe it and refresh the widget tree to prevent
    // the white screen issue on Windows.
    final isWindows = defaultTargetPlatform == TargetPlatform.windows;
    if (!isWindows) return;
    // _ref.read(windowsWhiteScreenWorkaroundProvider.notifier).updateState();
  }

  Future<void> _hideWindowOnBlurEvent() async {
    final windowManager = _ref.read(windowManagerProvider);
    final isWindows = defaultTargetPlatform == TargetPlatform.windows;
    // Logic to hide window on outside click(HideOnDeactivate).
    if (await windowManager.isHideWindowOnDeactivate()) {
      // Using this flag to avoid click of tray icon when hideOnDeactivate is on
      // because when hideOnDeactivate is on, it hides automatically
      //no need to handle it from tray click listener.
      if (isWindows) {
        await windowManager.setHiddenOnBlur(hiddenOnBlur: true);
      }
      await windowManager.hide();
    }

    // Here we are setting the hide window on blur flag to false
    // 500 milliseconds the blur event,
    // so user can open our app after that by clicking tray icon.
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (isWindows) {
          windowManager.setHiddenOnBlur(hiddenOnBlur: false);
        }
      },
    );
  }

  Future<void> _updateWindowFocus() async {
    // final isWindowFocused = await _ref.read(windowManagerProvider).isFocused();
    // _ref.read(windowFocusProvider.notifier).updateFocus(isWindowFocused);
  }
}
