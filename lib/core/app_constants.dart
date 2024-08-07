import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

abstract class AppConstants {
  /// Current [NavigatorState]
  ///
  /// (Useful to determine where the user is currently in the application)
  static final defaultNavigationKey = GlobalKey<NavigatorState>();

  static const mainWindowDimensions = Size(440.0, 400.0);
  static const secondWindowDimensions = Size(350, 400.0);
  static const spacingBetweenWindows = 8.0;

  /// The size for the main window to be shown under the menu item icon (tray on Windows).
  static final defaultAppDimensions =
      defaultTargetPlatform == TargetPlatform.windows
          ? _windowsDefaultAppDimensions
          : _macOSDefaultAppDimensions;

  static const _macOSDefaultAppDimensions = mainWindowDimensions;
  static final _windowsDefaultAppDimensions = Size(
    mainWindowDimensions.width +
        secondWindowDimensions.width +
        spacingBetweenWindows,
    mainWindowDimensions.height,
  );

  static const defaultSettingsWindowDimensions = Size(1000.0, 750.0);
  static const defaultMaxSupportedWindowDimensions = Size(3840.0, 2160.0);

  static const _windowsIconFileExtension = '.ico';
  static const _macOSIconFileExtension = '.png';
  static const defaultMenuIconButtonWin =
      'assets/menu_icon/app_default_menu_icon.ico';

  static const _colorMenuIconAssetFileName =
      'assets/menu_icon/app_color_menu_icon';
  static const _monochromeMenuIconAssetFileName =
      'assets/menu_icon/app_monochrome_menu_icon';

  /// Asset path for the colored file for the menu icon.
  ///
  /// The file extension depends on the type of [LocalPlatform].
  static String defaultColorMenuIconAsset({
    required bool isIco,
  }) {
    final fileExtension =
        isIco ? _windowsIconFileExtension : _macOSIconFileExtension;
    return '$_colorMenuIconAssetFileName$fileExtension';
  }

  /// Asset path for the monochrome file for the menu icon.
  ///
  /// The file extension depends on the type of [LocalPlatform].
  static String defaultMonochromeMenuIconAsset({
    required bool isIco,
  }) {
    final fileExtension =
        isIco ? _windowsIconFileExtension : _macOSIconFileExtension;
    return '$_monochromeMenuIconAssetFileName$fileExtension';
  }

  /// Default [WindowOptions] for this app
  static final mainWindowOptions = WindowOptions(
    alwaysOnTop: false,
    center: false,
    maximumSize: defaultAppDimensions,
    minimumSize: defaultAppDimensions,
    size: defaultAppDimensions,
    titleBarStyle: TitleBarStyle.hidden,
    skipTaskbar: true,
  );

  /// The environment configuration for the app.
  static const configEnvironment = String.fromEnvironment('ENV');

  /// The URL for the Terms and Conditions page.
  static const termsAndConditionsUrl = String.fromEnvironment(
    'TERMS_AND_CONDITIONS_URL',
  );

  /// The URL for the Privacy Policy page.
  static const privacyPolicyUrl = String.fromEnvironment('PRIVACY_POLICY_URL');

  /// The URL for the Source Code page.
  static const sourceCodeUrl = String.fromEnvironment('SOURCE_CODE_URL');

  /// The URL for the Author page.
  static const authorUrl = String.fromEnvironment('AUTHOR_URL');

  /// The URL for the Analytics endpoint.
  static const analyticsEndPoint = String.fromEnvironment('ANALYTICS_ENDPOINT');

  /// Editorial Emoji Endpoint
  static const editorialEmojiEndpoint = String.fromEnvironment(
    'EDITORIAL_EMOJI_ENDPOINT',
  );

  /// The name of the author of the app.
  static const authorName = String.fromEnvironment('AUTHOR_NAME');

  // Default Border Radius for the Home Scaffold
  static const _circularBorderRadius16 = Radius.circular(16.0);
  static const defaultBorderRadius = BorderRadius.only(
    topLeft: _circularBorderRadius16,
    topRight: _circularBorderRadius16,
    bottomLeft: _circularBorderRadius16,
    bottomRight: _circularBorderRadius16,
  );

  static const _validDesktopPlatform = {
    TargetPlatform.macOS,
    TargetPlatform.windows,
  };

  static final isDesktopPlatform =
      !kIsWeb && _validDesktopPlatform.contains(defaultTargetPlatform);
}
