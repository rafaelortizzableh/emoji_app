import 'dart:math';
import 'dart:ui';

import 'package:emoji_app/features/features.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/core.dart';

final randomEmojiProvider =
    StateNotifierProvider.autoDispose<RandomEmojiNotifier, (String, int)>(
        (ref) {
  return RandomEmojiNotifier(ref);
});

class RandomEmojiNotifier extends StateNotifier<(String, int)> {
  static Size get _viewSize {
    if (AppConstants.isDesktopPlatform) {
      return AppConstants.defaultAppDimensions;
    }

    final physicalSize = _initialSize;

    final minWidth = min(
      physicalSize.width,
      AppConstants.defaultSettingsWindowDimensions.width,
    );
    final minHeight = min(
      physicalSize.height,
      AppConstants.defaultSettingsWindowDimensions.height,
    );
    return Size(minWidth, minHeight);
  }

  static Size get _initialSize {
    try {
      return AppConstants.defaultNavigationKey.currentContext?.size ??
          AppConstants.defaultAppDimensions;
    } catch (e) {
      return AppConstants.defaultAppDimensions;
    }
  }

  RandomEmojiNotifier(this.ref) : super(('🛡️', 32)) {
    updateEmoji();
  }

  final Ref ref;

  void updateEmoji() {
    final newSize = _randomSize(_viewSize);
    final newEmoji = _randomEmoji(state.$1);
    state = (newEmoji, newSize);
  }

  String _randomEmoji([String? skip]) {
    final allEmoji = ref.read(allEmojiProvider);
    var emoji = ref.read(emojiClassProvider)?.emoji ?? allEmoji;
    if (ref.read(editorialEmojiCategorySelectedProvider)) {
      emoji = ref.read(editorialEmojiFutureProvider).asData?.value ?? emoji;
    }
    final emojiWithoutSkip = emoji.where((e) => e != skip).toList();
    final emojiIndex = Random().nextInt(emojiWithoutSkip.length);
    return emojiWithoutSkip.where((e) => e != skip).elementAt(emojiIndex);
  }

  int _randomSize(Size viewSize) {
    final size = viewSize / 3;
    final randomSize = Random().nextInt(size.width.toInt());
    return max(randomSize, 80);
  }
}
