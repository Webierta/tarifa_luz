import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:tarifa_luz/theme/style_app.dart';

class InfoTokenScreen extends StatelessWidget {
  const InfoTokenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> launchURL(String url) async {
      if (!await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication)) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Could not launch $url'),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Token'),
      ),
      body: SafeArea(
        child: Container(
          decoration: StyleApp.mainDecoration,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Text(
                  'La aplicación dispone de dos métodos para ejecutar '
                  'la consulta de datos: con la API oficial (recomendado) '
                  'y desde un archivo.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20.0),
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      const TextSpan(
                        text:
                            'Para utilizar la API se necesita autentificarse con un código '
                            'de acceso personal (token) gestionado por el '
                            'Sistema de Información del Operador del Sistema (e·sios) desde ',
                      ),
                      TextSpan(
                        style: const TextStyle(
                          color: Colors.lightBlueAccent,
                          decoration: TextDecoration.underline,
                        ),
                        text: 'API para descarga de información.',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchURL(
                              'https://www.esios.ree.es/es/pagina/api'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Si no dispones de token deja el cuadro de texto vacío y la aplicación '
                  'descargará los datos desde un archivo (este proceso puede ser potencialmente '
                  'más lento, menos eficiente y más propenso a errores).',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20.0),
                const Icon(Icons.warning, color: Color(0xFFF44336), size: 60.0),
                //const SizedBox(height: 20.0),
                Text(
                  'IMPORTANTE',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Si utilizas un token como código de acceso al '
                  'sistema REData de REE, debes tener en cuenta la advertencia de realizar '
                  'un uso responsable de la API y no ejecutar peticiones masivas, '
                  'redundantes o innecesarias.\nEn REE se analiza la utilización de la API por '
                  'parte de los usuarios con el fin de detectar malas prácticas, siendo '
                  'cada usuario responsable del uso de su token personal. Esta aplicación '
                  'no asume ninguna responsabilidad sobre posibles acciones de REE '
                  'derivadas de un uso inadecuado o irresponsable de la API por parte de '
                  'los usuarios.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
