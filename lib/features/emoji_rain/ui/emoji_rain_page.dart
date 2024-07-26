import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/core.dart';
import '../../features.dart';

final _emojiOverlayProvider = StateProvider<OverlayEntry?>(
  (ref) {
    return null;
  },
);

class EmojiRainPage extends HookConsumerWidget {
  const EmojiRainPage({
    super.key,
  });

  static const routePath = '/emoji-rain';
  static const routeName = 'Emoji_Rain';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emoji = ref.watch(randomEmojiProvider).$1;
    final onHideApp = ref.read(appServiceProvider).hideApp;
    useEffect(
      () {
        if (!AppConstants.isDesktopPlatform) {
          ref.read(routerProvider).goNamed(HomePage.routeName);
          return;
        }
        _showEmojiRain(
          context: context,
          ref: ref,
          emoji: emoji,
          onHideApp: onHideApp,
          shouldHideAppAfterAnimation: AppConstants.isDesktopPlatform,
        );
        return null;
      },
      [key],
    );

    return SizedBox.expand(
      child: GestureDetector(
        onTap: () {
          ref.read(_emojiOverlayProvider.notifier).state?.remove();
          ref.read(_emojiOverlayProvider.notifier).state = null;
          ref.read(appServiceProvider).hideApp();
        },
        child: const ColoredBox(
          color: Colors.transparent,
        ),
      ),
    );
  }

  Future<void> _showEmojiRain({
    required BuildContext context,
    required WidgetRef ref,
    required String emoji,
    required VoidCallback onHideApp,
    required bool shouldHideAppAfterAnimation,
  }) async {
    Future.microtask(() {});
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await EmojiRainOverlay.show(
          context,
          ref,
          emoji,
        );
        if (shouldHideAppAfterAnimation) {
          onHideApp();
        }
      },
    );
  }
}

class EmojiRainOverlay extends StatefulWidget {
  const EmojiRainOverlay({
    required this.child,
    required this.animationCompleted,
    required this.emojiItemsToAnimate,
    this.delay = const Duration(milliseconds: 0),
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Completer<bool> animationCompleted;
  final List<AnimatedEmojiItem> emojiItemsToAnimate;

  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    String emoji,
  ) async {
    if (ref.read(_emojiOverlayProvider) != null) {
      ref.read(_emojiOverlayProvider.notifier).state?.remove();
    }

    final navigator = Navigator.of(context, rootNavigator: true);
    // Pop all possible dialogs
    navigator.popUntil((route) => route is PageRoute);
    final overlay = Overlay.of(context);
    final completer = Completer<bool>();

    final emojiList = _generateEmojiItems(
      emoji: emoji,
      width: MediaQuery.sizeOf(context).width,
    );

    final overlayEntry = OverlayEntry(
      builder: (_) => EmojiRainOverlay(
        key: Key(
          'emoji_rain_overlay_${DateTime.now().millisecondsSinceEpoch}',
        ),
        emojiItemsToAnimate: emojiList,
        animationCompleted: completer,
        delay: Duration.zero,
        child: const SizedBox.expand(
          child: ColoredBox(
            color: Colors.transparent,
          ),
        ),
      ),
    );

    ref.read(_emojiOverlayProvider.notifier).state = overlayEntry;

    overlay.insert(overlayEntry);
    if (await completer.future) {
      ref.read(_emojiOverlayProvider.notifier).state?.remove();
      ref.read(_emojiOverlayProvider.notifier).state = null;
    }
  }

  @override
  State<EmojiRainOverlay> createState() => _EmojiRainOverlayState();
}

class _EmojiRainOverlayState extends State<EmojiRainOverlay> {
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, _startAnimation);
    _animationsCompletedListener.addListener(() {
      if (_animationsCompletedListener.value.length ==
          emojiItemsToAnimate.length) {
        widget.animationCompleted.complete(true);
      }
    });
  }

  @override
  void dispose() {
    _animationsCompletedListener.dispose();
    super.dispose();
  }

  void _startAnimation() {
    HapticFeedback.mediumImpact();
  }

  late final emojiItemsToAnimate = widget.emojiItemsToAnimate;
  final _animationsCompletedListener = ValueNotifier(<int>[]);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          widget.child,
          Stack(
            clipBehavior: Clip.none,
            children: [
              ...emojiItemsToAnimate.mapIndexed(
                (index, item) => _AnimatingEmoji(
                  emojiItem: item,
                  index: index,
                  key: ValueKey('_emoji_widget_${index}_$item'),
                  animationCompleted: (isCompleted) {
                    if (!isCompleted) return;

                    _animationsCompletedListener.value = [
                      ..._animationsCompletedListener.value,
                      index,
                    ];
                  },
                ),
              ),
            ],
          )
              .animate(
                onComplete: (_) => widget.animationCompleted.complete(true),
              )
              .slideY(
                begin: -0.1,
                end: 1.1,
                curve: Curves.linearToEaseOut,
                duration: 2.5.seconds,
              ),
        ],
      ),
    );
  }
}

