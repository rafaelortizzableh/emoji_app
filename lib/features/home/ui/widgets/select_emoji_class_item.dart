import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class SelectEmojiClassItem extends HookWidget {
  const SelectEmojiClassItem({
    super.key,
    required this.onTap,
    required this.emojiClass,
    required this.isSelected,
  });

  final Function(EmojiClass emojiClass) onTap;
  final EmojiClass emojiClass;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final hovered = useState(false);
    final clicked = useState(false);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: getBackgroundColor(
          isSelected: isSelected,
          isHovered: hovered.value,
          isPressed: clicked.value,
        ),
        padding: AppConstants.isDesktopPlatform
            ? const EdgeInsets.symmetric(vertical: 0, horizontal: 8)
            : null,
      ),
      onPressed: () => onTap(emojiClass),
      label: Text(
        emojiClass.label,
        style:
            AppConstants.isDesktopPlatform ? context.textTheme.bodySmall : null,
      ),
      icon: Text(
        emojiClass.emoji.first,
        style: AppConstants.isDesktopPlatform
            ? context.textTheme.bodySmall
            : context.textTheme.titleLarge,
      ),
    );
  }

  Color? getBackgroundColor({
    required bool isSelected,
    required bool isHovered,
    required bool isPressed,
  }) {
    if (isSelected) {
      return Colors.white.withOpacity(0.1);
    }
    if (isPressed) {
      return Colors.white.withOpacity(0.075);
    }

    if (isHovered) {
      return Colors.white.withOpacity(0.05);
    }

    return null;
  }
}
