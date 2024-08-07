import 'dart:async';

import 'package:emoji_app/core/core.dart';
import 'package:flutter/material.dart';

import '../../../features.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.showOnOffSwitch,
    this.isSettingBlocked = false,
    required this.isSettingToggled,
    required this.settingTitle,
    this.settingSubtitle,
    required this.showBottomBorder,
    required this.showTopBorder,
    required this.onSettingToggled,
    this.padding = const EdgeInsets.symmetric(vertical: 9.0),
    this.borderWidth = 1.0,
    this.borderColor = AppColors.white15transparency,
    this.titleColor = AppColors.white90transparency,
    this.subtitleColor = AppColors.white50transparency,
    this.children = const [],
  }) : assert(!showOnOffSwitch ||
            (showOnOffSwitch &&
                isSettingToggled != null &&
                onSettingToggled != null));

  final bool showOnOffSwitch;
  final bool? isSettingToggled;
  final FutureOr<void> Function(bool)? onSettingToggled;
  final bool isSettingBlocked;
  final String settingTitle;
  final String? settingSubtitle;
  final bool showBottomBorder;
  final bool showTopBorder;
  final EdgeInsets padding;
  final double borderWidth;
  final Color borderColor;
  final Color titleColor;
  final Color subtitleColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border(
          bottom: showBottomBorder
              ? BorderSide(
                  width: borderWidth,
                  color: borderColor,
                )
              : BorderSide.none,
          top: showTopBorder
              ? BorderSide(
                  width: borderWidth,
                  color: borderColor,
                )
              : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        settingTitle,
                        style: context.textTheme.bodyLarge,
                      ),
                      if (settingSubtitle != null)
                        Text(
                          settingSubtitle!,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColors.white50transparency,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (showOnOffSwitch) ...[
                const SizedBox(width: 16.0),
                AppSwitch(
                  isBlocked: isSettingBlocked,
                  isToggled: isSettingToggled ?? false,
                  onChanged: (newValue) async =>
                      await onSettingToggled?.call(newValue),
                ),
              ],
              if (children.isNotEmpty) ...[
                const SizedBox(width: 16.0),
                ...children,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
