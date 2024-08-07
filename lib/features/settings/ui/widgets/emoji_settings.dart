import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/core.dart';
import '../../../features.dart';

class EmojiSettings extends ConsumerWidget {
  const EmojiSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emoji Settings',
          style: context.textTheme.titleMedium?.copyWith(
            color: AppColors.white90transparency,
          ),
        ),
        const SizedBox(height: 10.0),
        SettingTile(
          showOnOffSwitch: true,
          isSettingToggled: shouldIncludeNewEmoji,
          settingTitle: '${newEmoji.first} -> New emoji in random generator',
          settingSubtitle:
              'Whether the random emoji generator should include new emoji when no category is selected.',
          showBottomBorder: true,
          showTopBorder: true,
          onSettingToggled: (toggled) {
            ref.read(analyticsServiceProvider).emitEvent(
              'new_emoji_on_random_setting_toggled',
              <String, dynamic>{
                'new_emoji_setting': toggled,
              },
            );
            ref.read(shouldIncludeNewEmojiProvider.notifier).updateValue(
                  toggled,
                );
          },
        ),
        SettingTile(
          showOnOffSwitch: true,
          isSettingToggled: shouldIncludeFlagEmoji,
          settingTitle: '${flagEmoji.first} • Flag emoji in random generator',
          settingSubtitle:
              'Whether the random emoji generator should include flag emoji when no category is selected.',
          showBottomBorder: true,
          showTopBorder: true,
          onSettingToggled: (toggled) {
            ref.read(analyticsServiceProvider).emitEvent(
              'flag_emoji_on_random_setting_toggled',
              <String, dynamic>{
                'flag_emoji_setting': toggled,
              },
            );
            ref.read(shouldIncludeFlagEmojiProvider.notifier).updateValue(
                  toggled,
                );
          },
        ),
      ],
    );
  }
}
