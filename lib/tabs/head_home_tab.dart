import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarifa_luz/database/box_data.dart';
import 'package:tarifa_luz/models/tarifa.dart';
import 'package:tarifa_luz/utils/estados.dart';

import '../indicadores/indicador_precios.dart';

class HeadHomeTab extends StatelessWidget {
  final BoxData boxData;
  const HeadHomeTab({required this.boxData, super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toLocal();

    double precioNow = boxData.getPrecio(boxData.preciosHora, now.hour);
    Periodo periodoAhora =
        Tarifa.getPeriodo(boxData.fecha.copyWith(hour: now.hour));

    //String semaforo = Tarifa.getSemaforo(precioNow);

    var desviacion = boxData.preciosHora[now.hour] - boxData.precioMedio;

    //Color color = Tarifa.getColorCara(boxData.preciosHora, precioNow);

    RangoHoras rango = Tarifa.getRangoHora(boxData.preciosHora, precioNow);

    /*int indexPrecio() {
      Map<int, double> mapPreciosOrdenados =
          boxData.ordenarPrecios(boxData.preciosHora);
      List<double> preciosOrdenados = mapPreciosOrdenados.values.toList();
      return preciosOrdenados.indexOf(precioNow) + 1;
    }*/

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          //flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  '${boxData.fechaddMMyy} a las ${DateFormat('HH:mm').format(now)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              //const SizedBox(height: 20),
              FittedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      precioNow.toStringAsFixed(5),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const Text(
                      '€/kWh',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              //const SizedBox(height: 10),
              FittedBox(
                child: Row(
                  children: [
                    Tarifa.getIconPeriodo(periodoAhora),
                    const SizedBox(width: 5),
                    Text('Período ${periodoAhora.name.toUpperCase()}'),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                child: Row(
                  children: [
                    Text(
                      Tarifa.getEmojiCara(boxData.preciosHora, precioNow),
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 5),
                    if (rango == RangoHoras.baratas)
                      Text('8 horas más baratas'),
                    if (rango == RangoHoras.caras) Text('8 horas más caras'),
                    if (rango == RangoHoras.intermedias)
                      Text('8 horas intermedias'),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                child: Row(
                  children: [
                    Icon(
                      desviacion > 0 ? Icons.upload : Icons.download,
                      color: desviacion > 0 ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${desviacion.toStringAsFixed(4)} €',
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //const SizedBox(width: 8),
        Expanded(
          //flex: 3,
          child: AspectRatio(
            aspectRatio: 1, //4 / 5, // 9 / 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rangos de precios',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white),
                ),
                Expanded(child: IndicadorPrecios(boxData: boxData)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
