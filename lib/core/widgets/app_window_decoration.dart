import 'package:flutter/material.dart';

import '../../features/features.dart';
import '../core.dart';

/// A Widget that wraps its child
/// in a [DecoratedBox] with a border,
/// background color, and border radius.
class AppWindowDecoration extends StatelessWidget {
  const AppWindowDecoration({
    super.key,
    this.borderRadius,
    this.border,
    this.backgroundColor,
    this.size,
    required this.child,
  });

  const AppWindowDecoration.withDefaultSize({
    super.key,
    this.borderRadius,
    this.border,
    this.backgroundColor,
    required this.child,
  }) : size = AppConstants.mainWindowDimensions;

  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    if (!AppConstants.isDesktopPlatform) {
      return child;
    }
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: size?.width,
              height: size?.height,
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.backgroundColor,
                borderRadius: borderRadius ?? AppConstants.defaultBorderRadius,
                border: border ??
                    Border.all(
                      color: AppColors.white15transparency,
                      width: 1,
                    ),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
