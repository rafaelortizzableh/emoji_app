import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features.dart';

final typeOfWindowProvider = StateNotifierProvider.autoDispose<
    TypeOfWindowController, TypeOfWindowState>(
  (ref) {
    return TypeOfWindowController(TypeOfWindowState.initial(), ref: ref);
  },
);

class TypeOfWindowController extends StateNotifier<TypeOfWindowState> {
  TypeOfWindowController(
    super.state, {
    required Ref ref,
  });

  void setHomeWindow() {
    state = state.copyWith(typeOfWindow: TypeOfWindow.home);
  }

  void setSettingsWindow() {
    state = state.copyWith(
      typeOfWindow: TypeOfWindow.settings,
    );
  }

  void setEmojiRainWindow() {
    state = state.copyWith(
      typeOfWindow: TypeOfWindow.emojiRain,
    );
  }

  void setNotificationWindow() {
    state = state.copyWith(
      typeOfWindow: TypeOfWindow.notification,
    );
  }

  void setSelectedTeammateWindow() {
    state = state.copyWith(
      typeOfWindow: TypeOfWindow.selectedTeammate,
      isResizingToSecondWindow: true,
    );
  }

  void toggleIsResizingToSecondWindow(bool isResizing) {
    state = state.copyWith(
      isResizingToSecondWindow: isResizing,
    );
  }
}
