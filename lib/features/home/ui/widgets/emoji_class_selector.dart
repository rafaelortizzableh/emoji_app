import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class EmojiClassSelector extends ConsumerWidget {
  const EmojiClassSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEmojiClass = ref.watch(emojiClassProvider);

    return SizedBox(
      height: AppConstants.isDesktopPlatform ? 30 : 50,
      child: Row(
        children: [
          const SizedBox(width: 16),
          const EditorialEmojiButton(),
          const SizedBox(width: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(right: 16),
              scrollDirection: Axis.horizontal,
              itemCount: EmojiClass.values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final emojiClass = EmojiClass.values[index];
                return SelectEmojiClassItem(
                  onTap: (EmojiClass emojiClass) => onTap(
                    emojiClass: emojiClass,
                    ref: ref,
                  ),
                  emojiClass: emojiClass,
                  isSelected: selectedEmojiClass == emojiClass,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void onTap({
    required EmojiClass emojiClass,
    required WidgetRef ref,
  }) {
    HapticFeedback.mediumImpact().ignore();
    final event = emojiClass == ref.read(emojiClassProvider)
        ? 'emoji_class_unselected'
        : 'emoji_class_selected';
    ref.read(editorialEmojiCategorySelectedProvider.notifier).state = false;
    ref.read(emojiClassProvider.notifier).setEmojiClass(emojiClass);
    ref.read(analyticsServiceProvider).emitEvent(
      event,
      <String, dynamic>{
        'emoji_class': emojiClass.label,
      },
    );
  }
}
