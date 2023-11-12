import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tarifa_luz/database/database.dart';
import 'package:tarifa_luz/database/storage.dart';
import 'package:tarifa_luz/models/datos.dart';
import 'package:tarifa_luz/models/datos_generacion.dart';
import 'package:tarifa_luz/screens/data_screen.dart';
import 'package:tarifa_luz/screens/settings_screen.dart';
import 'package:tarifa_luz/theme/style_app.dart';
import 'package:tarifa_luz/utils/estados.dart';
import 'package:tarifa_luz/utils/shared_prefs.dart';
import 'package:tarifa_luz/widgets/app_drawer.dart';
import 'package:tarifa_luz/widgets/graficos/grafico_precio.dart';

class MainScreen extends StatefulWidget {
  final String? fecha;
  final bool isFirstLaunch;
  const MainScreen({super.key, this.fecha, required this.isFirstLaunch});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isFirstLaunch = false;

  var currentTab = 0;
  late ScrollController scrollController;

  final SharedPrefs sharedPrefs = SharedPrefs();
  //String token = '';

  Datos datos = Datos();
  DatosGeneracion datosGeneracion = DatosGeneracion();
  DateTime hoy = DateTime.now().toLocal();
  late String fecha;

  bool dataNotYet = false;
  String txtProgress = '';
  ProcessGetData processGetData = ProcessGetData.stopped;
  bool mainBodyAutoSaveFalse = false;

  //bool dateStorage = false;
  Storage storage = Storage();
  List<Database> listDatabaseSort = [];

  void loadDataByDate(String fechaIn) {
    (String?, Datos?, DatosGeneracion?) getStorageLastDate =
        storage.getStorageByDate(fechaIn);
    if (getStorageLastDate.$1 != null && getStorageLastDate.$2 != null) {
      setState(() {
        fecha = getStorageLastDate.$1!;
        datos = getStorageLastDate.$2!;
        datosGeneracion = getStorageLastDate.$3 ?? datosGeneracion;
      });
    }
    setState(() {
      currentTab = 0;
      processGetData = ProcessGetData.completed; // aborted
    });
  }

  /* void deleteDataBase(Database item) {
    listDatabaseSort.remove(item);
    storage.deleteData(item);
    setState(() {
      listDatabaseSort = storage.sortByDate;
    });
  } */

  void loadSharedPrefs() async {
    await sharedPrefs.init();
    //setState(() => token = sharedPrefs.token);
  }

  @override
  void initState() {
    isFirstLaunch = widget.isFirstLaunch;
    Intl.defaultLocale = 'es_ES';
    loadSharedPrefs();
    scrollController = ScrollController();
    listDatabaseSort = storage.sortByDate;
    if (widget.fecha != null) {
      fecha = widget.fecha!;
      loadDataByDate(fecha);
    } else if (widget.isFirstLaunch && sharedPrefs.autoGetData == true) {
      // 1. ESTABLECER FECHA HOY si h < 20 y mañana si h > 20

      if (hoy.hour < 21) {
        fecha = DateFormat('dd/MM/yyyy').format(hoy);
      } else {
        //final DateTime manana = DateTime(hoy.year, hoy.month, hoy.day + 1);
        final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
        fecha = DateFormat('dd/MM/yyyy').format(tomorrow);
      }
      // 2. COMPROBAR SI FECHA EXISTE EN ARCHIVO
      if (storage.dateInDataBase(fecha)) {
        // 3. SI EXISTE: MOSTRAR
        loadDataByDate(fecha);
      } else {
        // 4. SI NO EXISTE: CONSULTAR COMO INITAPP (SIN MENSAJES?)
        getDatos(fechaSelect: fecha);
      }
    } else if (widget.fecha == null && storage.boxData.isNotEmpty) {
      fecha = storage.lastDate;
      loadDataByDate(fecha);
    } else {
      fecha = DateFormat('dd/MM/yyyy').format(hoy);
    }
    super.initState();
  }

