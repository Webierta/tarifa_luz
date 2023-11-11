import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:tarifa_luz/theme/theme_app.dart';
import 'package:tarifa_luz/widgets/head_screen.dart';

const String btcAddress = '15ZpNzqbYFx9P7wg4U438JMwZr2q3W6fkS';
const String urlPayPal =
    'https://www.paypal.com/donate?hosted_button_id=986PSAHLH6N4L';
const String urlGitHub = 'https://github.com/Webierta/tarifa_luz/issues';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeApp themeApp = ThemeApp(context);

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
      appBar: AppBar(title: const Text('Buy Me a Coffee')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
        child: Column(
          children: [
            const HeadScreen(),
            const Icon(Icons.favorite_border, size: 60),
            const Divider(),
            const SizedBox(height: 10.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Esta App es Software libre y de Código Abierto. Por favor considera colaborar '
                'para mantener activo el desarrollo de esta App.',
                style: themeApp.bodyLarge,
              ),
            ),
            const SizedBox(height: 20.0),
            Text.rich(
              TextSpan(
                style: themeApp.bodyLarge,
                children: [
                  const TextSpan(
                      text:
                          '¿Crees que has encontrado un problema? Identificar y corregir errores hace que '
                          'esta App sea mejor para todos. Informa de un error aquí: '),
                  TextSpan(
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                    text: 'GitHub issues.',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => launchURL(urlGitHub),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Puedes colaborar con el desarrollo de ésta y otras aplicaciones con una pequeña '
                'aportación a mi monedero de Bitcoins o vía PayPal.',
                style: themeApp.bodyLarge,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Scan this QR code with your wallet application:',
                  style: themeApp.bodyLarge,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Image.asset('assets/images/Bitcoin_QR.png'),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Or copy the BTC Wallet Address:',
                  style: themeApp.bodyLarge,
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onBackground,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(8.0),
                      decoration: ShapeDecoration(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.zero,
                            topRight: Radius.zero,
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          btcAddress,
                          style: TextStyle(color: themeApp.backgroundColor),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                style: BorderStyle.solid)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () async {
                          await Clipboard.setData(
                            const ClipboardData(text: btcAddress),
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('BTC Address copied to Clipboard.'),
                          ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Text(
                  'Donate via Paypal (open the PayPal payment website):',
                  style: themeApp.bodyLarge,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 10.0,
                  padding: const EdgeInsets.all(10),
                ),
                onPressed: () => launchURL(urlPayPal),
                child: Image.asset('assets/images/paypal_logo.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
