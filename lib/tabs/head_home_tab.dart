import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tarifa_luz/database/box_data.dart';
import 'package:tarifa_luz/models/tarifa.dart';
import 'package:tarifa_luz/utils/estados.dart';

class HeadHomeTab extends StatelessWidget {
  final BoxData boxData;
  const HeadHomeTab({required this.boxData, super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toLocal();

    double precioNow = boxData.getPrecio(boxData.preciosHora, now.hour);
    Periodo periodoAhora = Tarifa.getPeriodo(boxData.fecha);

    String semaforo = Tarifa.getSemaforo(precioNow);

    var desviacion = boxData.preciosHora[now.hour] - boxData.precioMedio;

    Color color = Tarifa.getColorCara(boxData.preciosHora, precioNow);

    int indexPrecio() {
      Map<int, double> mapPreciosOrdenados =
          boxData.ordenarPrecios(boxData.preciosHora);
      List<double> preciosOrdenados = mapPreciosOrdenados.values.toList();
      return preciosOrdenados.indexOf(precioNow) + 1;
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
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
                  SizedBox(
                    //width: MediaQuery.of(context).size.width - 30,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: IntrinsicWidth(
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: FittedBox(
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Tarifa.getIconCara(boxData.preciosHora,
                                  boxData.preciosHora[now.hour],
                                  sizeIcon: 30, radius: 15),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Min',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.white),
                                        ),
                                        Text(
                                          'Max',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    LinearProgressIndicator(
                                      value: indexPrecio() / 24,
                                      color: color,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          boxData.precioMin.toStringAsFixed(3),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Text(
                                          '€/kWh',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.white),
                                        ),
                                        Text(
                                          boxData.precioMax.toStringAsFixed(3),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  'assets/images/$semaforo',
                  //height: 150,
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: ListTile(
            /* leading: FittedBox(
              fit: BoxFit.cover,
              child: Tarifa.getIconCara(
                boxData.preciosHora,
                boxData.preciosHora[now.hour],
              ),
            ), */
            title: TextButton.icon(
              style: TextButton.styleFrom(
                disabledBackgroundColor:
                    Theme.of(context).colorScheme.background.withOpacity(0.2),
                disabledForegroundColor:
                    Theme.of(context).colorScheme.onBackground,
                textStyle: Theme.of(context).textTheme.labelLarge,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 0.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: null,
              icon: Tarifa.getIconPeriodo(periodoAhora),
              label: Text('P. ${periodoAhora.name.toUpperCase()}'),
            ),
            subtitle: TextButton.icon(
              style: TextButton.styleFrom(
                disabledBackgroundColor:
                    Theme.of(context).colorScheme.background.withOpacity(0.2),
                disabledForegroundColor:
                    Theme.of(context).colorScheme.onBackground,
                textStyle: Theme.of(context).textTheme.labelLarge,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 0.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                iconColor: desviacion > 0 ? Colors.red : Colors.green,
              ),
              onPressed: null,
              icon: Icon(desviacion > 0 ? Icons.upload : Icons.download),
              label: Text('${desviacion.toStringAsFixed(4)} €'),
            ),
          ),
        ),
      ],
    );
  }
}