  void resetMainScreen() {
    //loadSharedPrefs();
    setState(() {
      listDatabaseSort = storage.sortByDate;
      fecha = storage.lastDate;
      loadDataByDate(fecha);
      dataNotYet = false;
      txtProgress = '';
      processGetData = ProcessGetData.completed;
      mainBodyAutoSaveFalse = false;
      currentTab = 0;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool get isLastFecha {
    int currentIndex = listDatabaseSort.indexWhere((e) => e.fecha == fecha);
    return currentIndex == 0;
  }

  bool get isFirstFecha {
    int currentIndex = listDatabaseSort.indexWhere((e) => e.fecha == fecha);
    return (currentIndex == listDatabaseSort.length - 1);
  }

  void nextFecha() {
    int currentIndex = listDatabaseSort.indexWhere((e) => e.fecha == fecha);
    if (currentIndex < listDatabaseSort.length - 1) {
      Database nextData = listDatabaseSort[currentIndex + 1];
      String nextFecha = nextData.fecha;
      loadDataByDate(nextFecha);
      /* DateTime time = DateFormat('dd/MM/yyyy').parse(nextFecha);
      datos.fecha = DateFormat('yyyy-MM-dd').format(time);
      datos.preciosHora = nextData.preciosHora;
      datosGeneracion.generacion =
          nextData.generacion ?? datosGeneracion.generacion;
      datosGeneracion.mapNoRenovables =
          nextData.mapNoRenovables ?? datosGeneracion.mapNoRenovables;
      datosGeneracion.mapRenovables =
          nextData.mapRenovables ?? datosGeneracion.mapRenovables;
      setState(() {
        fecha = nextFecha;
        datos = datos;
        datosGeneracion = datosGeneracion;
      }); */
    }
  }

  void prevFecha() {
    int currentIndex = listDatabaseSort.indexWhere((e) => e.fecha == fecha);
    if (currentIndex > 0) {
      Database prevData = listDatabaseSort[currentIndex - 1];
      String prevFecha = prevData.fecha;
      loadDataByDate(prevFecha);
      /* DateTime time = DateFormat('dd/MM/yyyy').parse(prevFecha);
      datos.fecha = DateFormat('yyyy-MM-dd').format(time);
      datos.preciosHora = prevData.preciosHora;
      datosGeneracion.generacion =
          prevData.generacion ?? datosGeneracion.generacion;
      datosGeneracion.mapNoRenovables =
          prevData.mapNoRenovables ?? datosGeneracion.mapNoRenovables;
      datosGeneracion.mapRenovables =
          prevData.mapRenovables ?? datosGeneracion.mapRenovables;
      setState(() {
        fecha = prevFecha;
        datos = datos;
        datosGeneracion = datosGeneracion;
      }); */
    }
  }

  void getDatos({String? fechaSelect}) async {
    // set fecha a hoy si < 20:00 h o ayer ??
    fechaSelect = fechaSelect ?? DateFormat('dd/MM/yyyy').format(hoy);

    if (isFirstLaunch == false && storage.dateInDataBase(fechaSelect)) {
      String? continuar = await showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Fecha en Archivo'),
          content: Text(
            'Los datos del día $fechaSelect están disponibles en el Histórico. '
            '¿Continuar con la consulta?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'no'),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'ver'),
              child: const Text('VER'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'si'),
              child: const Text('Consultar'),
            ),
          ],
        ),
      );
      if (continuar == 'no' || continuar == null) {
        return;
      } else if (continuar == 'ver') {
        if (mainBodyAutoSaveFalse == true) {
          setState(() {
            mainBodyAutoSaveFalse = false;
            listDatabaseSort = storage.sortByDate;
          });
        }
        loadDataByDate(fechaSelect);
        return;
      }
    } else if (isFirstLaunch == true && storage.dateInDataBase(fechaSelect)) {
      return;
    }

    setState(() {
      //fecha = fechaSelect!;
      txtProgress = 'Iniciando consulta...';
      processGetData = ProcessGetData.started;
    });
    DateTime time = DateFormat('dd/MM/yyyy').parse(fechaSelect);
    datos.fecha = DateFormat('yyyy-MM-dd').format(time);
    datos.preciosHora.clear();

    await datos.getPreciosHoras(datos.fecha);

    if (datos.status != Status.ok) {
      setState(() => txtProgress = 'Consultando archivo...');
      await datos.getPreciosHorasFile(datos.fecha);
      // test fecha mañana dataNotYet ??
    }
    if (datos.status == Status.tiempoExcedido) {
      checkStatus(Status.tiempoExcedido);
      setState(() => processGetData = ProcessGetData.completed);
    } else if (datos.status == Status.noInternet) {
      checkStatus(Status.noInternet);
      /* setState(() {
        processGetData = ProcessGetData.completed;
      }); */
    } else if (dataNotYet && datos.status == Status.error) {
      checkStatus(Status.noPublicado);
      //setState(() => processGetData = ProcessGetData.completed);
    } else if (datos.status != Status.ok) {
      checkStatus(datos.status);
      //setState(() => processGetData = ProcessGetData.completed);
    } else if (datos.status == Status.ok) {
      setState(() {
        txtProgress = 'Consultando datos generación...';
      });
      var fechaDatos = datos.fecha.toString();
      await datosGeneracion.getDatosGeneracion(fechaDatos);
      //if (datos.preciosHora.isNotEmpty) {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //var autoSave = prefs.getBool('autosave');
      if (sharedPrefs.autoSave == true) {
        storage.saveDataBase(
          fecha: fechaSelect,
          data: datos,
          datosGeneracion: datosGeneracion,
        );
        setState(() {
          //fecha = fechaSelect!;
          listDatabaseSort = storage.sortByDate;
          loadDataByDate(fechaSelect!);
          txtProgress = '';
          processGetData = ProcessGetData.completed;
        });
      } else {
        setState(() {
          listDatabaseSort.clear();
          fecha = fechaSelect!;
          listDatabaseSort.add(Database(
            fecha: fechaSelect,
            preciosHora: datos.preciosHora,
          )
            ..mapRenovables = datosGeneracion.mapRenovables
            ..mapNoRenovables = datosGeneracion.mapNoRenovables
            ..generacion = datosGeneracion.generacion);
          txtProgress = '';
          mainBodyAutoSaveFalse = true;
          processGetData = ProcessGetData.completed;
        });
      }

      //return;
      /* } else {
        resetMainScreen();
      } */
    } else {
      resetMainScreen(); // ¿¿ mejor PageRoute con isFirstLaunch: false ??
    }
  }

