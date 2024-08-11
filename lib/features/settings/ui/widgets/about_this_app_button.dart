import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class AboutThisAppButton extends ConsumerWidget {
  const AboutThisAppButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: CustomTheme.darkTheme().copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              surface: AppColors.backgroundColor,
            ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundColor,
        ),
        dialogBackgroundColor: AppColors.backgroundColor,
        canvasColor: AppColors.backgroundColor,
        cardColor: AppColors.backgroundColor,
        cardTheme: const CardTheme(
          color: AppColors.backgroundColor,
          surfaceTintColor: AppColors.backgroundColor,
        ),
      ),
      child: Builder(builder: (context) {
        return TextButton(
          onPressed: () async {
            final analyticsService = ref.read(analyticsServiceProvider);
            analyticsService.emitEvent('about_tapped', {});

            showAboutDialog(
              context: context,
              useRootNavigator: false,
              applicationIcon: Image.asset(
                'assets/app_icon.png',
                width: 75,
                height: 75,
              ),
              children: [
                ListTile(
                  onTap: () {
                    final analyticsService = ref.read(analyticsServiceProvider);
                    analyticsService
                        .emitEvent('terms_and_conditions_tapped', {});
                    const linkString = AppConstants.termsAndConditionsUrl;
                    final link = Uri.parse(linkString);
                    launchUrl(link);
                  },
                  title: const Text('Terms and Conditions'),
                ),
                ListTile(
                  onTap: () {
                    final analyticsService = ref.read(analyticsServiceProvider);
                    analyticsService.emitEvent('privacy_policy_tapped', {});
                    const linkString = AppConstants.privacyPolicyUrl;
                    final link = Uri.parse(linkString);
                    launchUrl(link);
                  },
                  title: const Text('Privacy Policy'),
                ),
                ListTile(
                  onTap: () {
                    final analyticsService = ref.read(analyticsServiceProvider);
                    analyticsService.emitEvent('source_code_tapped', {});
                    const linkString = AppConstants.sourceCodeUrl;
                    final link = Uri.parse(linkString);
                    launchUrl(link);
                  },
                  title: const Text('Source code'),
                ),
              ],
            );
          },
          child: const Text('About this app'),
        );
      }),
    );
  }
}
