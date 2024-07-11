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

class EmojiRainPage extends HookConsumerWidget {
  const EmojiRainPage({
    super.key,
  });

  static const routePath = '/emoji-rain';
  static const routeName = 'Emoji_Rain';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        if (!AppConstants.isDesktopPlatform) {
          ref.read(routerProvider).goNamed(HomePage.routeName);
          return;
        }
        _showEmojiRain(context: context, ref: ref);
        return null;
      },
      const [],
    );

    return const SizedBox.expand(
      child: ColoredBox(
        color: Colors.transparent,
      ),
    );
  }

  Future<void> _showEmojiRain({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    Future.microtask(() {});
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final emoji = ref.read(randomEmojiProvider).$1;
        await EmojiRainOverlay.show(context, emoji);
        if (AppConstants.isDesktopPlatform) {
          ref.read(appServiceProvider).hideApp();
        }
      },
    );
  }
}

class EmojiRainOverlay extends StatefulWidget {
  final Widget child;
  final String emoji;
  final Duration delay;
  final Completer<bool> animationCompleted;

  const EmojiRainOverlay({
    required this.child,
    required this.emoji,
    required this.animationCompleted,
    super.key,
    this.delay = const Duration(milliseconds: 200),
  });

  static Future<void> show(BuildContext context, String emoji) async {
    final overlay = Overlay.of(context);
    final completer = Completer<bool>();

    final overlayEntry = OverlayEntry(
      builder: (_) => EmojiRainOverlay(
        emoji: emoji,
        animationCompleted: completer,
        delay: Duration.zero,
        child: const SizedBox.expand(
          child: ColoredBox(color: Colors.transparent),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    if (await completer.future) {
      overlayEntry.remove();
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
    _assignEmoji();
    HapticFeedback.mediumImpact();
  }

  final emojiItemsToAnimate = <_EmojiConfettiItem>[];
  final ValueNotifier<List<int>> _animationsCompletedListener =
      ValueNotifier([]);

  void _assignEmoji() {
    final emoji = widget.emoji;
    final width = MediaQuery.sizeOf(context).width;
    final regularItems = [
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 1500),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 50,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 1700),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 60,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 60,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2010),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 70,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2050),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 80,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2150),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 80,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2200),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 84,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2800),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 86,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 60,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2100),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 64,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 1200),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 66,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 1600),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 74,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 1800),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 76,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 1900),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 78,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2200),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 80,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2400),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 82,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2700),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 84,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 86,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 88,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 90,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 92,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
      _EmojiConfettiItem(
        duration: const Duration(milliseconds: 2000),
        emoji: emoji,
        leftPosition: width * Random().nextDouble(),
        topPosition: Random().nextInt(250).toDouble(),
        rotationMultiplier: Random().nextInt(14) + 1,
        iconSize: 94,
      ),
    ];

    setState(() {
      emojiItemsToAnimate.addAll([
        ...regularItems,
        ...regularItems.reversed,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          widget.child,
          Stack(
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
  final _EmojiConfettiItem emojiItem;
  final Function(bool) animationCompleted;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: emojiItem.leftPosition,
      top: emojiItem.topPosition,
      child: SizedBox(
        width: emojiItem.iconSize,
        height: emojiItem.iconSize,
        child: FittedBox(
          child: Transform.rotate(
            alignment: Alignment.bottomCenter,
            angle: -pi / (getSign(index) * emojiItem.rotationMultiplier),
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
          end: getSign(index) * 3,
          curve: Curves.easeIn,
          duration: emojiItem.duration,
        );
  }

  int getSign(int index) => index.isEven ? -1 : 1;
}

class _EmojiConfettiItem {
  _EmojiConfettiItem({
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

    return other is _EmojiConfettiItem &&
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
