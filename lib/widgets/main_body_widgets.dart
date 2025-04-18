import 'package:flutter/material.dart';
import 'package:tarifa_luz/screens/home_screen.dart';
import 'package:tarifa_luz/screens/settings_screen.dart';
import 'package:tarifa_luz/theme/style_app.dart';
import 'package:tarifa_luz/utils/estados.dart';

class MainBodyEmpty extends StatelessWidget {
  final String tokenSaved;
  const MainBodyEmpty({super.key, required this.tokenSaved});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height / 6),
            Text(
              'Uh oh... ¡sin datos!',
              style: textTheme.headlineLarge!.copyWith(
                color: StyleApp.onBackgroundColor,
              ),
            ),
            const SizedBox(height: 30),
            (tokenSaved == 'token' || tokenSaved == '')
                ? RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'La aplicación utiliza un código de acceso personal (token) como clave de '
                              'acceso al sistema REData de REE.\n\nUtiliza tu token y obtén más información en',
                          style: textTheme.bodyLarge!.copyWith(
                            color: StyleApp.onBackgroundColor,
                          ),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen()),
                              );
                            },
                            icon: const Icon(Icons.settings),
                            label: Text(
                              'Ajustes',
                              style: textTheme.bodyLarge!.copyWith(
                                color: StyleApp.onBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    'Descarga los últimos datos de la tarifa PVPC',
                    style: textTheme.bodyLarge!.copyWith(
                      color: StyleApp.onBackgroundColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class MainBodyStarted extends StatelessWidget {
  final String stringProgress;
  const MainBodyStarted({super.key, required this.stringProgress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stringProgress,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  //color: Theme.of(context).colorScheme.onBackground,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class CheckStatusError {
  final Status status;
  final BuildContext context;
  const CheckStatusError(this.status, this.context);

  (String, String) get tituloMsg {
    return switch (status) {
      Status.errorToken => (
          'Error Token',
          'Acceso denegado.\nComprueba tu token personal.'
        ),
      Status.noAcceso => ('Error', 'Error en la respuesta a la petición web'),
      Status.tiempoExcedido => (
          'Error',
          'Tiempo de conexión excedido sin respuesta del servidor.'
        ),
      Status.noPublicado => (
          'Error',
          'Es posible que los datos de mañana todavía no estén publicados.\n\n'
              'Vuelve a intentarlo más tarde.'
        ),
      Status.noInternet => ('Error', 'Comprueba tu conexión a internet.'),
      _ => (
          'Error',
          'Error obteniendo los datos.\n'
              'Comprueba tu conexión o vuelve a intentarlo pasados unos minutos.'
        ),
    };
  }

  showError() async {
    String titulo = tituloMsg.$1;
    String msg = tituloMsg.$2;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          iconColor: Theme.of(context).colorScheme.error,
          content: Text(msg),
          actions: [
            TextButton(
              child: const Text('Volver'),
              onPressed: () {
                Navigator.of(context).pop();
                // capturar back button  ???
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const HomeScreen(isFirstLaunch: false),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
