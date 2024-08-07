import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/core.dart';
import '../../../features.dart';

class MenuBarSettings extends ConsumerWidget {
  const MenuBarSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typeOfTrayIcon = ref
        .watch(trayIconTypeProvider)
        .maybeWhen(data: (data) => data, orElse: () => null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Icon Settings',
          style: context.textTheme.titleMedium?.copyWith(
            color: AppColors.white90transparency,
          ),
        ),
        const SizedBox(height: 10.0),
        SettingTile(
          showOnOffSwitch: false,
          isSettingToggled: true,
          settingTitle: 'Icon color',
          settingSubtitle: 'Choose between colored and monochrome icons.',
          showBottomBorder: true,
          showTopBorder: true,
          children: [
            AppDualOptionSwitch(
              options: [
                AppOption(
                  callToAction: 'Monochrome',
                  type: AppOptionType.left,
                  isSelected: typeOfTrayIcon == TrayIconType.monochrome,
                  // Setting isWindows to false because we always want to show the
                  // `.png` icon asset for the menu bar icon.
                  iconAsset:
                      AppConstants.defaultMonochromeMenuIconAsset(isIco: false),
                ),
                AppOption(
                  callToAction: 'Color',
                  type: AppOptionType.right,
                  isSelected: typeOfTrayIcon != TrayIconType.monochrome,
                  // Setting isWindows to false because we always want to show the
                  // `.png` icon asset for the menu bar icon.
                  iconAsset:
                      AppConstants.defaultColorMenuIconAsset(isIco: false),
                ),
              ],
              onOptionPressed: (option) {
                ref.read(trayIconTypeProvider.notifier).updateTypeOfIcon(
                      option.type == AppOptionType.right
                          ? TrayIconType.color
                          : TrayIconType.monochrome,
                    );
              },
            ),
          ],
          onSettingToggled: (toggled) {
            ref.read(analyticsServiceProvider).emitEvent(
              'menu_bar_icon_style_changed',
              <String, dynamic>{
                'menu_bar_icon_style': toggled ? 'color' : 'monochrome',
              },
            );
            ref.read(trayIconTypeProvider.notifier).updateTypeOfIcon(
                  toggled ? TrayIconType.color : TrayIconType.monochrome,
                );
          },
        ),
        if (defaultTargetPlatform == TargetPlatform.macOS) ...[
          SettingTile(
            showOnOffSwitch: true,
            isSettingToggled:
                ref.watch(trayIconTextSettingsProvider).showStatusOnTray,
            settingTitle: 'Show current emoji on menu bar',
            settingSubtitle:
                'Whether the current emoji should be shown on the menu bar.',
            showBottomBorder: true,
            showTopBorder: true,
            onSettingToggled: (toggled) {
              // Analytics
              ref.read(analyticsServiceProvider).emitEvent(
                'status_on_tray_toggled',
                <String, dynamic>{
                  'status_on_tray': toggled,
                },
              );
              ref
                  .read(trayIconTextSettingsProvider.notifier)
                  .toggleStatusShownOnTray(toggled);
            },
            children: [
              AppDualOptionSwitch(
                isBlocked:
                    !ref.watch(trayIconTextSettingsProvider).showStatusOnTray,
                options: [
                  AppOption(
                    callToAction: 'Left side',
                    type: AppOptionType.left,
                    isSelected: !ref
                        .watch(trayIconTextSettingsProvider)
                        .isStatusOnRightSide,
                  ),
                  AppOption(
                    callToAction: 'Right side',
                    type: AppOptionType.right,
                    isSelected: ref
                        .watch(trayIconTextSettingsProvider)
                        .isStatusOnRightSide,
                  ),
                ],
                onOptionPressed: (option) {
                  final isStatusOnRightSide =
                      option.type == AppOptionType.right;

                  ref.read(analyticsServiceProvider).emitEvent(
                    'status_on_tray_position_changed',
                    <String, dynamic>{
                      'status_on_tray_position':
                          isStatusOnRightSide ? 'right' : 'left',
                    },
                  );
                  ref
                      .read(trayIconTextSettingsProvider.notifier)
                      .changeStatusPosition(
                        isStatusOnRightSide: isStatusOnRightSide,
                      );
                },
              ),
            ],
          ),
        ],
      ],
    );
  }
}
