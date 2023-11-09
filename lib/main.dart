import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:tarifa_luz/screens/main_screen.dart';
import 'package:tarifa_luz/theme/theme_app.dart';
import 'package:tarifa_luz/utils/constantes.dart';
import 'package:tarifa_luz/database/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DatabaseAdapter());
  await Hive.openBox<Database>(boxPVPC);
  runApp(const PrecioLuz());
}

class PrecioLuz extends StatelessWidget {
  const PrecioLuz({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeApp themeApp = ThemeApp(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TarifaLuz',
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('es', 'ES')],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: themeApp.colorScheme,
        textTheme: GoogleFonts.latoTextTheme(),
        floatingActionButtonTheme: themeApp.floatingActionButtonTheme,
        dialogTheme: themeApp.dialogTheme,
        bottomNavigationBarTheme: themeApp.bottomNavigationBarTheme,
      ),
      home: const MainScreen(),
    );
  }
}
