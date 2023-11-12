import 'package:flutter/material.dart';

import 'package:tarifa_luz/screens/about_screen.dart';
import 'package:tarifa_luz/screens/donate_screen.dart';
import 'package:tarifa_luz/screens/iconografia_screen.dart';
import 'package:tarifa_luz/screens/info_screen.dart';
import 'package:tarifa_luz/screens/settings_screen.dart';
import 'package:tarifa_luz/screens/storage_screen.dart';
import 'package:tarifa_luz/theme/style_app.dart';
import 'package:tarifa_luz/utils/constantes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.2, 0.5, 0.8, 0.7],
            colors: [
              /* Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.primary.withOpacity(0.7), */
              /* Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.primary.withOpacity(0.5),
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.primary.withOpacity(0.7), */
              StyleApp.primaryColorOpacity01,
              StyleApp.primaryColorOpacity05,
              StyleApp.primaryColorOpacity08,
              StyleApp.primaryColorOpacity07,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                        /* image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/drawer3.png'),
                      ), */
                        ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.7,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              'TARIFA LUZ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(color: StyleApp.accentColor),
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.7,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              'TARIFA ELÉCTRICA REGULADA (PVPC)',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Copyleft 2020-2023',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(
                          'Jesús Cuerda (Webierta)',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(
                          'All Wrongs Reserved. Licencia GPLv3',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Inicio'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.storage),
                    title: const Text('Histórico'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StorageScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Ajustes'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsScreen()));
                    },
                  ),
                  const DividerDrawer(),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Info'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InfoScreen()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.emoji_symbols),
                    title: const Text('Iconografía'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IconografiaScreen(),
                        ),
                      );
                    },
                  ),
                  const DividerDrawer(),
                  ListTile(
                    leading: const Icon(Icons.code),
                    title: const Text('About'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.local_cafe_outlined),
                    title: const Text('Donar'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const DonateScreen(), // TestScreen(),
                        ),
                      );
                    },
                  ),
                  /* const DividerDrawer(),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Salir'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      //DatabaseHelper database = DatabaseHelper();
                      //await database.close();
                      //SystemNavigator.pop();
                    },
                  ), */
                ],
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: Text(
                'Versión $kVersion',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Theme.of(context).colorScheme.background,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DividerDrawer extends StatelessWidget {
  const DividerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.onBackground,
      thickness: 0.4,
      indent: 20,
      endIndent: 20,
    );
  }
}
