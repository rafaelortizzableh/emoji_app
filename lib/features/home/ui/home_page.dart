import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final selectedEmojiClass = ref.watch(emojiClassProvider);

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
          body: Stack(
            children: [
              Center(
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
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 30,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: EmojiClass.values.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 4),
                    itemBuilder: (context, index) {
                      final emojiClass = EmojiClass.values[index];
                      return InkWell(
                        onTap: () {
                          HapticFeedback.mediumImpact().ignore();
                          ref
                              .read(emojiClassProvider.notifier)
                              .setEmojiClass(emojiClass);
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: AnimatedContainer(
                          duration: kThemeAnimationDuration,
                          decoration: BoxDecoration(
                            color: selectedEmojiClass == emojiClass
                                ? AppColors.grey3
                                : AppColors.grey2,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Text(
                                  emojiClass.emoji.first,
                                  style: context.textTheme.headlineMedium,
                                ),
                                const SizedBox(width: 1),
                                Text(
                                  emojiClass.label,
                                  style: context.textTheme.headlineMedium,
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                right: 32,
                bottom: 32,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton.small(
                      heroTag: const Key('new-emoji'),
                      onPressed:
                          ref.read(randomEmojiProvider.notifier).updateEmoji,
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
