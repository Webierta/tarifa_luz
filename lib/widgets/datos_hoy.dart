import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tarifa_luz/models/datos.dart';
import 'package:tarifa_luz/models/tarifa.dart';
import 'package:tarifa_luz/utils/estados.dart';

class DatosHoy extends StatelessWidget {
  final Datos dataHoy;
  final String fecha;
  const DatosHoy({super.key, required this.dataHoy, required this.fecha});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toLocal();
    DateTime fechaData = DateFormat('dd/MM/yyyy').parse(fecha);
    fechaData = DateTime(
      fechaData.year,
      fechaData.month,
      fechaData.day,
      now.hour,
      now.minute,
    );
    DateTime hoy = fechaData;
    int hora = hoy.hour;
    String horaMin = DateFormat('HH:mm').format(hoy);
    double precioHoy = dataHoy.getPrecio(dataHoy.preciosHora, hora);
    Periodo periodoAhora = Tarifa.getPeriodo(hoy);
    String periodoAhoraNombre = Tarifa.getPeriodoNombre(periodoAhora);
    var desviacionHoy = dataHoy.preciosHora[hora] -
        dataHoy.calcularPrecioMedio(dataHoy.preciosHora);
    double anchoScreen = MediaQuery.of(context).size.width;

    List<double> listaPrecios = dataHoy.preciosHora;
    double precioMin = dataHoy.precioMin(listaPrecios);
    double precioMax = dataHoy.precioMax(listaPrecios);
    Color color = Tarifa.getColorCara(listaPrecios, precioHoy);

    Map<int, double> mapPreciosOrdenados = dataHoy.ordenarPrecios(listaPrecios);
    List<double> preciosOrdenados = mapPreciosOrdenados.values.toList();
    var indexPrecio = preciosOrdenados.indexOf(precioHoy) + 1;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      children: [
                        /* const Icon(Icons.calendar_today,
                            color: Colors.white, size: 16), */
                        //const SizedBox(width: 4),
                        Text(
                          '$fecha a las $horaMin',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 30,
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FittedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  precioHoy.toStringAsFixed(5),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Min', // precios.first
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.white),
                              ),
                              Text(
                                'Max', // precios.last
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                          LinearProgressIndicator(
                              value: indexPrecio / 24, color: color),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                precioMin.toStringAsFixed(3),
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                '€/kWh',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.white),
                              ),
                              Text(
                                precioMax.toStringAsFixed(3),
                                style: const TextStyle(color: Colors.white),
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
            Stack(
              alignment: Alignment.center,
              children: [
                RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    Icons.lightbulb,
                    color: Tarifa.getColorFondo(precioHoy),
                    size: anchoScreen / 3,
                  ),
                ),
                Positioned(
                  top: anchoScreen / 7.5,
                  child: Tarifa.getIconCara(
                    dataHoy.preciosHora,
                    dataHoy.preciosHora[hora],
                    size: anchoScreen / 6,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              TextButton.icon(
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
                ),
                onPressed: null,
                icon: Tarifa.getIconPeriodo(periodoAhora),
                label: Text('P. $periodoAhoraNombre'),
              ),
              TextButton.icon(
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
                  iconColor: desviacionHoy > 0 ? Colors.red : Colors.green,
                ),
                onPressed: null,
                icon: Icon(desviacionHoy > 0 ? Icons.upload : Icons.download),
                label: Text('${desviacionHoy.toStringAsFixed(4)} €'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
