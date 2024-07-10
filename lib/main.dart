import 'package:emoji_app/app.dart';
import 'package:emoji_app/features/features.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appInit = await Future.wait({
    SharedPreferences.getInstance(),
    if (AppConstants.isDesktopPlatform) ...{
      WindowManager.instance.ensureInitialized(),
    },
  });
  final sharedPreferences = appInit.first as SharedPreferences;

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesServiceProvider.overrideWithValue(
        SharedPreferencesService(sharedPreferences),
      ),
    ],
    child: Consumer(
      builder: (context, ref, child) {
        return ref.watch(initApplicationFuture).when(
              data: (_) => child ?? const SizedBox(),
              error: (e, st) {
                ref
                    .read(loggerServiceProvider)
                    .captureException(e, stackTrace: st);
                return MaterialApp(
                  theme: CustomTheme.darkTheme(),
                  home: Center(child: Text('Error initializing app: $e')),
                );
              },
              loading: () => const MaterialApp(
                home: Center(child: CircularProgressIndicator.adaptive()),
              ),
            );
      },
      child: const EmojiApp(),
    ),
  ));
}
