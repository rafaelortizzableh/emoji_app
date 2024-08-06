import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features.dart';

/// Provider for [EmojiClass] class.
final emojiClassProvider =
    StateNotifierProvider.autoDispose<EmojiClassController, EmojiClass?>((ref) {
  return EmojiClassController(null);
});

class EmojiClassController extends StateNotifier<EmojiClass?> {
  EmojiClassController(super.state);

  void setEmojiClass(EmojiClass emojiClass) {
    if (emojiClass == state) {
      state = null;
      return;
    }
    state = emojiClass;
  }
}
