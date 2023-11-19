import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:tarifa_luz/database/box_data.dart';
import 'package:tarifa_luz/models/tarifa.dart';
import 'package:tarifa_luz/utils/estados.dart';

class GraficoPrecios extends StatefulWidget {
  final BoxData boxData;
  const GraficoPrecios({required this.boxData, super.key});
  @override
  State<GraficoPrecios> createState() => _GraficoPreciosState();
}

class _GraficoPreciosState extends State<GraficoPrecios>
    with TickerProviderStateMixin {
  List<double> precios = [];
  int horaValor = -1;
  final now = DateTime.now().toLocal();

  @override
  void initState() {
    precios = List.from(widget.boxData.preciosHora);
    //horaValor = -1;
    super.initState();
  }

  double cuatroDec(double precio) {
    return double.parse((precio).toStringAsFixed(4));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PVPC ${widget.boxData.fechaddMMyy}')),
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
                    if (int.parse(meta.formattedValue).isEven) {
                      if (int.parse(meta.formattedValue) == now.hour + 1) {
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
                    return const Text('');
                  },
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
                  y: widget.boxData.precioMedio,
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
                        'Media: ${cuatroDec(widget.boxData.precioMedio)}',
                  ),
                )
              ],
            ),
            barGroups: precios.asMap().entries.map(
              (precio) {
                DateTime fechaHour =
                    widget.boxData.fecha.copyWith(hour: precio.key);
                Periodo periodo = Tarifa.getPeriodo(fechaHour);
                return BarChartGroupData(
                  x: precio.key + 1,
                  barRods: [
                    BarChartRodData(
                      toY: cuatroDec(precio.value),
                      width: 10,
                      color: Tarifa.getColorPeriodo(periodo),
                      borderSide: precio.key == now.hour
                          ? const BorderSide(
                              color: Colors.white,
                              width: 10,
                            )
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
