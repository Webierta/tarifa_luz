import 'package:flutter/material.dart';

class ThemeApp {
  static ColorScheme get colorScheme => ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color(0xFF607D8B), // bluegrey
      );

  //TextTheme get textTheme => GoogleFonts.latoTextTheme().merge(Typography().white);
  /* TextTheme get textTheme =>
      const TextTheme().apply(fontFamily: 'Lato').merge(Typography().white); */

  static TextTheme get textTheme =>
      const TextTheme().apply(fontFamily: 'CairoPlay');

  //static String get fontFamily => 'CairoPlay';

  static FloatingActionButtonThemeData get floatingActionButtonTheme =>
      const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFFDE03),
        //foregroundColor: Color(0xFF0336FF),
        foregroundColor: Color(0xFF263238),
      );

  static DialogTheme get dialogTheme =>
      const DialogTheme(shadowColor: Color(0xffffffff));

  static BottomNavigationBarThemeData get bottomNavigationBarTheme =>
      const BottomNavigationBarThemeData(
        selectedItemColor: Color(0xffffffff),
        unselectedItemColor: Colors.white38,
      );
}
