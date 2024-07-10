import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features.dart';

final typeOfWindowProvider = StateNotifierProvider.autoDispose<
    TypeOfWindowController, TypeOfWindowState>(
  (ref) {
    return TypeOfWindowController(TypeOfWindowState.initial(), ref: ref);
  },
);

// /// This provider acts as a listener that closes all dialogs when
// /// the [TypeOfWindow] changes.
final popDialogsOnWindowChangedListenerProvider = Provider.autoDispose(
  (ref) {
    ref.listen(
      typeOfWindowProvider,
      (previous, next) {
        // // Early return if window hasn't changed.
        // if (previous == next) return;

        // // Getting current Navigation state.
        // final currentNavigationState =
        //     AppConstants.defaultNavigationKey.currentState;

        // // Early return if there's nothing to pop.
        // if (currentNavigationState?.canPop() != true) return;

        // // Getting current Context from navigation key.
        // final buildContext = currentNavigationState?.context;

        // // Early return to avoid using the context if it's null.
        // if (buildContext == null) return;

        // if (next.typeOfWindow != TypeOfWindow.home) {
        //   return;
        // }

        // /// This will close the dialogs when the window type has changed.
        // Navigator.of(buildContext).popUntil((route) {
        //   // Otherwise, dismiss the route.
        //   return route.isFirst;
        // });
      },
    );
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
