import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../features/features.dart';

/// https://www.figma.com/file/B1zYZ91atvlHnsXIj7pA8Z/Buzz?node-id=899%3A14630
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.isToggled,
    required this.onChanged,
    required this.isBlocked,
  });

  final bool isToggled;
  final bool isBlocked;
  final FutureOr Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        alignment: isToggled ? Alignment.centerRight : Alignment.centerLeft,
        children: [
          SizedBox(
            width: 37,
            height: 20,
            child: FittedBox(
              fit: BoxFit.contain,
              child: CupertinoSwitch(
                value: isToggled,
                onChanged: !isBlocked ? onChanged : null,
                thumbColor: AppColors.grey6,
                activeColor: AppColors.purple,
                trackColor: AppColors.grey3,
              ),
            ),
          ),
          if (!isBlocked && onChanged != null)
            Positioned(
              left: !isToggled ? 0 : null,
              right: isToggled ? 0 : null,
              child: _ToggleHover(
                isToggled: isToggled,
                onChanged: onChanged!,
              ),
            ),
        ],
      ),
    );
  }
}

class _ToggleHover extends StatefulWidget {
  const _ToggleHover({
    // ignore: unused_element
    super.key,
    required this.isToggled,
    required this.onChanged,
  });
  final bool isToggled;
  final Function(bool) onChanged;

  @override
  State<_ToggleHover> createState() => _ToggleHoverState();
}

class _ToggleHoverState extends State<_ToggleHover> {
  bool _hovered = false;
  static const _hoveredOpacity = 0.1;
  static const _hoverSize = 26.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.isToggled),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: _hovered ? SystemMouseCursors.click : MouseCursor.defer,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hoverColor,
          ),
          width: _hoverSize,
          height: _hoverSize,
        ),
      ),
    );
  }

  Color get _hoverColor {
    if (!_hovered) return Colors.transparent;
    return widget.isToggled
        ? AppColors.lightPurple.withOpacity(_hoveredOpacity)
        : AppColors.grey6.withOpacity(_hoveredOpacity);
  }
}
