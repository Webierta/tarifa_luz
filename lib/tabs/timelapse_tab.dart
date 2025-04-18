import 'package:flutter/material.dart';
import 'package:tarifa_luz/database/box_data.dart';
import 'package:tarifa_luz/models/tarifa.dart';
import 'package:tarifa_luz/tabs/head_tab.dart';
import 'package:tarifa_luz/theme/style_app.dart';

class TimelapseTab extends StatefulWidget {
  final BoxData boxData;
  const TimelapseTab({required this.boxData, super.key});
  @override
  State<TimelapseTab> createState() => _TimelapseTabState();
}

class _TimelapseTabState extends State<TimelapseTab> {
  Duration duration = const Duration(hours: 0, minutes: 00);
  var horas = 0;
  var minutos = 0;
  int franjas = 0;
  Map<Duration, double> mapPreciosSorted = {};
  bool calculando = false;

  void upHoras() {
    horas < 24 ? setState(() => horas++) : setState(() => horas = 0);
  }

  void upMin() {
    minutos < 55 ? setState(() => minutos += 5) : setState(() => minutos = 0);
  }

  void downHoras() {
    horas > 0 ? setState(() => horas--) : setState(() => horas = 24);
  }

  void downMin() {
    minutos > 0 ? setState(() => minutos -= 5) : setState(() => minutos = 55);
  }

  void reset() {
    setState(() {
      horas = 0;
      minutos = 0;
      mapPreciosSorted.clear();
    });
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
    List<double> preciosHora = widget.boxData.preciosHora;
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

  void showSnack(String title) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final snackbar = SnackBar(content: Text(title));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void submitDuracion() async {
    duration = Duration(hours: horas, minutes: minutos);
    if (duration.inMinutes <= 60) {
      showSnack('Duración insuficiente: debe superar 1 hora');
      return;
    }
    if (mounted) {
      setState(() {
        calculando = true;
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
      getPreciosFranjas();
      await Future.delayed(Duration(milliseconds: franjas * 10));
      // franjas * 25
      if (mounted) {
        setState(() => calculando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          HeadTab(
            fecha: widget.boxData.fechaddMMyy,
            titulo: 'Franjas horarias más baratas',
          ),
          const Text('Selecciona la duración (HH:MM)'),
          const SizedBox(height: 10),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  width: 2,
                  color: Colors.white,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonsUpDownTimer(
                        upTimer: upHoras,
                        downTimer: downHoras,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.black,
                          child: FittedBox(
                            child: Text(
                              '${horas.toString().padLeft(2, '0')} : ${minutos.toString().padLeft(2, '0')}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                color: Colors.yellowAccent,
                                fontWeight: FontWeight.w100,
                                shadows: [
                                  const Shadow(
                                    color: Colors.white,
                                    blurRadius: 2,
                                    offset: Offset(1.5, 1.5),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ButtonsUpDownTimer(
                        upTimer: upMin,
                        downTimer: downMin,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(7),
                            ),
                            color: Colors.red,
                          ),
                          child: TextButton(
                            onPressed: reset,
                            child: const Text(
                              'RESET',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(7),
                            ),
                            color: Colors.green,
                          ),
                          child: TextButton(
                            onPressed: submitDuracion,
                            child: const Text(
                              'START',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
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
        ],
      ),
    );
  }
}

class ButtonsUpDownTimer extends StatelessWidget {
  final void Function() upTimer;
  final void Function() downTimer;
  const ButtonsUpDownTimer(
      {super.key, required this.upTimer, required this.downTimer});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: upTimer,
          icon: const Icon(Icons.arrow_drop_up),
          color: Colors.white,
        ),
        IconButton(
          onPressed: downTimer,
          icon: const Icon(Icons.arrow_drop_down),
          color: Colors.white,
        ),
      ],
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
                //color: Theme.of(context).colorScheme.onBackground,
                color: Theme.of(context).colorScheme.onSurface,
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
    return Container(
      constraints: BoxConstraints(maxHeight: 100.0 * franjas),
      child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                height: 0.2,
                //color: StyleApp.backgroundColor.withOpacity(0.2),
                color: StyleApp.backgroundColor.withAlpha(20),
              ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: franjas,
          itemBuilder: (context, index) {
            var precioOrdenado = preciosOrdenados[index];
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
                gradient: LinearGradient(
                  //stops: const [0.04, 0.02],
                  stops: const [0.04, 0.04],
                  //colors: [StyleApp.backgroundColor.withOpacity(0.5), color],
                  colors: [StyleApp.blueGrey, color],
                ),
                borderRadius: borderRadius,
                color: color,
              ),
              child: ListTile(
                leadingAndTrailingTextStyle: const TextStyle(
                  color: StyleApp.backgroundColor,
                ),
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: StyleApp.backgroundColor),
                subtitleTextStyle: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: StyleApp.backgroundColor),
                leading: Text('${index + 1}'),
                title: Text(
                  '$horaInicioFranja:${minInicioFranja.toString().padLeft(2, '0')} - '
                  '$horaLapso:${minLapso.toString().padLeft(2, '0')}',
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
