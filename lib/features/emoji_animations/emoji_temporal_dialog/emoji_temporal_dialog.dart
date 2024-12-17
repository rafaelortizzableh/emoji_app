import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../features.dart';

class EmojiTemporalDialog extends StatelessWidget {
  const EmojiTemporalDialog({
    super.key,
    required this.emoji,
    required this.animationCompleted,
  });
  final String emoji;
  final Completer<bool> animationCompleted;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Material(
        color: Colors.transparent,
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: SizedBox.square(
              dimension: 200.0,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(
                        fontSize: 100.0,
                      ),
                    ),
                    const Text(
                      'Hello!',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: AppColors.white90transparency,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate(
                onComplete: (_) => animationCompleted.complete(true),
              )
              .fadeIn()
              .then(duration: 10.seconds)
              .shake()
              .then(duration: 1.seconds)
              .fadeOut(),
        ),
      ),
    );
  }
}
