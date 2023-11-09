import 'package:flutter/material.dart';

import 'package:tarifa_luz/utils/read_file.dart';
import 'package:tarifa_luz/widgets/head_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const HeadScreen(),
                const Icon(Icons.code, size: 60),
                Text(
                  'Versión 3.0.0', // VERSION
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                Text(
                  'Copyleft 2020-2023\nJesús Cuerda (Webierta)',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                  textAlign: TextAlign.center,
                ),
                FittedBox(
                  child: Text(
                    'All Wrongs Reserved. Licencia GPLv3',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                const Divider(),
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
