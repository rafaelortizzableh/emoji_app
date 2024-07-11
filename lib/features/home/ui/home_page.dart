import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../../features.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  static const routePath = '/';
  static const routeName = 'Home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentEmojiAndSize = ref.watch(randomEmojiProvider);
    final currentEmoji = currentEmojiAndSize.$1;
    final emojiSize = currentEmojiAndSize.$2;

    return AppWindowDecoration(
      backgroundColor: AppColors.backgroundColor.withOpacity(0.95),
      child: AppShortcutsWrapper(
        withRefreshAppShortcut: true,
        withHideOrQuitAppShortcuts: true,
        withOpenSettingsShortcut: true,
        withTabSwitchingShortcuts: true,
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: const Text('Random Emoji Generator'),
          ),
          body: Center(
            child: AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              switchInCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: SelectableText(
                key: ValueKey('emoji-$currentEmoji-$emojiSize'),
                currentEmoji,
                style: context.textTheme.headlineLarge?.copyWith(
                  fontSize: emojiSize.toDouble(),
                ),
              ),
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.small(
                heroTag: const Key('new-emoji'),
                onPressed: ref.read(randomEmojiProvider.notifier).updateEmoji,
                tooltip: 'New Emoji',
                child: const Icon(CupertinoIcons.refresh),
              ),
              const SizedBox(height: 12),
              FloatingActionButton.small(
                heroTag: const Key('emoji-rain'),
                onPressed: () {
                  if (AppConstants.isDesktopPlatform) {
                    ref
                        .read(typeOfWindowProvider.notifier)
                        .setEmojiRainWindow();
                    return;
                  }
                  EmojiRainOverlay.show(context, currentEmoji);
                },
                tooltip: 'Emoji Rain',
                child: const Icon(CupertinoIcons.drop_fill),
              ),
              const SizedBox(height: 12),
              FloatingActionButton.small(
                heroTag: const Key('copy-emoji'),
                onPressed: () {
                  final data = ClipboardData(text: currentEmoji);
                  Clipboard.setData(data).ignore();
                  final snackBar = SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text('Copied $currentEmoji to clipboard'),
                    action: SnackBarAction(
                      label: 'Dismiss',
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    snackBar,
                  );
                },
                tooltip: 'Copy Emoji',
                child: const Icon(Icons.copy),
              ),
              const SizedBox(height: 12),
              FloatingActionButton.small(
                heroTag: const Key('settings'),
                onPressed: () {
                  context.go(SettingsPage.routePath);
                },
                tooltip: 'Settings',
                child: const Icon(CupertinoIcons.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
