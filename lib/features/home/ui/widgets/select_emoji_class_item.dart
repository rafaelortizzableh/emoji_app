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
        backgroundColor: _getBackgroundColor(
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

  Color? _getBackgroundColor({
    required bool isSelected,
    required bool isHovered,
    required bool isPressed,
  }) {
    if (AppConstants.isDesktopPlatform) {
      return _getDesktopBackgroundColor(
        isSelected: isSelected,
        isHovered: isHovered,
        isPressed: isPressed,
      );
    }
    if (isSelected) {
      return Colors.white.withValues(alpha: 0.1);
    }
    if (isPressed) {
      return Colors.white.withValues(alpha: 0.075);
    }

    if (isHovered) {
      return Colors.white.withValues(alpha: 0.05);
    }

    return null;
  }

  Color? _getDesktopBackgroundColor({
    required bool isSelected,
    required bool isHovered,
    required bool isPressed,
  }) {
    if (isSelected) {
      return Colors.indigo;
    }

    if (isPressed) {
      return AppColors.backgroundColor.withValues(alpha: 0.75);
    }

    if (isHovered) {
      return AppColors.backgroundColor.withValues(alpha: 0.5);
    }

    return AppColors.backgroundColor.withValues(alpha: 0.9);
  }
}
