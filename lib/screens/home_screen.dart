import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarifa_luz/database/box_data.dart';
import 'package:tarifa_luz/database/storage.dart';
import 'package:tarifa_luz/graphics/grafico_precios.dart';
import 'package:tarifa_luz/models/http_request_api.dart';
import 'package:tarifa_luz/tabs/home_tab.dart';
import 'package:tarifa_luz/tabs/precios_tab.dart';
import 'package:tarifa_luz/tabs/timelapse_tab.dart';
import 'package:tarifa_luz/theme/style_app.dart';
import 'package:tarifa_luz/utils/estados.dart';
import 'package:tarifa_luz/utils/shared_prefs.dart';
import 'package:tarifa_luz/widgets/app_drawer.dart';
import 'package:tarifa_luz/widgets/main_body_widgets.dart';

class HomeScreen extends StatefulWidget {
  final DateTime? fecha;
  final bool isFirstLaunch;
  const HomeScreen({
    this.fecha,
    this.isFirstLaunch = false,
    super.key,
  });
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFirstLaunch = false;
  int currentTab = 0;

  late ScrollController scrollController;

  final SharedPrefs sharedPrefs = SharedPrefs();
  //bool? autoGetData;

  HttpStatus httpStatus = HttpStatus.stopped;

  Storage storage = Storage();
  List<BoxData> listBoxData = [];
  BoxData? boxDataSelect;

