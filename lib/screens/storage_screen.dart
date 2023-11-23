import 'package:flutter/material.dart';

import 'package:tarifa_luz/database/box_data.dart';
import 'package:tarifa_luz/database/storage.dart';
import 'package:tarifa_luz/graphics/grafico_compare.dart';
import 'package:tarifa_luz/screens/home_screen.dart';
import 'package:tarifa_luz/theme/style_app.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});
  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  Storage storage = Storage();
  List<BoxData> listBoxData = [];
  Map<BoxData, bool> boxDataIsChecked = {};

  @override
  void initState() {
    listBoxData = [...storage.listBoxDataSort];
    boxDataIsChecked = {for (var e in listBoxData) e: false};
    super.initState();
  }

  List<BoxData> get getBoxDataTrue {
    List<BoxData> listBoxDataTrue = [];
    for (var e in boxDataIsChecked.entries) {
      if (e.value == true) {
        listBoxDataTrue.add(e.key);
      }
    }
    return listBoxDataTrue;
  }

  int get trueChecked {
    int isCheckedTrue = 0;
    for (var box in boxDataIsChecked.values) {
      if (box == true) {
        isCheckedTrue++;
      }
    }
    return isCheckedTrue;
  }

  Future<bool> confirmDelete() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Eliminar datos',
            style: TextStyle(color: StyleApp.onBackgroundColor),
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(isFirstLaunch: false),
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Archivo'),
          actions: [
            IconButton(
              onPressed: () async {
                if (listBoxData.isEmpty) {
                  showSnack('Archivo sin datos. Nada que hacer');
                } else {
                  if (await confirmDelete() == true) {
                    storage.clearBox();
                    setState(() {
                      listBoxData.clear();
                      boxDataIsChecked.clear();
                    });
                  }
                }
              },
              icon: const Icon(Icons.delete_forever),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: StyleApp.mainDecoration,
            height: double.infinity,
            child: listBoxData.isEmpty
                ? Center(
                    child: Text(
                      'Archivo vacío',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: StyleApp.onBackgroundColor),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    scrollDirection: Axis.vertical,
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Datos archivados',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: StyleApp.onBackgroundColor),
                        ),
                        const Text(
                          'No requiere conexión a internet.',
                          style: TextStyle(color: StyleApp.onBackgroundColor),
                        ),
                        const Text(
                          'Marca de 2 a 4 para comparar.',
                          style: TextStyle(color: StyleApp.onBackgroundColor),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listBoxData.length,
                          itemBuilder: (BuildContext context, int index) {
                            //Database item = dataBaseSort[index];
                            //String itemFecha = item.fecha;
                            BoxData item = listBoxData[index];
                            String itemFecha = item.fechaddMMyy;

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
                                    'Los datos del día ${item.fechaddMMyy} han sido eliminados');
                                listBoxData.remove(item);
                                storage.deleteBoxData(item);
                                setState(() {
                                  listBoxData = [...storage.listBoxDataSort];
                                  boxDataIsChecked.remove(item);
                                });
                              },
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentSnackBar();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                          fecha: item.fecha,
                                          isFirstLaunch: false,
                                        ),
                                      ),
                                    );
                                  },
                                  leading: Checkbox(
                                    value: boxDataIsChecked[item],
                                    onChanged: (bool? value) {
                                      if (value == true) {
                                        trueChecked < 4
                                            ? setState(() =>
                                                boxDataIsChecked[item] = true)
                                            : showSnack('Máximo 4 fechas.');
                                      } else if (value == false) {
                                        setState(() =>
                                            boxDataIsChecked[item] = false);
                                      }
                                    },
                                  ),
                                  title: Text(
                                    itemFecha,
                                    style: const TextStyle(
                                      color: StyleApp.onBackgroundColor,
                                    ),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios),
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
        floatingActionButton: trueChecked > 1 && listBoxData.isNotEmpty
            ? FloatingActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GraficoCompare(boxDataList: getBoxDataTrue),
                    ),
                  );
                },
                child: const Icon(
                  Icons.area_chart_rounded,
                  size: 42,
                ),
              )
            : null,
      ),
    );
  }
}
