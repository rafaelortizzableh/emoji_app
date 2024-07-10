import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/core.dart';
import 'features/features.dart';

class EmojiApp extends ConsumerWidget {
  const EmojiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return WindowListenersWrapper(
      child: MaterialApp.router(
        title: _title,
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.darkTheme(),
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider,
      ),
    );
  }

  static const _title = 'Random Emoji Generator';
}