  @override
  void initState() {
    Intl.defaultLocale = 'es_ES';
    isFirstLaunch = widget.isFirstLaunch;
    loadSharedPrefs();
    scrollController = ScrollController();
    listBoxData = storage.listBoxDataSort;
    initApp();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void loadSharedPrefs() async => await sharedPrefs.init();

  void initApp() async {
    await sharedPrefs.init();
    DateTime fecha;
    final DateTime hoy = DateTime.now().toLocal();
    if (widget.fecha != null) {
      fecha = widget.fecha!;
      boxDataSelect = storage.getBoxData(fecha);
      loadBoxData();
    } else if (isFirstLaunch && sharedPrefs.autoGetData == true) {
      fecha = hoy.hour < 21 ? hoy : DateTime.now().add(const Duration(days: 1));
      if (storage.fechaInBoxData(fecha)) {
        boxDataSelect = storage.getBoxData(fecha);
        loadBoxData();
      } else {
        httpBoxData(fecha);
      }
    } else if (widget.fecha == null && storage.listBoxData.isNotEmpty) {
      fecha = storage.lastFecha;
      boxDataSelect = storage.getBoxData(fecha);

      if (sharedPrefs.maxArchivo != 0) {
        while (storage.listBoxData.length > sharedPrefs.maxArchivo) {
          storage.deleteFirst();
        }
      }

      loadBoxData();
    } else {
      fecha = hoy;
    }
  }

  void loadBoxData() {
    setState(() {
      listBoxData = storage.listBoxDataSort;
      httpStatus = HttpStatus.completed;
    });
  }

  void resetHomeScreen() {
    setState(() {
      isFirstLaunch = false;
      loadSharedPrefs();
      currentTab = 0;
    });
    loadBoxData();
  }

  void httpBoxData([DateTime? fechaSelect]) async {
    if (fechaSelect != null) {
      setState(() => isFirstLaunch = false);
    }
    fechaSelect = fechaSelect ?? DateTime.now().toLocal();

    if (isFirstLaunch == false && storage.fechaInBoxData(fechaSelect)) {
      Response? response = await openDialog(
        Alert.archived,
        fechaDuple: fechaSelect,
      );
      if (response == Response.cancel || response == null) {
        return;
      } else if (response == Response.go) {
        setState(() {
          boxDataSelect = storage.getBoxData(fechaSelect!);
        });
        loadBoxData();
        return;
      }
    } else if (isFirstLaunch == true && storage.fechaInBoxData(fechaSelect)) {
      return;
    }
    // INICIO CONSULTA
    setState(() => httpStatus = HttpStatus.api);
    HttpRequestApi httpRequestApi = HttpRequestApi();
    httpRequestApi.fecha = DateFormat('yyyy-MM-dd').format(fechaSelect);
    await httpRequestApi.getPreciosHoras(httpRequestApi.fecha);

    if (httpRequestApi.status != Status.ok) {
      setState(() => httpStatus = HttpStatus.file);
      await httpRequestApi.getPreciosHorasFile(httpRequestApi.fecha);
    }

    if (httpRequestApi.status != Status.ok) {
      if (!context.mounted) return;
      CheckStatusError(httpRequestApi.status, context).showError();
      // setState(() => httpStatus = HttpStatus.completed);
      // resetHomeScreen()
    } else {
      setState(() => httpStatus = HttpStatus.generacion);
      await httpRequestApi.getDatosGeneracion(httpRequestApi.fecha);

      //if (sharedPrefs.autoSave == true) {
      storage.saveBoxData(
        BoxData(
          fecha: fechaSelect,
          preciosHora: httpRequestApi.preciosHora,
          mapRenovables: httpRequestApi.mapRenovables,
          mapNoRenovables: httpRequestApi.mapNoRenovables,
        ),
      );
      setState(() {
        boxDataSelect = storage.getBoxData(fechaSelect!);
      });
      if (sharedPrefs.maxArchivo != 0) {
        while (storage.listBoxData.length > sharedPrefs.maxArchivo) {
          storage.deleteFirst();
        }
      }
      loadBoxData();
    }
  }

  bool get isLastFecha {
    setState(() => listBoxData = storage.listBoxDataSort);
    int currentIndex =
        listBoxData.indexWhere((e) => e.fecha == boxDataSelect?.fecha);
    return currentIndex == 0;
  }

  bool get isFirstFecha {
    setState(() => listBoxData = storage.listBoxDataSort);
    int currentIndex =
        listBoxData.indexWhere((e) => e.fecha == boxDataSelect?.fecha);
    return (currentIndex == listBoxData.length - 1);
  }

  void nextBoxData() {
    setState(() => listBoxData = storage.listBoxDataSort);
    int currentIndex =
        listBoxData.indexWhere((e) => e.fecha == boxDataSelect?.fecha);
    if (currentIndex < listBoxData.length - 1) {
      BoxData nextBoxData = listBoxData[currentIndex + 1];
      setState(() => boxDataSelect = nextBoxData);
      loadBoxData();
    }
  }

  void prevBoxData() {
    setState(() => listBoxData = storage.listBoxDataSort);
    int currentIndex =
        listBoxData.indexWhere((e) => e.fecha == boxDataSelect?.fecha);
    if (currentIndex > 0) {
      BoxData prevBoxData = listBoxData[currentIndex - 1];
      setState(() => boxDataSelect = prevBoxData);
      loadBoxData();
    }
  }

  selectDate() async {
    final DateTime hoy = DateTime.now().toLocal();
    DateTime manana = DateTime(hoy.year, hoy.month, hoy.day + 1);
    DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('es', 'ES'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2021, 6),
      lastDate: manana,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) {
      //bool dataNotYet = picked.difference(hoy).inDays > 1;
      if (picked == manana && hoy.hour < 20) {
        if (await openDialog(Alert.notyet) == Response.ok) {
          httpBoxData(picked);
        }
      } else {
        httpBoxData(picked);
      }
    }
  }

  Future<Response>? openDialog(Alert alert, {DateTime? fechaDuple}) async {
    String title = 'Fecha en Archivo';
    String fechaString = fechaDuple != null
        ? DateFormat('d MMM yy').format(fechaDuple)
        : 'ese día';
    String content =
        'Los datos de $fechaString ya han sido consultados y están archivados. '
        'Puedes verlos en el histórico de consultas.\n'
        'Continuar con la consulta sobreescribe los datos almacenados.';
    if (alert == Alert.notyet) {
      title = 'No publicado';
      content = 'En torno a las 20:15h de cada día, la REE publica los precios '
          'de la electricidad que se aplicarán al día siguiente, por lo que '
          'es posible que los datos todavía no estén publicados.';
    }
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(Response.cancel),
            ),
            if (alert == Alert.archived)
              TextButton(
                onPressed: () => Navigator.pop(context, Response.go),
                child: const Text('Ver'),
              ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(Response.ok),
            )
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
    BoxData? newBoxData;
    if (boxDataSelect != null) {
      setState(() {
        listBoxData = storage.listBoxDataSort;
        //newBoxData = boxDataSelect!;
        newBoxData = boxDataSelect!.copyWith(
          fecha: boxDataSelect!.fecha,
          preciosHora: boxDataSelect!.preciosHora,
          mapRenovables: boxDataSelect!.mapRenovables,
          mapNoRenovables: boxDataSelect!.mapNoRenovables,
        );
      });
    }

