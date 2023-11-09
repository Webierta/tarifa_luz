import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tarifa_luz/database/database.dart';
import 'package:tarifa_luz/database/storage.dart';
import 'package:tarifa_luz/models/datos.dart';
import 'package:tarifa_luz/models/datos_generacion.dart';
import 'package:tarifa_luz/screens/data_screen.dart';
import 'package:tarifa_luz/screens/settings_screen.dart';
import 'package:tarifa_luz/theme/style_app.dart';
import 'package:tarifa_luz/theme/theme_app.dart';
import 'package:tarifa_luz/utils/estados.dart';
import 'package:tarifa_luz/utils/shared_prefs.dart';
import 'package:tarifa_luz/widgets/app_drawer.dart';
import 'package:tarifa_luz/widgets/graficos/grafico_precio.dart';

class MainScreen extends StatefulWidget {
  final String? fecha;
  const MainScreen({super.key, this.fecha});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var currentTab = 0;
  late ScrollController scrollController;

  final SharedPrefs sharedPrefs = SharedPrefs();
  String token = '';

  Datos datos = Datos();
  DatosGeneracion datosGeneracion = DatosGeneracion();
  DateTime hoy = DateTime.now().toLocal();
  late String fecha;

  bool dataNotYet = false;
  String txtProgress = '';
  StatusGetData statusGetData = StatusGetData.stopped;

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
        statusGetData = StatusGetData.completed;
      });
    }
  }

  void loadSharedPrefs() async {
    await sharedPrefs.init();
    setState(() => token = sharedPrefs.token);
  }

  @override
  void initState() {
    Intl.defaultLocale = 'es_ES';
    loadSharedPrefs();
    scrollController = ScrollController();
    listDatabaseSort = storage.sortByDate;
    if (widget.fecha != null) {
      fecha = widget.fecha!;
      loadDataByDate(fecha);
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
      txtProgress = '';
      statusGetData = StatusGetData.completed;
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
    }
  }

  void prevFecha() {
    int currentIndex = listDatabaseSort.indexWhere((e) => e.fecha == fecha);
    if (currentIndex > 0) {
      Database prevData = listDatabaseSort[currentIndex - 1];
      String prevFecha = prevData.fecha;
      loadDataByDate(prevFecha);
    }
  }

  void getDatos([String? fechaSelect]) async {
    fechaSelect = fechaSelect ?? DateFormat('dd/MM/yyyy').format(hoy);

    if (storage.dateInDataBase(fechaSelect)) {
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
        loadDataByDate(fechaSelect);
        return;
      }
    }

    setState(() {
      //fecha = fechaSelect!;
      txtProgress = 'Iniciando consulta...';
      statusGetData = StatusGetData.started;
    });
    DateTime time = DateFormat('dd/MM/yyyy').parse(fechaSelect);
    datos.fecha = DateFormat('yyyy-MM-dd').format(time);
    datos.preciosHora.clear();

    await datos.getPreciosHoras(datos.fecha);

    if (datos.status != Status.ok) {
      setState(() => txtProgress = 'Consultando archivo...');
      await datos.getPreciosHorasFile(datos.fecha);
      // TODO: test fecha mañana dataNotYet
      /// no para si no encuentra datos ???
    }
    if (datos.status == Status.tiempoExcedido) {
      checkStatus(Status.tiempoExcedido);
    } else if (datos.status == Status.noInternet) {
      checkStatus(Status.noInternet);
    } else if (dataNotYet && datos.status == Status.error) {
      checkStatus(Status.noPublicado);
    } else if (datos.status != Status.ok) {
      checkStatus(datos.status);
    } else if (datos.status == Status.ok) {
      setState(() {
        txtProgress = 'Consultando datos generación...';
      });
      var fechaDatos = datos.fecha.toString();
      await datosGeneracion.getDatosGeneracion(fechaDatos);
      //if (datos.preciosHora.isNotEmpty) {
      var prefs = await SharedPreferences.getInstance();
      var autoSave = prefs.getBool('autosave');
      //if (autoSave == true) {
      storage.saveDataBase(
        fecha: fechaSelect,
        data: datos,
        datosGeneracion: datosGeneracion,
      );
      //}
      setState(() {
        //fecha = fechaSelect!;
        listDatabaseSort = storage.sortByDate;
        loadDataByDate(fechaSelect!);
        txtProgress = '';
        statusGetData = StatusGetData.completed;
      });
      //return;
      /* } else {
        resetMainScreen();
      } */
    } else {
      resetMainScreen();
    }
  }

  showError({required String titulo, required String msg}) async {
    //setState(() => statusGetData = StatusGetData.aborted);
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
                resetMainScreen();
                //Navigator.of(context).pop();
                /* Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ),
                ); */
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
      bool continuarGetData = true;
      if (dataNotYet) {
        continuarGetData = await openDialogNoPublicado();
      }
      if (continuarGetData) {
        //fecha = DateFormat('dd/MM/yyyy').format(picked);
        getDatos(DateFormat('dd/MM/yyyy').format(picked));
      } else {
        setState(() => statusGetData = StatusGetData.completed);
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

  @override
  Widget build(BuildContext context) {
    Widget mainBody = MainBodyEmpty(tokenSaved: token);
    if (statusGetData == StatusGetData.started) {
      mainBody = MainBodyStarted(stringProgress: txtProgress);
    } else if (statusGetData == StatusGetData.completed) {
      // storage.boxData.isNotEmpty &&
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
          onPressed: () => getDatos(),
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
          IconButton(
            onPressed: (listDatabaseSort.length > 1 && !isFirstFecha)
                ? nextFecha
                : null,
            icon: const Icon(Icons.skip_previous),
          ),
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
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          decoration: StyleApp.mainDecoration,
          child: mainBody,
        ),
      ),
      bottomNavigationBar: (storage.boxData.isNotEmpty &&
              statusGetData == StatusGetData.completed)
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
    final Color onBackgroundColor = ThemeApp(context).onBackgroundColor;

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
                color: onBackgroundColor,
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
                            color: onBackgroundColor,
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
                                color: onBackgroundColor,
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
                      color: onBackgroundColor,
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