class _AnimatingEmoji extends StatelessWidget {
  const _AnimatingEmoji({
    required this.emojiItem,
    required this.index,
    required this.animationCompleted,
    super.key,
  });

  final int index;
  final AnimatedEmojiItem emojiItem;
  final Function(bool) animationCompleted;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: emojiItem.leftPosition,
      top: emojiItem.topPosition,
      child: Transform.rotate(
        alignment: Alignment.bottomCenter,
        angle: -pi / (_getSign(index) * emojiItem.rotationMultiplier),
        child: Material(
          textStyle: TextStyle(
            fontSize: emojiItem.iconSize,
          ),
          color: Colors.transparent,
          child: Text(
            emojiItem.emoji,
          ),
        ),
      ),
    )
        .animate(
          onComplete: (_) => animationCompleted(true),
        )
        .rotate(
          curve: Curves.easeIn,
          duration: emojiItem.duration,
          begin: 0,
          end: 0.45,
        )
        .slideX(
          begin: -0.5,
          end: _getSign(index) * 3,
          curve: Curves.easeIn,
          duration: emojiItem.duration,
        );
  }

  int _getSign(int index) => index.isEven ? -1 : 1;
}

class AnimatedEmojiItem {
  AnimatedEmojiItem({
    required this.emoji,
    required this.duration,
    required this.iconSize,
    required this.leftPosition,
    required this.topPosition,
    required this.rotationMultiplier,
  });

  final String emoji;
  final Duration duration;
  final double iconSize;
  final double leftPosition;
  final double topPosition;
  final int rotationMultiplier;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnimatedEmojiItem &&
        other.emoji == emoji &&
        other.duration == duration &&
        other.iconSize == iconSize &&
        other.leftPosition == leftPosition &&
        other.topPosition == topPosition &&
        other.rotationMultiplier == rotationMultiplier;
  }

  @override
  int get hashCode {
    return emoji.hashCode ^
        duration.hashCode ^
        iconSize.hashCode ^
        leftPosition.hashCode ^
        topPosition.hashCode ^
        rotationMultiplier.hashCode;
  }
}

List<AnimatedEmojiItem> _generateEmojiItems({
  required String emoji,
  required double width,
}) {
  final random = Random();
  final emojiItems = <AnimatedEmojiItem>[];

  for (var i = 0; i < 100; i++) {
    final leftPosition = random.nextDouble() * width;
    final topPosition = random.nextInt(250).toDouble();
    final duration = Duration(milliseconds: 1000 + random.nextInt(2000));
    final rotationMultiplier = random.nextInt(4) + 1;
    final iconSize = random.nextInt(50) + 50.0;

    emojiItems.add(
      AnimatedEmojiItem(
        emoji: emoji,
        duration: duration,
        iconSize: iconSize,
        leftPosition: leftPosition,
        topPosition: topPosition,
        rotationMultiplier: rotationMultiplier,
      ),
    );
  }

  return emojiItems;
}
