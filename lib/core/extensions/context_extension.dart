import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// export 'package:flutter_gen/gen_l10n/app_localizations.dart';

// extension AppLocalizationsExtension on BuildContext {
//   AppLocalizations get l10n => AppLocalizations.of(this);
// }

extension CustomExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}
