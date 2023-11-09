import 'package:flutter/material.dart';

import 'package:tarifa_luz/models/datos.dart';
import 'package:tarifa_luz/models/tarifa.dart';
import 'package:tarifa_luz/theme/theme_app.dart';
import 'package:tarifa_luz/widgets/tabs/head_tab.dart';

class RangeTab extends StatefulWidget {
  final String fecha;
  final Datos data;
  const RangeTab({
    super.key,
    required this.fecha,
    required this.data,
  });

  @override
  State<RangeTab> createState() => _RangeTabState();
}

class _RangeTabState extends State<RangeTab> {
  Duration duration = const Duration(hours: 0, minutes: 00);
  var horas = 0;
  var minutos = 0;
  int franjas = 0;
  Map<Duration, double> mapPreciosSorted = {};
  bool calculando = false;

  TextEditingController controladorHor = TextEditingController();
  TextEditingController controladorMin = TextEditingController();

  @override
  void dispose() {
    controladorHor.dispose();
    controladorMin.dispose();
    super.dispose();
  }

  int getFranjas({required int duracion, required int step}) {
    // franjas o intervalos = (((total - (duration - step)) / 60)) * ((60 / step))).truncate()
    const total = 1440; // 24 horas en minutos
    var paso = step == 0 ? 60 : step;
    return (((total - (duracion - paso)) / 60) * ((60 / paso))).truncate();
  }

  void getPreciosFranjas() {
    Map<Duration, double> mapInicioPrecios = {};
    List<double> preciosFranjas = [];
    List<double> preciosHora = widget.data.preciosHora;
    var startList = List<Duration>.generate(
        franjas,
        (int index) =>
            Duration(minutes: index * (minutos == 0 ? 60 : minutos)));

    for (var i = 0; i < franjas; i++) {
      // PUNTOS DE INICIO Y FIN DE CADA INTERVALO
      var start = startList[i];
      var stop = start + duration;
      // HORAS Y MINUTOS PARA CALCULAR EL PRECIO DE CADA INTERVALO
      var horasFranja = [];
      var minStop = int.tryParse(stop.toString().split(':')[1]) ?? 0;
      var horaLimite = minStop == 0 ? stop.inHours - 1 : stop.inHours;
      for (var i = start.inHours; i <= horaLimite; i++) {
        horasFranja.add(i);
      }
      var minFranja = List<int>.generate(horasFranja.length, (int index) => 60);
      minFranja.first =
          60 - (int.tryParse(start.toString().split(':')[1]) ?? 0);
      minFranja.last = int.tryParse(stop.toString().split(':')[1]) ?? 0;
      // PRECIO * MINUTOS DE CADA INTERVALO
      var preciosRango = [];
      for (var i = 0; i < horasFranja.length; i++) {
        var minutosFranja = minFranja[i] == 0 ? 60 : minFranja[i];
        preciosRango.add(preciosHora[horasFranja[i]] * minutosFranja);
      }
      // PRECIOS MEDIOS
      var media = preciosRango.reduce((a, b) => a + b) / duration.inMinutes;
      preciosFranjas.add(media);
      mapInicioPrecios[startList[i]] = preciosFranjas[i];
    }
    // ORDENA LOS PRECIOS
    var sortedKeys = mapInicioPrecios.keys.toList(growable: false)
      ..sort(
          (k1, k2) => mapInicioPrecios[k1]!.compareTo(mapInicioPrecios[k2]!));
    Map<Duration, double> mapPrecios = {
      for (var k in sortedKeys) k: mapInicioPrecios[k]!
    };
    if (mounted) {
      setState(() => mapPreciosSorted = Map.from(mapPrecios));
    }
  }

