import 'package:collection/collection.dart';
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
    this.isBlocked = false,
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
  final bool isBlocked;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isBlocked,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...options.mapIndexed((index, option) {
            final isFirst = index == 0;
            return Padding(
              padding: EdgeInsets.only(left: isFirst ? 0 : 8),
              child: _AppOptionButton(
                key: ObjectKey('$option'),
                option: option,
                onOptionPressed: onOptionPressed,
                isBlocked: isBlocked,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AppOptionButton extends StatelessWidget {
  const _AppOptionButton({
    super.key,
    required this.option,
    required this.onOptionPressed,
    this.isBlocked = false,
  });

  final AppOption option;
  final OnAppOptionPressed onOptionPressed;
  final bool isBlocked;

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
            onPressed: isBlocked ? null : () => onOptionPressed(option),
            child: Text(callToAction),
          ),
        ],
      ],
    );
  }
}
