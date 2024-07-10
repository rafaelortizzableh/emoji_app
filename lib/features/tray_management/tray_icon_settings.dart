class TrayIconSettings {
  const TrayIconSettings({
    this.showStatusOnTray = true,
    this.isStatusOnRightSide = true,
  });

  final bool showStatusOnTray;
  final bool isStatusOnRightSide;

  TrayIconSettings copyWith({
    bool? showStatusOnTray,
    bool? isStatusOnRightSide,
  }) {
    return TrayIconSettings(
      showStatusOnTray: showStatusOnTray ?? this.showStatusOnTray,
      isStatusOnRightSide: isStatusOnRightSide ?? this.isStatusOnRightSide,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrayIconSettings &&
        other.showStatusOnTray == showStatusOnTray &&
        other.isStatusOnRightSide == isStatusOnRightSide;
  }

  @override
  int get hashCode => showStatusOnTray.hashCode ^ isStatusOnRightSide.hashCode;

  @override
  String toString() =>
      'TrayIconSettings(showStatusOnTray: $showStatusOnTray, isStatusOnRightSide: $isStatusOnRightSide)';
}
