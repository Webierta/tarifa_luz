import 'package:flutter/material.dart';

import 'package:tarifa_luz/theme/style_app.dart';
import 'package:tarifa_luz/utils/shared_prefs.dart';
import 'package:tarifa_luz/screens/info_token_screen.dart';
import 'package:tarifa_luz/screens/main_screen.dart';

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
  bool autoSave = true;

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
      autoSave = sharedPrefs.autoSave;
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

  void setAutoSave(bool value) {
    setState(() => autoSave = value);
    sharedPrefs.autoSave = value;
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
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
    return WillPopScope(
      onWillPop: () {
        setToken();
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(isFirstLaunch: false),
          ),
        );
        return Future.value(true);
      },
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
                //padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      //horizontalTitleGap: 0,
                      //titleAlignment: ListTileTitleAlignment.top,
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
                      /* trailing: IconButton(
                        onPressed: setToken,
                        icon: const Icon(Icons.save),
                        // check_circle_outline_outlined
                        color: Theme.of(context).colorScheme.primary,
                        iconSize: 32,
                      ), */
                    ),
                    const Divider(
                      height: 40,
                      color: StyleApp.onBackgroundColor,
                    ),
                    ListTile(
                      horizontalTitleGap: 8,
                      title: const Text('Sincronización automática'),
                      subtitle: const Text(
                          'Al abrir la aplicación se consultan los últimos datos disponibles'),
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
                    ),
                    const Divider(
                      height: 40,
                      color: StyleApp.onBackgroundColor,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
