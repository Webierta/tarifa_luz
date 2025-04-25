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

    var desviacion = boxData.preciosHora[now.hour] - boxData.precioMedio;

    //Color color = Tarifa.getColorCara(boxData.preciosHora, precioNow);

    RangoHoras rango = Tarifa.getRangoHora(boxData.preciosHora, precioNow);

    /*int indexPrecio() {
      Map<int, double> mapPreciosOrdenados =
          boxData.ordenarPrecios(boxData.preciosHora);
      List<double> preciosOrdenados = mapPreciosOrdenados.values.toList();
      return preciosOrdenados.indexOf(precioNow) + 1;
    }*/

    return IntrinsicHeight(
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
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
                const SizedBox(height: 10),
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
                const Spacer(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Tarifa.getIconPeriodo(periodoAhora),
                  title: Text('Periodo ${periodoAhora.name.toUpperCase()}'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text(
                    Tarifa.getEmojiCara(boxData.preciosHora, precioNow),
                    style: TextStyle(fontSize: 20),
                  ),
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(rango.description),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    desviacion > 0 ? Icons.upload : Icons.download,
                    color: desviacion > 0 ? Colors.red : Colors.green,
                  ),
                  title: Text(
                    '${desviacion.toStringAsFixed(4)} €',
                    style: TextStyle(),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          //const SizedBox(width: 8),
          Expanded(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rango de precios',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white),
                ),
                Expanded(child: IndicadorPrecios(boxData: boxData)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
