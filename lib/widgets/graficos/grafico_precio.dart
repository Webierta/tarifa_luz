import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:tarifa_luz/models/datos.dart';
import 'package:tarifa_luz/models/tarifa.dart';
import 'package:tarifa_luz/utils/estados.dart';

class GraficoPrecio extends StatefulWidget {
  final Datos data;
  final String fecha;
  const GraficoPrecio({
    super.key,
    required this.data,
    required this.fecha,
  });

  @override
  State<GraficoPrecio> createState() => _GraficoPrecioState();
}

class _GraficoPrecioState extends State<GraficoPrecio> {
  List<double> precios = [];
  //late int _selectedItem;
  late int horaValor;

  @override
  void initState() {
    precios = List.from(widget.data.preciosHora);
    horaValor = -1;
    //DateTime hoy = DateTime.now().toLocal();
    //int hora = hoy.hour;
    //_selectedItem = hora;
    super.initState();
  }

  double cuatroDec(double precio) {
    return double.parse((precio).toStringAsFixed(4));
  }

  final now = DateTime.now().toLocal();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(title: Text('PVPC ${widget.fecha}')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 40, 10, 20),
        child: BarChart(
          BarChartData(
            borderData: FlBorderData(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    /* return Text(
                      meta.formattedValue,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ); */
                    /* if (int.parse(meta.formattedValue) == 23) {
                      return Text(
                        '24',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      );
                    } */
                    if (int.parse(meta.formattedValue).isEven) {
                      if (now.hour == int.parse(meta.formattedValue)) {
                        return CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            meta.formattedValue,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        );
                      }
                      return Text(
                        meta.formattedValue,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      );
                    }
                    /* if (now.hour == int.parse(meta.formattedValue)) {
                      return const CircleAvatar(
                        backgroundColor: Colors.white,
                      );
                    } */
                    return const Text('');
                  },
                  //interval: 20,
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: widget.data.calcularPrecioMedio(widget.data.preciosHora),
                  strokeWidth: 1,
                  color: Theme.of(context).colorScheme.onBackground,
                  label: HorizontalLineLabel(
                    show: true,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    alignment: Alignment.topLeft,
                    labelResolver: (_) =>
                        'Media: ${cuatroDec(widget.data.calcularPrecioMedio(widget.data.preciosHora))}',
                  ),
                )
              ],
            ),
            barGroups: precios.asMap().entries.map(
              (precio) {
                Periodo periodo = Tarifa.getPeriodo(
                    widget.data.getDataTime(widget.data.fecha, precio.key));
                return BarChartGroupData(
                  x: precio.key + 1,
                  barRods: [
                    BarChartRodData(
                      toY: cuatroDec(precio.value),
                      width: 10,
                      color: Tarifa.getColorPeriodo(periodo),
                      borderSide: precio.key == now.hour
                          ? const BorderSide(color: Colors.white, width: 10)
                          : null,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    )
                  ],
                );
              },
            ).toList(),
          ),
          swapAnimationCurve: Curves.easeInOutCubic,
          swapAnimationDuration: const Duration(milliseconds: 1000),
        ),
      ),
    );
  }
}
