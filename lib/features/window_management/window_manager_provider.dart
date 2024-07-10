import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../features.dart';

final windowManagerProvider = Provider.autoDispose<WindowManager>((ref) {
  return WindowManager.instance;
});

final windowManagementServiceProvider =
    Provider.autoDispose<WindowManagementService>(
  (ref) => MacOSWindowManagementService(ref),
);
