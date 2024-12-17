import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../../features.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routePath = '/';
  static const routeName = 'Home';

  @override
  Widget build(BuildContext context) {
    if (AppConstants.isDesktopPlatform) {
      return const DesktopHomePageLayout();
    }

    return const DefaultHomePageLayout();
  }
}

class DesktopHomePageLayout extends ConsumerWidget {
  const DesktopHomePageLayout({
    super.key,
  });

  static final _optionsMenuKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentEmojiAndSize = ref.watch(randomEmojiProvider);
    final currentEmoji = currentEmojiAndSize.$1;
    final emojiSize = currentEmojiAndSize.$2;
    return Column(
      children: [
        AppWindowDecoration(
          backgroundColor: AppColors.backgroundColor.withValues(alpha: 0.95),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: const Text('Random Emoji Generator'),
            actions: [
              IconButton(
                key: _optionsMenuKey,
                tooltip: 'Options',
                onPressed: () {
                  final position = _optionsMenuKey.currentContext
                      ?.findRenderObject() as RenderBox?;
                  if (position == null) {
                    return;
                  }
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      position.localToGlobal(Offset.zero).dx,
                      position.localToGlobal(Offset.zero).dy,
                      position.localToGlobal(Offset.zero).dx,
                      position.localToGlobal(Offset.zero).dy,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    items: [
                      PopupMenuItem(
                        value: 'hide',
                        child: const Text('Hide'),
                        onTap: () {
                          ref.read(analyticsServiceProvider).emitEvent(
                            'hide_button_tapped',
                            <String, dynamic>{
                              'currentEmoji': currentEmoji,
                              'location': HomePage.routeName,
                            },
                          );
                          ref.read(appServiceProvider).hideApp();
                        },
                      ),
                      PopupMenuItem(
                        value: 'quit',
                        child: const Text('Quit'),
                        onTap: () {
                          ref.read(analyticsServiceProvider).emitEvent(
                            'quit_button_tapped',
                            <String, dynamic>{
                              'currentEmoji': currentEmoji,
                              'location': HomePage.routeName,
                            },
                          );
                          ref.read(appServiceProvider).quitApp();
                        },
                      ),
                    ],
                  );
                },
                icon: const Icon(CupertinoIcons.ellipsis_vertical),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
          child: GestureDetector(
            onTap: () => ref.read(appServiceProvider).hideApp(),
          ),
        ),
        Expanded(
          child: AppWindowDecoration(
            backgroundColor: AppColors.backgroundColor.withValues(alpha: 0.95),
            child: AppShortcutsWrapper(
              withRefreshAppShortcut: true,
              withHideOrQuitAppShortcuts: true,
              withOpenSettingsShortcut: true,
              withTabSwitchingShortcuts: true,
              child: Scaffold(
                body: Stack(
                  children: [
                    Center(
                      child: MainEmojiItem(
                        currentEmoji: currentEmoji,
                        emojiSize: emojiSize.toDouble(),
                      ),
                    ),
                    Positioned(
                      right: context.width > 600 ? 32 : 16,
                      bottom: context.height > 600 ? 32 : 16,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton.small(
                            heroTag: const Key('new-emoji'),
                            onPressed: () {
                              ref.read(analyticsServiceProvider).emitEvent(
                                'new_emoji_button_tapped',
                                <String, dynamic>{
                                  'currentEmoji': currentEmoji,
                                  'location': HomePage.routeName,
                                },
                              );
                              ref
                                  .read(randomEmojiProvider.notifier)
                                  .updateEmoji();
                              HapticFeedback.heavyImpact().ignore();
                            },
                            tooltip: 'New Emoji',
                            child: const Icon(CupertinoIcons.refresh),
                          ),
                          const SizedBox(height: 12),
                          FloatingActionButton.small(
                            heroTag: const Key('emoji-rain'),
                            onPressed: () {
                              ref.read(analyticsServiceProvider).emitEvent(
                                'emoji_rain_button_tapped',
                                <String, dynamic>{
                                  'currentEmoji': currentEmoji,
                                  'location': HomePage.routeName,
                                },
                              );
                              if (AppConstants.isDesktopPlatform) {
                                ref
                                    .read(typeOfWindowProvider.notifier)
                                    .setEmojiRainWindow();
                                return;
                              }
                              EmojiRainOverlay.show(
                                context,
                                ref,
                                currentEmoji,
                              );
                            },
                            tooltip: 'Emoji Rain',
                            child: const Icon(CupertinoIcons.drop_fill),
                          ),
                          const SizedBox(height: 12),
                          FloatingActionButton.small(
                            heroTag: const Key('copy-emoji'),
                            onPressed: () async {
                              ref.read(analyticsServiceProvider).emitEvent(
                                'copy_emoji_button_tapped',
                                <String, dynamic>{
                                  'currentEmoji': currentEmoji,
                                  'location': HomePage.routeName,
                                },
                              );
                              final data = ClipboardData(text: currentEmoji);
                              final scaffoldMessengerState =
                                  ScaffoldMessenger.of(
                                context,
                              );
                              await Clipboard.setData(data);
                              final snackBar = SnackBar(
                                duration: const Duration(seconds: 2),
                                content:
                                    Text('Copied $currentEmoji to clipboard'),
                                action: SnackBarAction(
                                  label: 'Dismiss',
                                  onPressed: scaffoldMessengerState
                                      .hideCurrentSnackBar,
                                ),
                              );
                              scaffoldMessengerState.showSnackBar(snackBar);
                            },
                            tooltip: 'Copy Emoji',
                            child: const Icon(Icons.copy),
                          ),
                          const SizedBox(height: 12),
                          FloatingActionButton.small(
                            heroTag: const Key('settings'),
                            onPressed: () {
                              ref.read(analyticsServiceProvider).emitEvent(
                                'settings_button_tapped',
                                <String, dynamic>{
                                  'location': HomePage.routeName,
                                },
                              );
                              final goRouter = ref.read(routerProvider);
                              goRouter.push(SettingsPage.routePath);
                            },
                            tooltip: 'Settings',
                            child: const Icon(CupertinoIcons.settings),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endTop,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16,
          child: GestureDetector(
            onTap: () => ref.read(appServiceProvider).hideApp(),
          ),
        ),
        const EmojiClassSelector(),
      ],
    );
  }
}

class DefaultHomePageLayout extends ConsumerWidget {
  const DefaultHomePageLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentEmojiAndSize = ref.watch(randomEmojiProvider);
    final currentEmoji = currentEmojiAndSize.$1;
    final emojiSize = currentEmojiAndSize.$2;

    return AppWindowDecoration(
      backgroundColor: AppColors.backgroundColor.withValues(alpha: 0.95),
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
          body: Stack(
            children: [
              Center(
                child: MainEmojiItem(
                  currentEmoji: currentEmoji,
                  emojiSize: emojiSize.toDouble(),
                ),
              ),
              const Align(
                alignment: Alignment.topCenter,
                child: EmojiClassSelector(),
              ),
              Positioned(
                right: context.width > 600 ? 32 : 16,
                bottom: context.height > 600 ? 32 : 16,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton.small(
                      heroTag: const Key('new-emoji'),
                      onPressed: () {
                        ref.read(analyticsServiceProvider).emitEvent(
                          'new_emoji_button_tapped',
                          <String, dynamic>{
                            'currentEmoji': currentEmoji,
                            'location': HomePage.routeName,
                          },
                        );
                        ref.read(randomEmojiProvider.notifier).updateEmoji();
                        HapticFeedback.heavyImpact().ignore();
                      },
                      tooltip: 'New Emoji',
                      child: const Icon(CupertinoIcons.refresh),
                    ),
                    const SizedBox(height: 12),
                    FloatingActionButton.small(
                      heroTag: const Key('emoji-rain'),
                      onPressed: () {
                        ref.read(analyticsServiceProvider).emitEvent(
                          'emoji_rain_button_tapped',
                          <String, dynamic>{
                            'currentEmoji': currentEmoji,
                            'location': HomePage.routeName,
                          },
                        );
                        if (AppConstants.isDesktopPlatform) {
                          ref
                              .read(typeOfWindowProvider.notifier)
                              .setEmojiRainWindow();
                          return;
                        }
                        EmojiRainOverlay.show(
                          context,
                          ref,
                          currentEmoji,
                        );
                      },
                      tooltip: 'Emoji Rain',
                      child: const Icon(CupertinoIcons.drop_fill),
                    ),
                    const SizedBox(height: 12),
                    FloatingActionButton.small(
                      heroTag: const Key('copy-emoji'),
                      onPressed: () async {
                        ref.read(analyticsServiceProvider).emitEvent(
                          'copy_emoji_button_tapped',
                          <String, dynamic>{
                            'currentEmoji': currentEmoji,
                            'location': HomePage.routeName,
                          },
                        );
                        final data = ClipboardData(text: currentEmoji);
                        final scaffoldMessengerState = ScaffoldMessenger.of(
                          context,
                        );
                        await Clipboard.setData(data);
                        final snackBar = SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text('Copied $currentEmoji to clipboard'),
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed:
                                scaffoldMessengerState.hideCurrentSnackBar,
                          ),
                        );
                        scaffoldMessengerState.showSnackBar(snackBar);
                      },
                      tooltip: 'Copy Emoji',
                      child: const Icon(Icons.copy),
                    ),
                    const SizedBox(height: 12),
                    FloatingActionButton.small(
                      heroTag: const Key('settings'),
                      onPressed: () {
                        ref.read(analyticsServiceProvider).emitEvent(
                          'settings_button_tapped',
                          <String, dynamic>{
                            'location': HomePage.routeName,
                          },
                        );
                        final goRouter = ref.read(routerProvider);
                        goRouter.push(SettingsPage.routePath);
                      },
                      tooltip: 'Settings',
                      child: const Icon(CupertinoIcons.settings),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        ),
      ),
    );
  }
}
