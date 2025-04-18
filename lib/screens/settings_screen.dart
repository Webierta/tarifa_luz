import 'package:flutter/material.dart';
import 'package:tarifa_luz/screens/home_screen.dart';
import 'package:tarifa_luz/screens/info_token_screen.dart';
import 'package:tarifa_luz/theme/style_app.dart';
import 'package:tarifa_luz/utils/shared_prefs.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final controllerToken = TextEditingController();
  final SharedPrefs sharedPrefs = SharedPrefs();
  String token = '';
  bool tokenVisible = false;
  bool autoGetData = true;
  //bool autoSave = true;
  int maxArchivo = 0;
  String maxArchivoText = 'Sin límite';

  @override
  void initState() {
    loadSharedPrefs();
    super.initState();
  }

  void loadSharedPrefs() async {
    await sharedPrefs.init();
    setState(() {
      token = sharedPrefs.token;
      autoGetData = sharedPrefs.autoGetData;
      //autoSave = sharedPrefs.autoSave;
      maxArchivo = sharedPrefs.maxArchivo;
      maxArchivoText = getMaxArchivoText(maxArchivo);
    });
    controllerToken.text = token;
  }

  void setToken() {
    token = controllerToken.text.trim().isEmpty ? '' : controllerToken.text;
    sharedPrefs.token = token;
    //if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Token guardado')),
    );
  }

  void setAutoGetData(bool value) {
    setState(() => autoGetData = value);
    sharedPrefs.autoGetData = value;
  }

  void setMaxArchivo(int value) {
    setState(() {
      maxArchivo = value;
      maxArchivoText = getMaxArchivoText(maxArchivo);
    });
    sharedPrefs.maxArchivo = value;
  }

  String getMaxArchivoText(int max) {
    return switch (max) {
      0 => 'Sin límite',
      7 => '7 fechas',
      30 => '30 fechas',
      _ => 'Sin límite',
    };
  }

  /* void setAutoSave(bool value) {
    setState(() => autoSave = value);
    sharedPrefs.autoSave = value;
  } */

  /* final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  ); */

  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  void dispose() {
    controllerToken.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        setToken();
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(isFirstLaunch: false),
          ),
        );
      },
      /* onPopInvoked: (didPop) {
        setToken();
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(isFirstLaunch: false),
          ),
        );
      }, */
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ajustes'),
        ),
        body: SafeArea(
          child: Container(
            decoration: StyleApp.mainDecoration,
            padding: const EdgeInsets.all(20),
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: TextField(
                      controller: controllerToken,
                      obscureText: !tokenVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        labelText: 'Token',
                        suffixIcon: IconButton(
                          icon: Icon(
                            tokenVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            if (tokenVisible) {
                              FocusScope.of(context).unfocus();
                            }
                            setState(() => tokenVisible = !tokenVisible);
                          },
                        ),
                      ),
                    ),
                    subtitle: TextButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InfoTokenScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Info sobre el token'),
                      style: TextButton.styleFrom(
                        alignment: Alignment.bottomLeft,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 40,
                    color: StyleApp.onBackgroundColor,
                  ),
                  ListTile(
                    horizontalTitleGap: 8,
                    title: const Text('Sincronización automática'),
                    subtitle: const Text(
                      'Al abrir la aplicación se consultan los últimos datos disponibles',
                    ),
                    trailing: Switch(
                      thumbIcon: thumbIcon,
                      value: autoGetData,
                      onChanged: (bool value) {
                        setAutoGetData(value);
                      },
                    ),
                  ),
                  const Divider(
                    height: 40,
                    color: StyleApp.onBackgroundColor,
                  ),
                  ListTile(
                    title: const Text('Límite en archivo'),
                    subtitle: const Text(
                        'Autoelimina los datos más antiguos. Si el archivo alcanza este límite, '
                        'las consultas de fechas previas no quedan almacenadas'),
                    trailing: PopupMenuButton<int>(
                      initialValue: maxArchivo,
                      icon: Text(
                        maxArchivoText,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      onSelected: (int value) {
                        setMaxArchivo(value);
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<int>(
                          value: 0,
                          child: Text('Sin límite'),
                        ),
                        const PopupMenuItem<int>(
                          value: 7,
                          child: Text('7 fechas'),
                        ),
                        const PopupMenuItem<int>(
                          value: 30,
                          child: Text('30 fechas'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 40,
                    color: StyleApp.onBackgroundColor,
                  ),
                  /* ListTile(
                      horizontalTitleGap: 8,
                      title: const Text('Guardado automático'),
                      subtitle: const Text(
                          'Archiva los datos en la página Histórico'),
                      trailing: Switch(
                        thumbIcon: thumbIcon,
                        value: autoSave,
                        onChanged: (bool value) {
                          setAutoSave(value);
                        },
                      ),
                    ), */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
