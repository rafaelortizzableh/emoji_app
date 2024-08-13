import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/core.dart';

class MainEmojiItem extends HookWidget {
  const MainEmojiItem({
    super.key,
    required this.currentEmoji,
    required this.emojiSize,
  });

  final String currentEmoji;
  final double emojiSize;

  @override
  Widget build(BuildContext context) {
    final currentScale = useValueNotifier(1.0);
    final shouldShake = useState(false);
    useListenableSelector(currentScale, () {
      HapticFeedback.lightImpact().ignore();
    });
    final scaleController = useAnimationController(
      duration: kThemeAnimationDuration,
      lowerBound: 1.0,
      upperBound: 1.33,
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            shouldShake.value = true;
          }
        },
      );
    useEffect(
      () {
        void scaleListener() {
          final animationValue =
              double.parse(scaleController.value.toStringAsFixed(2));
          if (currentScale.value == animationValue) {
            return;
          }
          currentScale.value = animationValue;
        }

        scaleController.addListener(scaleListener);

        return () {
          scaleController.removeListener(scaleListener);
        };
      },
      const [],
    );

    return AnimatedSwitcher(
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
      child: GestureDetector(
        key: ValueKey('emoji-$currentEmoji-$emojiSize'),
        onTapDown: (details) async {
          scaleController.forward();
        },
        onTapCancel: () {
          scaleController.reverse();
        },
        onTapUp: (details) {
          scaleController.reverse();
        },
        onLongPress: () async {
          scaleController.stop();
          shouldShake.value = false;
        },
        onLongPressEnd: (details) {
          HapticFeedback.mediumImpact().ignore();
          scaleController.reverse();
        },
        child: ScaleTransition(
          scale: scaleController,
          child: Text(
            currentEmoji,
            style: context.textTheme.headlineLarge?.copyWith(
              fontSize: emojiSize,
            ),
          ),
        )
            .animate(
              target: shouldShake.value && currentScale.value == 1.33 ? 1 : 0,
              onComplete: (controller) async {
                await HapticFeedback.heavyImpact();
                await Future<void>.delayed(5.ms);
                await HapticFeedback.heavyImpact();
                await Future<void>.delayed(5.ms);
                await HapticFeedback.heavyImpact();
                await Future<void>.delayed(5.ms);
                await HapticFeedback.heavyImpact();
                await Future<void>.delayed(5.ms);
                await HapticFeedback.heavyImpact();
                await Future<void>.delayed(5.ms);
                await HapticFeedback.heavyImpact();
                await Future<void>.delayed(5.ms);
                await HapticFeedback.heavyImpact();

                if (currentScale.value == 1.33) {
                  controller
                    ..reset()
                    ..forward();
                  return;
                }
                shouldShake.value = false;
              },
            )
            .shake(hz: 5),
      ),
    );
  }
}
