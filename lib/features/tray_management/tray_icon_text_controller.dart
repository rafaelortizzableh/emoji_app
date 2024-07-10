import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tray_manager/tray_manager.dart';

import '../../../../core/core.dart';
import '../features.dart';

final trayIconTextSettingsProvider = StateNotifierProvider.autoDispose<
    TrayIconTextSettingsController, TrayIconSettings>(
  (ref) {
    return TrayIconTextSettingsController(ref);
  },
);

class TrayIconTextSettingsController extends StateNotifier<TrayIconSettings> {
  TrayIconTextSettingsController(
    this._ref,
  ) : super(_initialize(_ref)) {
    addListener(_saveStateToSharedPreferences);
    addListener(_changeStatusSideOnMenuBar);
    addListener(_removeStatusBarText);
  }

  static const _tag = 'status_on_menu_bar_controller';

  final AutoDisposeStateNotifierProviderRef _ref;

  static TrayIconSettings _initialize(Ref ref) {
    try {
      final isStatusShown = ref
          .read(sharedPreferencesServiceProvider)
          .getBoolFromSharedPreferences(
            _showStatusOnMenuBarStorageKey,
          );
      final isStatusOnRightSide = ref
          .read(sharedPreferencesServiceProvider)
          .getBoolFromSharedPreferences(_isStatusOnRightSideStorageKey);
      return TrayIconSettings(
        showStatusOnTray: isStatusShown ?? true,
        isStatusOnRightSide: isStatusOnRightSide ?? true,
      );
    } catch (e, stackTrace) {
      ref.read(loggerServiceProvider).captureException(
            e,
            stackTrace: stackTrace,
            tag: _tag,
          );
      return const TrayIconSettings(
        showStatusOnTray: true,
        isStatusOnRightSide: true,
      );
    }
  }

  void _saveStateToSharedPreferences(TrayIconSettings newState) {
    final statusShown = newState.showStatusOnTray;
    final statusOnRightSide = newState.isStatusOnRightSide;
    unawaited(
      Future.wait(
        [
          _ref.read(sharedPreferencesServiceProvider).saveToSharedPreferences(
                _showStatusOnMenuBarStorageKey,
                statusShown,
              ),
          _ref.read(sharedPreferencesServiceProvider).saveToSharedPreferences(
                _isStatusOnRightSideStorageKey,
                statusOnRightSide,
              ),
        ],
      ),
    );
  }

  void _changeStatusSideOnMenuBar(TrayIconSettings newState) {
    // Ignore on Windows as the status is not shown on Windows.
    final isWindows = defaultTargetPlatform == TargetPlatform.windows;
    if (isWindows) {
      return;
    }
    final trayManager = _ref.read(trayManagerProvider);
    final position = newState.isStatusOnRightSide
        ? TrayIconPositon.left
        : TrayIconPositon.right;

    unawaited(
      trayManager.setIconPosition(position),
    );
  }

  void _removeStatusBarText(TrayIconSettings newState) {
    if (newState.showStatusOnTray) {
      return;
    }

    final trayManager = _ref.read(trayManagerProvider);
    unawaited(
      trayManager.setTitle(''),
    );
  }

  void toggleStatusShownOnTray(bool showStatusOnTray) {
    state = state.copyWith(showStatusOnTray: showStatusOnTray);
  }

  void changeStatusPosition({
    required bool isStatusOnRightSide,
  }) {
    state = state.copyWith(isStatusOnRightSide: isStatusOnRightSide);
  }

  static String get _showStatusOnMenuBarStorageKey => 'show_status_on_menu_bar';
  static String get _isStatusOnRightSideStorageKey => 'is_status_on_right_side';
}
