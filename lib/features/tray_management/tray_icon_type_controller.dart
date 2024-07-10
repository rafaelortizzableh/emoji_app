import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tray_manager/tray_manager.dart' hide TrayManager;

import '../../../core/core.dart';
import '../features.dart';

/// A provider for the [TrayIconTypeController].
///
/// It returns the user's preferred [TrayIconType].
final trayIconTypeProvider =
    AsyncNotifierProvider<TrayIconTypeController, TrayIconType>(() {
  return TrayIconTypeController();
});

class TrayIconTypeController extends AsyncNotifier<TrayIconType> {
  TrayIconTypeController();

  Future<void> init() async {
    final initialState = await _initialize();
    await refreshCurrentIcon(initialState);
    _addListeners();
  }

  static const _tag = 'tray_icon_controller';
  static const _defaultTypeOfIcon = TrayIconType.color;

  void updateTypeOfIcon(TrayIconType typeOfIcon) async {
    if (state.value != typeOfIcon) {
      state = AsyncValue.data(typeOfIcon);
    }
  }

  Future<TrayIconType> _initialize() async {
    try {
      final savedState = ref
          .read(sharedPreferencesServiceProvider)
          .getStringFromSharedPreferences(_storageKey);

      // Return the state from shared preferences if it exists,
      // otherwise return the default state.
      return TrayIconType.fromName(savedState);
    } catch (exception, stackTrace) {
      final logger = ref.read(loggerServiceProvider);
      logger.captureException(
        exception,
        stackTrace: stackTrace,
        tag: _tag,
      );

      return _defaultTypeOfIcon;
    }
  }

  Future<void> _saveStateToSharedPreferences(TrayIconType newState) async {
    try {
      await ref.read(sharedPreferencesServiceProvider).saveToSharedPreferences(
            _storageKey,
            newState.name,
          );
    } catch (exception, stackTrace) {
      final logger = ref.read(loggerServiceProvider);
      logger.captureException(
        exception,
        stackTrace: stackTrace,
        tag: _tag,
      );
    }
  }

  /// Refreshes the current icon in the tray manager.
  ///
  /// Sets the icon's asset and position based on the platform
  /// and the user's preferences.
  Future<void> refreshCurrentIcon([TrayIconType? typeOfIcon]) async {
    try {
      final currentTypeOfIcon = typeOfIcon ?? state.value ?? _defaultTypeOfIcon;

      final shouldDisplayStatusOnRightSide =
          ref.read(trayIconTextSettingsProvider).isStatusOnRightSide;

      await ref.read(trayManagerProvider).setIcon(
            currentTypeOfIcon.assetFileName(),
            isTemplate: currentTypeOfIcon.isTemplate(),
            iconPosition: currentTypeOfIcon.getTrayIconPosition(
              shouldDisplayStatusOnRightSide,
            ),
          );
    } catch (exception, stackTrace) {
      final logger = ref.read(loggerServiceProvider);
      logger.captureException(
        exception,
        stackTrace: stackTrace,
        tag: _tag,
      );
    }
  }

  void _addListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenSelf(
        (previous, next) {
          next.whenData((value) {
            _saveStateToSharedPreferences(value);
            refreshCurrentIcon(value);
          });
        },
      );
    });
  }

  /// To avoid showing the wrong selected icon in the menu,
  /// while the user info is being loaded, we set this key based on the
  /// device, and not the `userId`.
  static const _storageKey =
      'type_of_tray_icon_${AppConstants.configEnvironment}';

  @override
  FutureOr<TrayIconType> build() async {
    final initialValue = await _initialize();
    return initialValue;
  }
}

const _defaultIconType = TrayIconType.color;

enum TrayIconType {
  color,
  monochrome;

  static TrayIconType fromName(String? name) {
    return TrayIconType.values.firstWhere(
      (element) => element.name == name,
      orElse: () => _defaultIconType,
    );
  }
}

extension on TrayIconType {
  String assetFileName() {
    final isWindows = defaultTargetPlatform == TargetPlatform.windows;
    switch (this) {
      case TrayIconType.color:
        return AppConstants.defaultColorMenuIconAsset(
          isIco: isWindows,
        );
      case TrayIconType.monochrome:
        return AppConstants.defaultMonochromeMenuIconAsset(
          isIco: isWindows,
        );
    }
  }

  /// Apple's menu bar API includes the `template`
  /// parameter for icons that follow a monochromatic scheme.
  ///
  /// If the icon is a template, the system applies the current
  /// menu bar foreground color to the icon.
  /// https://developer.apple.com/design/human-interface-guidelines/components/system-experiences/the-menu-bar/
  bool isTemplate() {
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    switch (this) {
      case TrayIconType.color:
        return false;
      case TrayIconType.monochrome:
        return isMacOS;
    }
  }

  TrayIconPositon getTrayIconPosition(bool isStatusOnRightSide) {
    return isStatusOnRightSide ? TrayIconPositon.left : TrayIconPositon.right;
  }
}
