import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tray_manager/tray_manager.dart';

import '../features.dart';

/// A provider of the [TrayManager] provider.
final trayManagerProvider = Provider.autoDispose<TrayManager>(
  (_) => TrayManager.instance,
);

/// A provider that listens to the [randomEmojiProvider]
/// and updates the tray icon.
final trayIconUpdaterListenerProvider = Provider.autoDispose<void>(
  (ref) {
    _setEmoji(ref);

    ref.listen<String>(randomEmojiProvider.select((v) => v.$1), (_, emoji) {
      _setEmoji(ref);
    });

    ref.listen(trayIconTextSettingsProvider, (previous, next) {
      if (previous == next) return;
      if (!next.showStatusOnTray) return;
      _setEmoji(ref);
    });
  },
);

void _setEmoji(Ref ref) {
  final emoji = ref.read(randomEmojiProvider).$1;
  final isRightSide =
      ref.read(trayIconTextSettingsProvider).isStatusOnRightSide;

  final newValue = isRightSide ? ' | $emoji' : '$emoji | ';

  ref.read(trayManagerProvider).setTitle(newValue);
}
