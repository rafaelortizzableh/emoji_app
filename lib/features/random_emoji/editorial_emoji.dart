import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/core.dart';

final editorialEmojiCategorySelectedProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

final editorialEmojiFutureProvider = FutureProvider.autoDispose<List<String>>(
  (ref) async {
    try {
      final dio = Dio();
      final result = await dio.get(AppConstants.editorialEmojiEndpoint);
      final emoji = List<String>.from(result.data['emoji']);
      return emoji;
    } catch (e) {
      return editorialEmoji;
    }
  },
);

const editorialEmoji = [
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
