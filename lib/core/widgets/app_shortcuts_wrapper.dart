import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Tab;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/features.dart';
import '../core.dart';

class AppShortcutsWrapper extends ConsumerWidget {
  const AppShortcutsWrapper({
    super.key,
    required this.child,
    this.withHideOrQuitAppShortcuts = false,
    this.withRefreshAppShortcut = false,
    this.withOpenSettingsShortcut = false,
    this.withTabSwitchingShortcuts = false,
  });

  const AppShortcutsWrapper.hideOrQuitApp({
    super.key,
    required this.child,
  })  : withHideOrQuitAppShortcuts = true,
        withRefreshAppShortcut = false,
        withOpenSettingsShortcut = false,
        withTabSwitchingShortcuts = false;

  final Widget child;
  final bool withHideOrQuitAppShortcuts;
  final bool withRefreshAppShortcut;
  final bool withOpenSettingsShortcut;
  final bool withTabSwitchingShortcuts;

  // static final _homeTabFromTab = {
  //   Tab.first: HomeTab.today,
  //   Tab.second: HomeTab.team,
  // };

  // static final _homeTabFromDirection = {
  //   NavigateListHorizontalDirection.left: HomeTab.today,
  //   NavigateListHorizontalDirection.right: HomeTab.team,
  // };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final platform = ref.watch(localPlatformProvider);

    return FocusableActionDetector(
      autofocus: true,
      shortcuts: {
        if (withHideOrQuitAppShortcuts) ...{
          ...ShortcutIntents.hideApp(
            onHideApp: () => _hideApp(ref),
            platform: defaultTargetPlatform,
          ),
          ...ShortcutIntents.quitApp(
            onQuitApp: () => _quitApp(ref),
            platform: defaultTargetPlatform,
          ),
        },
        if (withRefreshAppShortcut)
          ...ShortcutIntents.refreshApp(
            onRefresh: () => _refreshApp(context, ref),
            platform: defaultTargetPlatform,
          ),
        if (withOpenSettingsShortcut)
          ...ShortcutIntents.openSettings(
            onOpenSettings: () => _openSettings(ref),
            platform: defaultTargetPlatform,
          ),
        if (withTabSwitchingShortcuts) ...{
          ...ShortcutIntents.switchTabs(
            onSwitchTab: (tab) {
              // return _switchTab(tab: tab, context: context);
            },
            platform: defaultTargetPlatform,
          ),
          ...ShortcutIntents.navigateHorizontal(
            onNavigate: (direction) {
              // return _switchTab(direction: direction, context: context);
            },
          ),
        }
      },
      actions: {
        if (withHideOrQuitAppShortcuts) ...{
          ...ShortcutActions.hideApp,
          ...ShortcutActions.quitApp,
        },
        if (withRefreshAppShortcut) ...ShortcutActions.refreshApp,
        if (withOpenSettingsShortcut) ...ShortcutActions.openSettings,
        if (withTabSwitchingShortcuts) ...{
          ...ShortcutActions.switchTabs,
          ...ShortcutActions.navigateHorizontal,
        },
      },
      child: child,
    );
  }

  void _hideApp(WidgetRef ref) {
    ref.read(appServiceProvider).hideApp();
  }

  void _quitApp(WidgetRef ref) {
    ref.read(appServiceProvider).quitApp();
  }

  void _refreshApp(BuildContext context, WidgetRef ref) {
    ref.read(randomEmojiProvider.notifier).updateEmoji();
  }

  void _openSettings(WidgetRef ref) {
    final goRouter = ref.read(routerProvider);
    goRouter.push(SettingsPage.routePath);
  }

  /// Switches the tab to the given [tab] or to the tab in the given [direction].
  // void _switchTab({
  //   required BuildContext context,
  //   Tab? tab,
  //   NavigateListHorizonalDirection? direction,
  // }) {
  //   final tabController = DefaultTabController.of(context);
  //   final homeTab = _homeTabFromTab[tab] ?? _homeTabFromDirection[direction];

  //   if (homeTab != null) {
  //     tabController.animateTo(homeTab.tab);
  //   }
  // }
}
