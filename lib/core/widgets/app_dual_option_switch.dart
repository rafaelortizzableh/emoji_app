import 'package:flutter/material.dart';

enum AppOptionType {
  left,
  right,
}

typedef OnAppOptionPressed = void Function(AppOption option);

class AppOption {
  const AppOption({
    required this.callToAction,
    this.iconAsset,
    required this.type,
    required this.isSelected,
  });

  final String callToAction;
  final AppOptionType type;
  final String? iconAsset;
  final bool isSelected;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppOption &&
        other.callToAction == callToAction &&
        other.type == type &&
        other.iconAsset == iconAsset &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return callToAction.hashCode ^
        type.hashCode ^
        iconAsset.hashCode ^
        isSelected.hashCode;
  }
}

class AppDualOptionSwitch extends StatelessWidget {
  AppDualOptionSwitch({
    super.key,
    required this.options,
    required this.onOptionPressed,
  })  : assert(
          options.length == 2,
          '$AppDualOptionSwitch must have exactly 2 options',
        ),
        assert(
          options.first.isSelected != options.last.isSelected,
          'Only one option can be selected at a time',
        );
  final List<AppOption> options;
  final OnAppOptionPressed onOptionPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final option in options)
          _AppOptionButton(
            key: ObjectKey('$option'),
            option: option,
            onOptionPressed: onOptionPressed,
          ),
      ],
    );
  }
}

class _AppOptionButton extends StatelessWidget {
  const _AppOptionButton({
    super.key,
    required this.option,
    required this.onOptionPressed,
  });
  final AppOption option;
  final OnAppOptionPressed onOptionPressed;

  @override
  Widget build(BuildContext context) {
    final callToAction = option.callToAction;
    final iconAsset = option.iconAsset;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (iconAsset != null) ...[
          InkWell(
            onTap: () => onOptionPressed(option),
            child: Image.asset(
              iconAsset,
              height: 20,
              width: 20,
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (option.isSelected) ...[
          ElevatedButton(
            onPressed: null,
            child: Text(callToAction),
          ),
        ] else ...[
          TextButton(
            onPressed: () => onOptionPressed(option),
            child: Text(callToAction),
          ),
        ],
      ],
    );
  }
}
