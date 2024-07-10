import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;

abstract class ShortcutIntents {
  /// An intent to hide the app on `Escape`, `Cmd + W` (macOS) or `Ctrl + W` (Windows).
  static Map<SingleActivator, HideAppIntent> hideApp({
    required VoidCallback onHideApp,
    required TargetPlatform platform,
  }) {
    return <SingleActivator, HideAppIntent>{
      const SingleActivator(
        LogicalKeyboardKey.escape,
      ): HideAppIntent(onHideApp: onHideApp),
      SingleActivator(
        LogicalKeyboardKey.keyW,
        meta: platform == TargetPlatform.macOS,
        control: platform == TargetPlatform.windows,
      ): HideAppIntent(onHideApp: onHideApp),
    };
  }

  /// An intent to quit the app on `Ctrl + Q` (Windows).
  /// MacOS supports quitting the app on `Cmd + Q` by default.
  static Map<SingleActivator, QuitAppIntent> quitApp({
    required VoidCallback onQuitApp,
    required TargetPlatform platform,
  }) {
    return <SingleActivator, QuitAppIntent>{
      if (platform == TargetPlatform.windows)
        const SingleActivator(
          LogicalKeyboardKey.keyQ,
          control: true,
        ): QuitAppIntent(onQuitApp: onQuitApp),
    };
  }

  /// An intent to close a popup on `Enter` or `Escape`.
  static Map<SingleActivator, ClosePopupIntent> closePopupOnEnterOrEscape(
    BuildContext context,
  ) {
    return <SingleActivator, ClosePopupIntent>{
      const SingleActivator(
        LogicalKeyboardKey.enter,
      ): ClosePopupIntent(context),
      const SingleActivator(
        LogicalKeyboardKey.escape,
      ): ClosePopupIntent(context),
    };
  }

  /// An intent to navigate horizontally in a list.
  static Map<SingleActivator, NavigateHorizontalIntent> navigateHorizontal({
    required Function(NavigateListHorizontalDirection) onNavigate,
  }) {
    return <SingleActivator, NavigateHorizontalIntent>{
      const SingleActivator(LogicalKeyboardKey.arrowLeft):
          NavigateHorizontalIntent(
        direction: NavigateListHorizontalDirection.left,
        onNavigate: onNavigate,
      ),
      const SingleActivator(LogicalKeyboardKey.arrowRight):
          NavigateHorizontalIntent(
        direction: NavigateListHorizontalDirection.right,
        onNavigate: onNavigate,
      ),
    };
  }

  /// An intent to switch tabs.
  static Map<SingleActivator, SwitchTabIntent> switchTabs({
    required Function(Tab) onSwitchTab,
    required TargetPlatform platform,
  }) {
    return <SingleActivator, SwitchTabIntent>{
      SingleActivator(
        LogicalKeyboardKey.digit1,
        meta: platform == TargetPlatform.macOS,
        control: platform == TargetPlatform.windows,
      ): SwitchTabIntent(
        tab: Tab.first,
        onSwitchTab: onSwitchTab,
      ),
      SingleActivator(
        LogicalKeyboardKey.digit2,
        meta: platform == TargetPlatform.macOS,
        control: platform == TargetPlatform.windows,
      ): SwitchTabIntent(
        tab: Tab.second,
        onSwitchTab: onSwitchTab,
      ),
    };
  }

  /// An intent to refresh the app on `Cmd + R` (macOS) or `Ctrl + R` (Windows).
  static Map<SingleActivator, RefreshAppIntent> refreshApp({
    required VoidCallback onRefresh,
    required TargetPlatform platform,
  }) {
    return <SingleActivator, RefreshAppIntent>{
      SingleActivator(
        LogicalKeyboardKey.keyR,
        meta: platform == TargetPlatform.macOS,
        control: platform == TargetPlatform.windows,
      ): RefreshAppIntent(onRefresh: onRefresh),
    };
  }

