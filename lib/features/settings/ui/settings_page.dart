import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../../features.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({
    super.key,
  });

  static const routePath = '/settings';
  static const routeName = 'Settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppWindowDecoration(
      backgroundColor: AppColors.backgroundColor.withOpacity(0.95),
      child: AppShortcutsWrapper(
        withHideOrQuitAppShortcuts: true,
        withOpenSettingsShortcut: false,
        withRefreshAppShortcut: false,
        withTabSwitchingShortcuts: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(routeName),
            automaticallyImplyLeading: !AppConstants.isDesktopPlatform,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            children: const [MenuBarSettings()],
          ),
        ),
      ),
    );
  }
}
