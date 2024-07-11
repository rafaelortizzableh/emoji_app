import 'package:flutter/material.dart';

class EmptyWindowPage extends StatelessWidget {
  const EmptyWindowPage({
    super.key,
  });

  static const routePath = '/empty';
  static const routeName = 'Empty';

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 0,
      height: 0,
      child: ColoredBox(color: Colors.transparent),
    );
  }
}