  /// An intent to open app Settings on `Cmd + ,` (macOS) or `Ctrl + ,` (Windows).
  static Map<SingleActivator, OpenSettingsIntent> openSettings({
    required VoidCallback onOpenSettings,
    required TargetPlatform platform,
  }) {
    return <SingleActivator, OpenSettingsIntent>{
      SingleActivator(
        LogicalKeyboardKey.comma,
        meta: platform == TargetPlatform.macOS,
        control: platform == TargetPlatform.windows,
      ): OpenSettingsIntent(onOpenSettings: onOpenSettings),
    };
  }
}

abstract class ShortcutActions {
  /// An action to hide the app.
  static final hideApp = <Type, Action<Intent>>{
    HideAppIntent: HideAppAction(),
  };

  /// An action to quit the app.
  static final quitApp = <Type, Action<Intent>>{
    QuitAppIntent: QuitAppAction(),
  };

  /// An action to close a popup.
  static final closePopup = <Type, Action<Intent>>{
    ClosePopupIntent: ClosePopupAction(),
  };

  /// An action to navigate horizontally in a list.
  static final navigateHorizontal = <Type, Action<Intent>>{
    NavigateHorizontalIntent: NavigateHorizontalAction(),
  };

  /// An action to switch tabs.
  static final switchTabs = <Type, Action<Intent>>{
    SwitchTabIntent: SwitchTabAction(),
  };

  /// An action to refresh the app.
  static final refreshApp = <Type, Action<Intent>>{
    RefreshAppIntent: RefreshAppAction(),
  };

  /// An action to open app Settings.
  static final openSettings = <Type, Action<Intent>>{
    OpenSettingsIntent: OpenSettingsAction(),
  };
}

class ClosePopupAction extends Action<ClosePopupIntent> {
  @override
  void invoke(ClosePopupIntent intent) {
    Navigator.pop(intent.context);
  }
}

class ClosePopupIntent extends DismissIntent {
  const ClosePopupIntent(this.context);
  final BuildContext context;
}

class NavigateHorizontalAction extends Action<NavigateHorizontalIntent> {
  @override
  void invoke(NavigateHorizontalIntent intent) {
    intent.onNavigate(intent.direction);
  }
}

class NavigateHorizontalIntent extends Intent {
  const NavigateHorizontalIntent({
    required this.onNavigate,
    required this.direction,
  });

  final Function(NavigateListHorizontalDirection) onNavigate;
  final NavigateListHorizontalDirection direction;
}

enum NavigateListHorizontalDirection { left, right }

class SwitchTabAction extends Action<SwitchTabIntent> {
  @override
  void invoke(SwitchTabIntent intent) {
    intent.onSwitchTab(intent.tab);
  }
}

class SwitchTabIntent extends Intent {
  const SwitchTabIntent({
    required this.onSwitchTab,
    required this.tab,
  });

  final Function(Tab) onSwitchTab;
  final Tab tab;
}

enum Tab {
  first,
  second,
}

class HideAppAction extends Action<HideAppIntent> {
  @override
  void invoke(HideAppIntent intent) {
    intent.onHideApp();
  }
}

class HideAppIntent extends Intent {
  const HideAppIntent({
    required this.onHideApp,
  });

  final VoidCallback onHideApp;
}

class QuitAppAction extends Action<QuitAppIntent> {
  @override
  void invoke(QuitAppIntent intent) {
    intent.onQuitApp();
  }
}

class QuitAppIntent extends Intent {
  const QuitAppIntent({
    required this.onQuitApp,
  });

  final VoidCallback onQuitApp;
}

class RefreshAppAction extends Action<RefreshAppIntent> {
  @override
  void invoke(RefreshAppIntent intent) {
    intent.onRefresh();
  }
}

class RefreshAppIntent extends Intent {
  const RefreshAppIntent({
    required this.onRefresh,
  });

  final VoidCallback onRefresh;
}

class OpenSettingsAction extends Action<OpenSettingsIntent> {
  @override
  void invoke(OpenSettingsIntent intent) {
    intent.onOpenSettings();
  }
}

class OpenSettingsIntent extends Intent {
  const OpenSettingsIntent({
    required this.onOpenSettings,
  });

  final VoidCallback onOpenSettings;
}
