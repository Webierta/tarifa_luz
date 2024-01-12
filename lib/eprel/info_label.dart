import 'package:flutter/material.dart';

import 'package:tarifa_luz/theme/style_app.dart';
import 'package:tarifa_luz/utils/read_file.dart';

class InfoLabel extends StatelessWidget {
  const InfoLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Etiqueta Energética'),
      ),
      body: SafeArea(
        child: Container(
          decoration: StyleApp.mainDecoration,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/eprel/EPREL.jpg'),
                const SizedBox(height: 20.0),
                const ReadFile(archivo: 'assets/files/info_label.txt'),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Modelos de etiqueta energética para algunas categorías de productos:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 10.0),
                AspectRatio(
                  aspectRatio: 1.3,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      //controller: controller,
                      physics: const ClampingScrollPhysics(),
                      itemCount: 6,
                      itemBuilder: (BuildContext context, int index) => Card(
                            child: Image.asset(
                              'assets/images/eprel/etiquetas/label${index + 1}.gif',
                            ),
                          )),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
