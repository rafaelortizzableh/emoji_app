// Note(rafaelortizzableh): Add new types of windows here.
import '../../features.dart';

enum TypeOfWindow { notification, settings, home, selectedTeammate, emojiRain }

class TypeOfWindowState {
  const TypeOfWindowState({
    required this.typeOfWindow,
    this.isResizingToSecondWindow = false,
  });
  factory TypeOfWindowState.initial() => const TypeOfWindowState(
        typeOfWindow: TypeOfWindow.home,
        isResizingToSecondWindow: false,
      );

  /// The type of the currently visible window.
  final TypeOfWindow typeOfWindow;

  /// Whether the current window is resizing
  /// to provide space for the second window.
  final bool isResizingToSecondWindow;

  TypeOfWindowState copyWith({
    TypeOfWindow? typeOfWindow,
    bool? isResizingToSecondWindow,
  }) {
    return TypeOfWindowState(
      typeOfWindow: typeOfWindow ?? this.typeOfWindow,
      isResizingToSecondWindow:
          isResizingToSecondWindow ?? this.isResizingToSecondWindow,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TypeOfWindowState &&
        other.typeOfWindow == typeOfWindow &&
        other.isResizingToSecondWindow == isResizingToSecondWindow;
  }

  @override
  int get hashCode => typeOfWindow.hashCode ^ isResizingToSecondWindow.hashCode;

  @override
  String toString() =>
      'TypeOfWindowState(typeOfWindow: $typeOfWindow, isResizingToSecondWindow: $isResizingToSecondWindow)';
}

extension RouteNameExtension on TypeOfWindow {
  static const _home = HomePage.routeName;
  static const _settings = SettingsPage.routeName;
  static const _notification = 'Notifications';
  static const _selectedTeammate = 'Selected_Teammate';
  static const _emojiRain = EmojiRainPage.routeName;

  String get routeName {
    switch (this) {
      case TypeOfWindow.home:
        return _home;
      case TypeOfWindow.settings:
        return _settings;
      case TypeOfWindow.notification:
        return _notification;
      case TypeOfWindow.selectedTeammate:
        return _selectedTeammate;
      case TypeOfWindow.emojiRain:
        return _emojiRain;
    }
  }

  String get routePath {
    switch (this) {
      case TypeOfWindow.home:
        return HomePage.routePath;
      case TypeOfWindow.settings:
        return SettingsPage.routePath;
      case TypeOfWindow.emojiRain:
        return EmojiRainPage.routePath;
      case TypeOfWindow.notification:
        return _notification;
      case TypeOfWindow.selectedTeammate:
        return _selectedTeammate;
    }
  }
}
