import 'package:flutter/material.dart';

import 'package:tarifa_luz/database/database.dart';
import 'package:tarifa_luz/database/storage.dart';
import 'package:tarifa_luz/screens/main_screen.dart';
import 'package:tarifa_luz/theme/style_app.dart';
import 'package:tarifa_luz/theme/theme_app.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});
  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  Storage storage = Storage();
  List<Database> dataBaseSort = [];

  @override
  void initState() {
    dataBaseSort = [...storage.sortByDate];
    super.initState();
  }

  Future<bool> confirmDelete() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final Color onBackgroundColor = ThemeApp(context).onBackgroundColor;
        return AlertDialog(
          title: Text(
            'Eliminar datos',
            style: TextStyle(color: onBackgroundColor),
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Esta acción elimina el archivo de todas las consultas almacenadas. '
                  'También puedes borrar los datos de una fecha '
                  'desplazándola hacia la izquierda.',
                ),
                SizedBox(height: 10),
                Text('¿Eliminar todas los registros?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  void showSnack(String title) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final snackbar = SnackBar(content: Text(title));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    final Color onBackgroundColor = ThemeApp(context).onBackgroundColor;
    return WillPopScope(
      onWillPop: () {
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
          title: const Text('Archivo'),
          actions: [
            IconButton(
              onPressed: () async {
                if (dataBaseSort.isEmpty) {
                  showSnack('Archivo sin datos. Nada que hacer');
                } else {
                  if (await confirmDelete() == true) {
                    storage.deleteDataBase();
                    setState(() => dataBaseSort.clear());
                  }
                }
              },
              icon: const Icon(Icons.delete_forever),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: StyleApp.mainDecoration,
            child: dataBaseSort.isEmpty
                ? Center(
                    child: Text(
                      'Archivo vacío',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: onBackgroundColor),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const ClampingScrollPhysics(),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Datos archivados',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: onBackgroundColor),
                          ),
                          Text(
                            'No requiere conexión a internet',
                            style: TextStyle(color: onBackgroundColor),
                          ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dataBaseSort.length,
                            itemBuilder: (BuildContext context, int index) {
                              Database item = dataBaseSort[index];
                              String itemFecha = item.fecha;
                              return Dismissible(
                                key: ValueKey(itemFecha),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  margin: Theme.of(context).cardTheme.margin,
                                  alignment: AlignmentDirectional.centerEnd,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .error
                                        .withOpacity(0.5),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Icon(Icons.delete),
                                  ),
                                ),
                                onDismissed: (direction) {
                                  showSnack(
                                      'Los datos del día ${item.fecha} han sido eliminados');
                                  dataBaseSort.remove(item);
                                  storage.deleteData(item);
                                  setState(() {
                                    dataBaseSort = [...storage.sortByDate];
                                  });
                                },
                                child: Card(
                                  child: ListTile(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainScreen(
                                          fecha: itemFecha,
                                          isFirstLaunch: false,
                                        ),
                                      ),
                                    ),
                                    leading: const Icon(Icons.today),
                                    title: Text(
                                      itemFecha,
                                      style:
                                          TextStyle(color: onBackgroundColor),
                                    ),
                                    trailing:
                                        const Icon(Icons.arrow_forward_ios),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}