import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:tarifa_luz/database/box_data.dart';
import 'package:tarifa_luz/screens/home_screen.dart';
import 'package:tarifa_luz/theme/theme_app.dart';
import 'package:tarifa_luz/utils/constantes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BoxDataAdapter());
  await Hive.openBox<BoxData>(boxStore);
  runApp(const TarifaLuz());
}

class TarifaLuz extends StatelessWidget {
  const TarifaLuz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TarifaLuz',
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('es', 'ES')],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ThemeApp.colorScheme,
        //fontFamily: themeApp.fontFamily,
        textTheme: ThemeApp.textTheme,
        floatingActionButtonTheme: ThemeApp.floatingActionButtonTheme,
        dialogTheme: ThemeApp.dialogTheme,
        bottomNavigationBarTheme: ThemeApp.bottomNavigationBarTheme,
        //typography: Typography.whiteRedwoodCity,
        //scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const HomeScreen(isFirstLaunch: true),
    );
  }
}