  void submitDuracion() async {
    if (controladorHor.text.trim().isEmpty) {
      controladorHor.text = '00';
    }
    if (controladorMin.text.trim().isEmpty) {
      controladorMin.text = '00';
    }
    final int? intHor = int.tryParse(controladorHor.text);
    final int? intMin = int.tryParse(controladorMin.text);
    final bool intHorIsNull = intHor == null || intHor < 0;
    final bool intMinIsNull = intMin == null || intMin < 0;
    if (intHorIsNull || intMinIsNull) {
      showDialog(
        context: context,
        builder: (context) {
          final Color onBackgroundColor = ThemeApp(context).onBackgroundColor;
          return AlertDialog(
            titleTextStyle: TextStyle(color: onBackgroundColor),
            contentTextStyle: TextStyle(color: onBackgroundColor),
            iconColor: Theme.of(context).colorScheme.error,
            icon: const Icon(Icons.warning),
            title: const Text('Duración no válida'),
            content: const Text('Por favor, comprueba los datos introducidos'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      return;
    }
    if (mounted) {
      setState(() {
        calculando = true;
        //duration = resultingDuration;
        //horas = duration.inHours; // > 5 ? 6 : _duration.inHours;
        //minutos = int.tryParse(duration.toString().split(':')[1]) ?? 0;
        horas = intHor;
        minutos = intMin;
        duration = Duration(hours: horas, minutes: minutos);

        if (duration.inMinutes <= 60) {
          showDialog(
            context: context,
            builder: (context) {
              final Color onBackgroundColor =
                  ThemeApp(context).onBackgroundColor;
              return AlertDialog(
                titleTextStyle: TextStyle(color: onBackgroundColor),
                contentTextStyle: TextStyle(color: onBackgroundColor),
                iconColor: Theme.of(context).colorScheme.error,
                icon: const Icon(Icons.warning),
                title: const Text('Duración insuficiente'),
                content: const Text(
                  'La duración no supera una hora: '
                  'puedes comprobar la hora más barata en la pestaña Horas',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
          );
          return;
        }

        if (duration.inMinutes > 1440) {
          duration = const Duration(hours: 24, minutes: 0);
          horas = 24;
          minutos = 0;
        }
        franjas = getFranjas(
          duracion: duration.inMinutes,
          step: minutos,
        );
      });
    }
    getPreciosFranjas();
    await Future.delayed(Duration(milliseconds: franjas * 10));
    // franjas * 25
    if (mounted) {
      setState(() => calculando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color onBackgroundColor = ThemeApp(context).onBackgroundColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        //mainAxisSize: MainAxisSize.max,
        children: [
          HeadTab(
            fecha: widget.fecha,
            titulo: 'Franjas horarias más baratas',
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Selecciona la duración (mínimo 1:00 / máximo 24:00):',
              style: TextStyle(color: onBackgroundColor),
            ),
          ),
          const SizedBox(height: 20),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: controladorHor,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    style: textTheme.headlineMedium!.copyWith(
                      color: onBackgroundColor,
                    ),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Hora',
                      hintText: '00',
                      counterText: '',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    ':',
                    style: textTheme.headlineLarge!.copyWith(
                      color: onBackgroundColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: controladorMin,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    style: textTheme.headlineMedium!.copyWith(
                      color: onBackgroundColor,
                    ),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Min',
                      hintText: '00',
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: IconButton(
                    onPressed: submitDuracion,
                    icon: const Icon(
                      //Icons.play_circle,
                      Icons.calculate,
                      //color: Colors.blue,
                      size: 42,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //const Divider(thickness: 0.5),
          const SizedBox(height: 20),
          if (duration.inMinutes > 60 && calculando == true) const Loading(),
          if (duration.inMinutes > 60 &&
              calculando == false &&
              franjas != 0 &&
              mapPreciosSorted.isNotEmpty)
            ContainerListView(
              duration: duration,
              franjas: franjas,
              mapPreciosSorted: mapPreciosSorted,
            ),
          //else const Placeholder(color: Colors.transparent),
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Calculando...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const LinearProgressIndicator(
              minHeight: 2.0,
              valueColor: AlwaysStoppedAnimation(Colors.blue),
              backgroundColor: Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerListView extends StatelessWidget {
  final Duration duration;
  final int franjas;
  final Map<Duration, double> mapPreciosSorted;
  const ContainerListView({
    super.key,
    required this.duration,
    required this.franjas,
    required this.mapPreciosSorted,
  });

  @override
  Widget build(BuildContext context) {
    List<double> preciosOrdenados = mapPreciosSorted.values.toList();
    List<Duration> listaKeys = mapPreciosSorted.keys.toList();
    final Color backgroundColor = ThemeApp(context).backgroundColor;
    return Container(
      constraints: BoxConstraints(maxHeight: 100.0 * franjas),
      child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                height: 0.2,
                color: backgroundColor.withOpacity(0.2),
              ),
          physics: const NeverScrollableScrollPhysics(),
          //cacheExtent: 10000.0 * franjas.value,
          shrinkWrap: true,
          itemCount: franjas,
          itemBuilder: (context, index) {
            //List<double> preciosOrdenados = mapPreciosSorted?.values?.toList();
            var precioOrdenado = preciosOrdenados[index];
            //List<Duration> listaKeys = mapPreciosSorted?.keys?.toList();
            // TITULO CON HORAS Y MINUTOS DE CADA FRANJA
            var timeFranja = listaKeys[index];
            var horaInicioFranja = timeFranja.inHours;
            var minInicioFranja =
                int.tryParse(timeFranja.toString().split(':')[1]) ?? 0;
            var hora2 = timeFranja + duration;
            var horaLapso = hora2.inHours;
            var minLapso = int.tryParse(hora2.toString().split(':')[1]) ?? 0;
            var color = Tarifa.getColorFondo(precioOrdenado);

            BorderRadius borderRadius = const BorderRadius.all(Radius.zero);
            if (index == 0 && index != franjas - 1) {
              borderRadius = const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              );
            } else if (index == 0 && index == franjas - 1) {
              borderRadius = const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              );
            } else if (index == franjas - 1) {
              borderRadius = const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              );
            }

            return Container(
              padding: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                /* border: const Border(
                  bottom: BorderSide(width: 0.8, color: Colors.grey),
                  left: BorderSide(width: 10.0, color: Colors.grey),
                ), */
                gradient: LinearGradient(
                  stops: const [0.04, 0.02], // const [0.02, 0.02],
                  colors: [backgroundColor.withOpacity(0.5), color],
                ),
                borderRadius: borderRadius,
                color: color,
              ),
              child: ListTile(
                leadingAndTrailingTextStyle: TextStyle(color: backgroundColor),
                subtitleTextStyle: TextStyle(color: backgroundColor),
                leading: Text('${index + 1}'),
                title: Text(
                  '$horaInicioFranja:${minInicioFranja.toString().padLeft(2, '0')} - '
                  '$horaLapso:${minLapso.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  '${(precioOrdenado.toStringAsFixed(5))} €/kWh',
                ),
              ),
            );
          }),
    );
  }
}
