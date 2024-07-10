import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../../core/core.dart';

final windowOptionsProvider =
    StateNotifierProvider.autoDispose<WindowOptionsController, WindowOptions>(
  (ref) => WindowOptionsController(AppConstants.mainWindowOptions),
);

class WindowOptionsController extends StateNotifier<WindowOptions> {
  WindowOptionsController(super.state);

  void resetWindowOptions() {
    state = AppConstants.mainWindowOptions;
  }

  void updateWindowOptions(WindowOptions newOptions) {
    state = newOptions;
  }
}
