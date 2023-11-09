import 'package:flutter/material.dart';

class ThemeApp {
  final BuildContext context;
  const ThemeApp(this.context);

  ColorScheme get colorScheme => ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color(0xFF0336FF),
      );

  // Color(0xff1b1b1f)
  Color get backgroundColor => Theme.of(context).colorScheme.background;

  // Color(0xffe4e1e6)
  Color get onBackgroundColor => Theme.of(context).colorScheme.onBackground;

  FloatingActionButtonThemeData get floatingActionButtonTheme =>
      const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFFDE03),
        foregroundColor: Color(0xFF0336FF),
      );

  DialogTheme get dialogTheme => DialogTheme(
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: onBackgroundColor),
        contentTextStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: onBackgroundColor),
        shadowColor: onBackgroundColor,
      );

  BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      BottomNavigationBarThemeData(
        selectedItemColor: onBackgroundColor,
        unselectedItemColor: onBackgroundColor.withOpacity(0.5),
      );
}
