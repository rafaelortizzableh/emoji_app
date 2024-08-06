import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features.dart';

final allEmojiProvider = Provider.autoDispose<List<String>>((ref) {
  final shouldIncludeNewEmoji =
      ref.watch(shouldIncludeNewEmojiProvider).maybeWhen(
            data: (data) => data,
            orElse: () => false,
          );
  final shouldIncludeFlagEmoji =
      ref.watch(shouldIncludeFlagEmojiProvider).maybeWhen(
            data: (data) => data,
            orElse: () => false,
          );
  return EmojiClass.values
      .where((emojiClass) {
        switch (emojiClass) {
          case EmojiClass.newEmoji:
            return shouldIncludeNewEmoji;
          case EmojiClass.flag:
            return shouldIncludeFlagEmoji;
          default:
            return true;
        }
      })
      .map((emojiClass) => emojiClass.emoji)
      .flattened
      .toList();
});
