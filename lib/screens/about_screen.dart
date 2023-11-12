import 'package:flutter/material.dart';

import 'package:tarifa_luz/theme/style_app.dart';
import 'package:tarifa_luz/utils/constantes.dart';
import 'package:tarifa_luz/utils/read_file.dart';
import 'package:tarifa_luz/widgets/head_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: SafeArea(
        child: Container(
          decoration: StyleApp.mainDecoration,
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const HeadScreen(),
                const Icon(Icons.code, size: 60),
                Text(
                  'Versión $kVersion', // VERSION
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Copyleft 2020-2023\nJesús Cuerda (Webierta)',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const FittedBox(
                  child: Text('All Wrongs Reserved. Licencia GPLv3'),
                ),
                Divider(color: Theme.of(context).colorScheme.onBackground),
                const SizedBox(height: 10.0),
                const ReadFile(archivo: 'assets/files/about.txt'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