  showError({required String titulo, required String msg}) async {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MainScreen(isFirstLaunch: false),
                  ),
                );
                //resetMainScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void checkStatus(Status status) {
    switch (status) {
      case Status.errorToken:
        showError(
          titulo: 'Error Token',
          msg: 'Acceso denegado.\nComprueba tu token personal.',
        );
        break;
      case Status.noAcceso:
        showError(
          titulo: 'Error',
          msg: 'Error en la respuesta a la petición web',
        );
        break;
      case Status.tiempoExcedido:
        showError(
          titulo: 'Error',
          msg: 'Tiempo de conexión excedido sin respuesta del servidor.',
        );
        break;
      case Status.noPublicado:
        showError(
          titulo: 'Error',
          msg:
              'Es posible que los datos de mañana todavía no estén publicados.\n\n'
              'Vuelve a intentarlo más tarde.',
        );
        break;
      case Status.noInternet:
        showError(
          titulo: 'Error',
          msg: 'Comprueba tu conexión a internet.',
        );
        break;
      default:
        showError(
          titulo: 'Error',
          msg: 'Error obteniendo los datos.\n'
              'Comprueba tu conexión o vuelve a intentarlo pasados unos minutos.',
        );
    }
  }

  void selectDate(BuildContext context) async {
    DateTime manana = DateTime(hoy.year, hoy.month, hoy.day + 1);
    DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('es', 'ES'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2021, 6),
      //lastDate: DateTime(2024, 6),
      lastDate: manana,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) {
      //bool x = picked.difference(hoy).inDays > 1;
      dataNotYet = picked == manana && hoy.hour < 20 ? true : false;
      //bool continuarGetData = true;
      if (dataNotYet) {
        //continuarGetData = await openDialogNoPublicado();
        if (await openDialogNoPublicado() == true) {
          //fecha = DateFormat('dd/MM/yyyy').format(picked);
          getDatos(fechaSelect: DateFormat('dd/MM/yyyy').format(picked));
        }
        /*  else {
          setState(() => processGetData = ProcessGetData.completed);
        } */
      } else {
        getDatos(fechaSelect: DateFormat('dd/MM/yyyy').format(picked));
      }
    }
  }

  Future<bool> openDialogNoPublicado() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aviso'),
          content: const Text(
              'En torno a las 20:15h de cada día, la REE publica los precios '
              'de la electricidad que se aplicarán al día siguiente, por lo que '
              'es posible que los datos todavía no estén publicados.'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Continuar'),
              onPressed: () => Navigator.of(context).pop(true),
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
    Widget mainBody = MainBodyEmpty(tokenSaved: sharedPrefs.token);
    if (processGetData == ProcessGetData.started) {
      mainBody = MainBodyStarted(stringProgress: txtProgress);
    } else if (processGetData == ProcessGetData.completed &&
        storage.boxData.isNotEmpty) //&& listDatabaseSort.isNotEmpty
    {
      mainBody = SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          controller: scrollController,
          child: DataScreen(
            tab: currentTab,
            data: datos,
            fecha: fecha,
            dataGeneracion: datosGeneracion,
          ),
        ),
      );
    }

    FloatingActionButton? floatingActionButton() {
      if (currentTab == 0) {
        return FloatingActionButton(
          onPressed: () {
            setState(() => isFirstLaunch = false);
            getDatos();
          },
          child: const Icon(Icons.update, size: 42),
        );
      }

      if (currentTab == 1) {
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GraficoPrecio(data: datos, fecha: fecha),
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
          if (mainBodyAutoSaveFalse)
            IconButton(
              onPressed: () {
                showSnack('Datos archivados');
                storage.saveDataBase(
                  fecha: fecha,
                  data: datos,
                  datosGeneracion: datosGeneracion,
                );
                setState(() {
                  //fecha = fechaSelect!;
                  listDatabaseSort = storage.sortByDate;
                  loadDataByDate(fecha);
                  txtProgress = '';
                  processGetData = ProcessGetData.completed;
                  //mainBodyAutoSaveFalse = false;
                });
              },
              icon: const Icon(Icons.save),
            ),
          if (mainBodyAutoSaveFalse)
            IconButton(
              onPressed: () {
                resetMainScreen();
              },
              icon: const Icon(Icons.storage),
            ),
          if (!mainBodyAutoSaveFalse)
            IconButton(
              onPressed: (listDatabaseSort.length > 1 && !isFirstFecha)
                  ? nextFecha
                  : null,
              icon: const Icon(Icons.skip_previous),
            ),
          if (!mainBodyAutoSaveFalse)
            IconButton(
              onPressed: (listDatabaseSort.length > 1 && !isLastFecha)
                  ? prevFecha
                  : null,
              icon: const Icon(Icons.skip_next),
            ),
          IconButton(
            onPressed: () => selectDate(context),
            icon: const Icon(Icons.today),
          )
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
      bottomNavigationBar: (storage.boxData.isNotEmpty &&
              processGetData == ProcessGetData.completed)
          ? BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.lightbulb_outline),
                  activeIcon: Icon(Icons.upgrade),
                  label: 'PVPC',
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
      floatingActionButton: floatingActionButton(),
    );
  }
}

class MainBodyEmpty extends StatelessWidget {
  final String tokenSaved;
  const MainBodyEmpty({super.key, required this.tokenSaved});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    //final Color onBackgroundColor = ThemeApp(context).onBackgroundColor;

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
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
