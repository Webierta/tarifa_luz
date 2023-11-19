import 'package:flutter/material.dart';

class ThemeApp {
  final BuildContext context;
  const ThemeApp(this.context);

  ColorScheme get colorScheme => ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color(0xFF607D8B), // bluegrey
      );

  //Color get backgroundColor => Theme.of(context).colorScheme.background;

  //Color get onBackgroundColor => Theme.of(context).colorScheme.onBackground;

  //TextTheme get textTheme => GoogleFonts.latoTextTheme().merge(Typography().white);
  /* TextTheme get textTheme =>
      const TextTheme().apply(fontFamily: 'Lato').merge(Typography().white); */
  TextTheme get textTheme => const TextTheme().apply(fontFamily: 'CairoPlay');

  String get fontFamily => 'CairoPlay';

  TextStyle get bodyLarge => Theme.of(context).textTheme.bodyLarge!;
  TextStyle get titleSmall => Theme.of(context).textTheme.titleSmall!;
  TextStyle get labelMedium => Theme.of(context).textTheme.labelMedium!;

  FloatingActionButtonThemeData get floatingActionButtonTheme =>
      const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFFDE03),
        //foregroundColor: Color(0xFF0336FF),
        foregroundColor: Color(0xFF263238),
      );

  DialogTheme get dialogTheme =>
      DialogTheme(shadowColor: Theme.of(context).colorScheme.onBackground);

  BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      BottomNavigationBarThemeData(
        selectedItemColor: Theme.of(context).colorScheme.onBackground,
        unselectedItemColor:
            Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
      );
}
