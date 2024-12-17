import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final width = context.width;
    return AppWindowDecoration(
      backgroundColor: AppColors.backgroundColor.withValues(alpha: 0.95),
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
            padding: EdgeInsets.symmetric(
              horizontal: (width) < 600 ? 16 : 32,
              vertical: 16,
            ),
            children: [
              const EmojiSettings(),
              if (AppConstants.isDesktopPlatform) ...[
                const SizedBox(height: 20.0),
                const MenuBarSettings(),
              ],
            ],
          ),
          persistentFooterButtons: [
            const AboutThisAppButton(),
            TextButton(
              onPressed: () {
                final analyticsService = ref.read(analyticsServiceProvider);
                analyticsService.emitEvent('author_tapped', {});
                const linkString = AppConstants.authorUrl;
                final link = Uri.parse(linkString);
                launchUrl(link);
              },
              child: Text(
                'Made with ❤️ by ${AppConstants.authorName}',
                style: TextStyle(
                  color: context.theme.textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
