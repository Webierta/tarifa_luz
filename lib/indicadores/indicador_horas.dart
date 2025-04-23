import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';

import '../database/box_data.dart';
import '../models/tarifa.dart';
import '../theme/style_app.dart';
import '../utils/estados.dart';

class IndicadorHoras extends StatefulWidget {
  final BoxData boxData;
  const IndicadorHoras({super.key, required this.boxData});

  @override
  State<IndicadorHoras> createState() => _IndicadorHorasState();
}

class _IndicadorHorasState extends State<IndicadorHoras> {
  List<double> precios = [];
  int hora = 0;
  double precio = 0;
  List<int> horas = List<int>.generate(24, (i) => i);
  String emojiCara = '';

  //final now = DateTime.now().toLocal();
  FixedExtentScrollController controller = FixedExtentScrollController();

  @override
  void initState() {
    final now = DateTime.now().toLocal();
    hora = now.hour;
    precios = widget.boxData.preciosHora;
    //precio = double.parse(precios.elementAt(hora).toStringAsFixed(4));
    //emojiCara = Tarifa.getEmojiCara(precios, precio);
    controller = FixedExtentScrollController(initialItem: hora);
    updateHoraPrecio(hora);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(IndicadorHoras oldWidget) {
    if (oldWidget.boxData != widget.boxData) {
      final now = DateTime.now().toLocal();
      setState(() {
        hora = now.hour;
        precios = widget.boxData.preciosHora;
        //precio = double.parse(precios.elementAt(hora).toStringAsFixed(4));
        //emojiCara = Tarifa.getEmojiCara(precios, precio);
        //controller.jumpToItem(hora);
        controller.animateToItem(
          hora,
          duration: Duration(milliseconds: 1000),
          curve: Curves.ease,
        );
        updateHoraPrecio(hora);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void updateHoraPrecio(int newHora) {
    Future.delayed(Duration.zero, () async {
      setState(() {
        hora = newHora;
        precio = precios.elementAt(hora);
        emojiCara = Tarifa.getEmojiCara(precios, precio);
      });
    });
  }

  List<int> corteHorasPeriodo(List<int> horasPeriodo) {
    List<int> corteHoras = [];
    for (var i = 0; i < horasPeriodo.length; i++) {
      if (i + 1 < horasPeriodo.length) {
        if (horasPeriodo[i + 1] - horasPeriodo[i] > 1) {
          corteHoras.add(horasPeriodo[i]);
        }
      } else {
        corteHoras.add(horasPeriodo[i]);
      }
    }
    return corteHoras;
  }

  List<RadialValueBar> getPeriodoHoras() {
    List<int> horasValle = [];
    List<int> horasLlano = [];
    List<int> horasPunta = [];
    DateTime fecha = widget.boxData.fecha;
    List<int> horas = List<int>.generate(24, (i) => i);
    for (var hora in horas) {
      Periodo periodoHora = Tarifa.getPeriodo(fecha.copyWith(hour: hora));
      if (periodoHora == Periodo.valle) {
        horasValle.add(hora);
      } else if (periodoHora == Periodo.llano) {
        horasLlano.add(hora);
      } else if (periodoHora == Periodo.punta) {
        horasPunta.add(hora);
      }
    }

    List<int> corteHorasValle = corteHorasPeriodo(horasValle);
    List<int> corteHorasLlano = corteHorasPeriodo(horasLlano);
    List<int> corteHorasPunta = corteHorasPeriodo(horasPunta);
    List<int> horasCorte = [
      ...corteHorasValle,
      ...corteHorasLlano,
      ...corteHorasPunta
    ];
    horasCorte.sort();

    List<RadialValueBar> valueBar = [];
    valueBar.add(RadialValueBar(
      value: 24,
      color: Colors.black12,
      valueBarThickness: 150,
      radialOffset: 60,
    ));
    valueBar.add(RadialValueBar(
      value: 24,
      color: Colors.black26,
      valueBarThickness: 50,
      radialOffset: 60,
    ));
    valueBar.add(RadialValueBar(
      value: 24,
      color: Colors.grey,
      valueBarThickness: 2,
      radialOffset: -10,
    ));
    for (var corte in horasCorte.reversed) {
      valueBar.add(RadialValueBar(
        value: corte.toDouble() + 1,
        color: Tarifa.getPeriodoColor(fecha.copyWith(hour: corte)),
        valueBarThickness: 10, // 20
        radialOffset: -6, //-10,
      ));
    }
    return valueBar;
  }

  @override
  Widget build(BuildContext context) {
    //final double altoScreen = MediaQuery.of(context).size.height;
    //final double anchoScreen = MediaQuery.of(context).size.width;
    return ClipPath(
      clipper: StyleApp.kBorderClipper,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        //width: double.infinity,
        //height: altoScreen / 2,
        decoration: StyleApp.kBoxDeco,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 30,
                    scrollController: controller,
                    selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                      capStartEdge: false,
                      capEndEdge: false,
                      background: Colors.transparent,
                    ),
                    backgroundColor: Colors.transparent,
                    looping: true,
                    children: [
                      for (var i = 0; i < horas.length; i++)
                        Row(
                          children: [
                            Icon(
                              Icons.unfold_more_double,
                              color: Colors.white38,
                            ),
                            Text('$i h'),
                          ],
                        ),
                    ],
                    onSelectedItemChanged: (index) {
                      updateHoraPrecio(index);
                    },
                  ),
                ),
                const Spacer(flex: 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      precio.toStringAsFixed(4),
                      style: TextStyle(fontSize: 22),
                    ),
                    Text(
                      '€/kWh',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              flex: 10,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /*CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.black12,
                  ),*/
                  RadialGauge(
                    radiusFactor: 1.1,
                    track: RadialTrack(
                      hideTrack: false,
                      thickness: -4,
                      color: Colors.blueGrey,
                      startAngle: 90,
                      endAngle: 450,
                      steps: 2,
                      start: 0,
                      end: 24,
                      trackLabelFormater: (double value) {
                        if (value == 24) {
                          return '';
                        }
                        return '${value.round()}';
                      },
                      trackStyle: TrackStyle(
                        primaryRulerColor: Colors.white,
                        secondaryRulerPerInterval: 1,
                        secondaryRulersWidth: 5,
                        secondaryRulerColor: Colors.white38,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    needlePointer: [
                      NeedlePointer(
                        value: hora.toDouble(),
                        color: Colors.black,
                        needleWidth: 6,
                        tailColor: Colors.transparent,
                        tailRadius: 48,
                        needleStyle: NeedleStyle.flatNeedle,
                        /*isInteractive: true,
                        onChanged: (value) async {
                          updateHoraPrecio(value.toInt());
                        },*/
                      ),
                    ],
                    valueBar: getPeriodoHoras(),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      //Tarifa.getEmojiCara(precios, precio),
                      emojiCara,
                      style: TextStyle(fontSize: 42),
                    ),
                  ),
                ],
              ),
            ),
            //SizedBox(height: 10),
            Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF81C784),
                        border: Border.all(color: Colors.blueGrey),
                      ),
                      child: Text(
                        'VALLE',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.amberAccent,
                        border: Border(
                          bottom: BorderSide(color: Colors.blueGrey),
                          top: BorderSide(color: Colors.blueGrey),
                        ),
                      ),
                      // Colors.yellow[50]
                      child: Text(
                        'LLANO',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFe57373),
                        border: Border.all(color: Colors.blueGrey),
                      ),
                      // Colors.red[100],
                      child: Text(
                        'PUNTA',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
