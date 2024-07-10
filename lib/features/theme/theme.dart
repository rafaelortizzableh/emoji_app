import 'package:flutter/material.dart';

import 'colors.dart';
import 'theme_fonts.dart';

export 'colors.dart';
export 'text_styles.dart';
export 'theme_fonts.dart';

class CustomTheme {
  static ThemeData darkTheme() {
    final theme = ThemeData.dark();
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: AppColors.purple,
        surface: Colors.transparent,
      ),
      // The canvasColor, backgroundColor, scaffoldBackgroundColor
      // properties are transparent so we can
      // show multiple windows side by side.
      canvasColor: Colors.transparent,
      scaffoldBackgroundColor: Colors.transparent,
      fontFamily: ThemeFonts.inter,
      textSelectionTheme: theme.textSelectionTheme.copyWith(
        cursorColor: AppColors.white75transparency,
      ),
      textTheme: theme.textTheme.copyWith(
        bodyLarge: theme.textTheme.bodyLarge?.copyWith(
          fontFamily: ThemeFonts.inter,
          fontWeight: FontWeight.w400,
        ),
        displayLarge: theme.textTheme.displayLarge?.copyWith(
          fontFamily: ThemeFonts.inter,
          fontSize: 25.0,
          fontWeight: FontWeight.w500,
          height: 30 / 25,
        ),
        displayMedium: theme.textTheme.displayMedium?.copyWith(
          fontFamily: ThemeFonts.inter,
          fontWeight: FontWeight.w500,
          fontSize: 18.0,
          height: 24 / 18,
        ),
        displaySmall: theme.textTheme.displaySmall?.copyWith(
          fontFamily: ThemeFonts.inter,
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
          height: 20 / 14,
          color: AppColors.white90transparency,
        ),
        headlineMedium: theme.textTheme.headlineMedium?.copyWith(
          fontFamily: ThemeFonts.inter,
          fontWeight: FontWeight.w500,
          fontSize: 12.0,
          height: 19 / 12,
          color: AppColors.grey6,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.grey6.withOpacity(0.5);
            }

            if (states.contains(WidgetState.selected)) {
              return AppColors.purple;
            }

            return AppColors.grey6.withOpacity(0.5);
          },
        ),
        thumbColor: WidgetStateProperty.resolveWith<Color>(
          (states) {
            return AppColors.grey6;
          },
        ),
      ),
    );
  }
}
