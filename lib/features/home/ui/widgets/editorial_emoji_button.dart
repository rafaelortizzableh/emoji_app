import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class EditorialEmojiButton extends ConsumerWidget {
  const EditorialEmojiButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(editorialEmojiCategorySelectedProvider);

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: getBackgroundColor(
          isSelected: isSelected,
        ),
        padding: AppConstants.isDesktopPlatform
            ? const EdgeInsets.symmetric(vertical: 0, horizontal: 8)
            : null,
      ),
      onPressed: () {
        HapticFeedback.heavyImpact().ignore();
        if (!isSelected) {
          ref.read(emojiClassProvider.notifier).clear();
        } else {
          ref.invalidate(editorialEmojiFutureProvider);
          ref.read(editorialEmojiFutureProvider);
        }

        final event = isSelected
            ? 'editorial_emoji_unselected'
            : 'editorial_emoji_selected';
        ref.read(editorialEmojiCategorySelectedProvider.notifier).state =
            !isSelected;
        ref.read(analyticsServiceProvider).emitEvent(
          event,
          <String, dynamic>{},
        );
      },
      label: Text(
        'Featured',
        style:
            AppConstants.isDesktopPlatform ? context.textTheme.bodySmall : null,
      ),
      icon: Text(
        '🤓',
        style: AppConstants.isDesktopPlatform
            ? context.textTheme.bodySmall
            : context.textTheme.titleLarge,
      ),
    );
  }

  Color? getBackgroundColor({
    required bool isSelected,
  }) {
    if (isSelected) {
      return Colors.indigo;
    }
    return Colors.indigo.withOpacity(0.33);
  }
}
