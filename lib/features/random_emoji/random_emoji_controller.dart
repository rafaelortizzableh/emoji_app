import 'dart:math';
import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/core.dart';

final randomEmojiProvider =
    StateNotifierProvider.autoDispose<RandomEmojiNotifier, (String, int)>(
        (ref) {
  return RandomEmojiNotifier();
});

class RandomEmojiNotifier extends StateNotifier<(String, int)> {
  static Size get _viewSize =>
      AppConstants.defaultNavigationKey.currentContext?.size ??
      AppConstants.defaultAppDimensions;

  RandomEmojiNotifier() : super(('🛡️', 32)) {
    updateEmoji();
  }

  void updateEmoji() {
    final newSize = _randomSize(_viewSize);
    final newEmoji = _randomEmoji(state.$1);
    state = (newEmoji, newSize);
  }

  String _randomEmoji([String? skip]) {
    final emojiWithoutSkip = _emoji.where((e) => e != skip).toList();
    final emojiIndex = Random().nextInt(emojiWithoutSkip.length);
    return emojiWithoutSkip.where((e) => e != skip).elementAt(emojiIndex);
  }

  int _randomSize(Size viewSize) {
    final size = viewSize / 3;
    final randomSize = Random().nextInt(size.width.toInt());
    return max(randomSize, 32);
  }

  static const _emoji = [
    '🤓',
    '🤖',
    '👾',
    '👽',
    '👻',
    '🤠',
    '🤡',
    '🤥',
    '🤤',
    '🤢',
    '🤧',
    '⚾️',
    '🏀',
    '🏈',
    '🎱',
    '🎾',
    '🏐',
    '🏉',
    '🎳',
    '🏏',
    '🏑',
    '🏒',
    '🥍',
    '🏓',
    '🏸',
    '🥊',
    '🥋',
    '⚽️',
    '🥝',
    '🥑',
    '🥒',
    '🌶',
    '🌽',
    '🥕',
    '🥔',
    '🚀',
    '🛸',
    '🚁',
    '🧬',
    '🧪',
    '🧫',
    '🧯',
    '🧴',
    '🧷',
    '🧹',
    '🧺',
    '🧻',
    '🧼',
  ];
}
