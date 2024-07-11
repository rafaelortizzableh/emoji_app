import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/features.dart';
import '../core.dart';

final routerProvider = Provider.autoDispose<GoRouter>(
  (ref) {
    return GoRouter(
      routes: [
        GoRoute(
          path: EmptyWindowPage.routePath,
          name: EmptyWindowPage.routeName,
          parentNavigatorKey: AppConstants.defaultNavigationKey,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              transitionDuration: 0.milliseconds,
              reverseTransitionDuration: 0.milliseconds,
              name: EmptyWindowPage.routeName,
              transitionsBuilder: (_, __, ___, child) => child,
              child: const EmptyWindowPage(),
            );
          },
        ),
        GoRoute(
          path: HomePage.routePath,
          name: HomePage.routeName,
          parentNavigatorKey: AppConstants.defaultNavigationKey,
          pageBuilder: (context, state) {
            if (!AppConstants.isDesktopPlatform) {
              return const MaterialPage(
                name: HomePage.routeName,
                child: HomePage(),
              );
            }

            return CustomTransitionPage(
              name: HomePage.routeName,
              child: const HomePage(),
              transitionDuration: const Duration(milliseconds: 0),
              reverseTransitionDuration: const Duration(milliseconds: 0),
              transitionsBuilder: (context, animation, _, child) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                );
              },
            );
          },
        ),
        GoRoute(
          path: EmojiRainPage.routePath,
          name: EmojiRainPage.routeName,
          parentNavigatorKey: AppConstants.defaultNavigationKey,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              name: EmojiRainPage.routeName,
              child: const EmojiRainPage(),
              opaque: true,
              transitionDuration: const Duration(milliseconds: 0),
              reverseTransitionDuration: const Duration(milliseconds: 0),
              transitionsBuilder: (context, animation, _, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: SettingsPage.routePath,
          name: SettingsPage.routeName,
          parentNavigatorKey: AppConstants.defaultNavigationKey,
          pageBuilder: (context, state) {
            if (!AppConstants.isDesktopPlatform) {
              return const MaterialPage(
                name: SettingsPage.routeName,
                child: SettingsPage(),
              );
            }

            return CustomTransitionPage(
              name: SettingsPage.routeName,
              child: const SettingsPage(),
              transitionDuration: const Duration(milliseconds: 300),
              reverseTransitionDuration: const Duration(milliseconds: 50),
              transitionsBuilder: (
                context,
                animation,
                reverseAnimation,
                child,
              ) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.5, -0.5),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeOut)).animate(animation),
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.5,
                      end: 1,
                    )
                        .chain(CurveTween(curve: Curves.easeOut))
                        .animate(animation),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
      navigatorKey: AppConstants.defaultNavigationKey,
      initialLocation: HomePage.routePath,
    );
  },
);