    Widget mainBody = MainBodyEmpty(tokenSaved: sharedPrefs.token);
    if (httpStatus == HttpStatus.started ||
        httpStatus == HttpStatus.api ||
        httpStatus == HttpStatus.file ||
        httpStatus == HttpStatus.generacion) {
      mainBody = MainBodyStarted(stringProgress: httpStatus.textProgress);
    } else if (httpStatus == HttpStatus.completed &&
        listBoxData.isNotEmpty &&
        newBoxData != null) {
      mainBody = SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          controller: scrollController,
          child: switch (currentTab) {
            0 => HomeTab(boxData: newBoxData!),
            1 => PreciosTab(
                tab: currentTab,
                boxData: newBoxData!,
              ),
            2 => PreciosTab(
                tab: currentTab,
                boxData: newBoxData!,
              ),
            3 => TimelapseTab(boxData: newBoxData!),
            int() => HomeTab(boxData: newBoxData!),
          },
        ),
      );
    }

    FloatingActionButton? floatingActionButton() {
      if (currentTab == 3) {
        return FloatingActionButton(
          onPressed: () {
            setState(() => isFirstLaunch = false);
            httpBoxData();
          },
          child: const Icon(Icons.update, size: 42),
        );
      }

      if (currentTab == 0) {
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GraficoPrecios(boxData: newBoxData!),
              ),
            );
          },
          child: const Icon(Icons.bar_chart, size: 42),
        );
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarifa Luz'),
        actions: [
          IconButton(
            onPressed:
                (listBoxData.length > 1 && !isFirstFecha) ? nextBoxData : null,
            icon: const Icon(Icons.skip_previous),
          ),
          IconButton(
            onPressed:
                (listBoxData.length > 1 && !isLastFecha) ? prevBoxData : null,
            icon: const Icon(Icons.skip_next),
          ),
          IconButton(
            onPressed: selectDate,
            icon: const Icon(Icons.today),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: ((int item) {
              switch (item) {
                case 0:
                  showSnack(
                    'Los datos del día ${newBoxData!.fechaddMMyy} han sido eliminados',
                  );
                  setState(() {
                    listBoxData.remove(newBoxData);
                    listBoxData = storage.listBoxDataSort;
                    storage.deleteBoxData(newBoxData!);
                  });
                  resetHomeScreen();
                  initApp();
                  loadBoxData();
                case != 0:
                  break;
              }
            }),
            itemBuilder: (context) => const [
              PopupMenuItem<int>(
                value: 0,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 2),
                  dense: true,
                  leading: Icon(
                    Icons.delete,
                  ),
                  title: Text('Eliminar'),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: StyleApp.mainDecoration,
          child: mainBody,
        ),
      ),
      floatingActionButton: floatingActionButton(),
      bottomNavigationBar:
          // storage.listBoxData.isNotEmpty
          (listBoxData.isNotEmpty && httpStatus == HttpStatus.completed)
              ? BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.lightbulb_outline),
                      activeIcon: Icon(Icons.upgrade),
                      label: 'PVPC',
                      //backgroundColor: Colors.amber,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.euro_symbol),
                      activeIcon: Icon(Icons.upgrade),
                      label: 'PRECIO',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.access_time),
                      activeIcon: Icon(Icons.upgrade),
                      label: 'HORAS',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.timelapse),
                      activeIcon: Icon(Icons.upgrade),
                      label: 'FRANJAS',
                    ),
                  ],
                  currentIndex: currentTab,
                  onTap: (int index) {
                    scrollController.animateTo(
                      scrollController.position.minScrollExtent,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn,
                    );
                    if (currentTab != index) {
                      setState(() => currentTab = index);
                    }
                  },
                )
              : null,
    );
  }
}
