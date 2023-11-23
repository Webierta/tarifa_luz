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
  final now = DateTime.now().toLocal();

  @override
  void initState() {
    precios = List.from(widget.boxData.preciosHora);
    super.initState();
  }

  double cuatroDec(double precio) {
    return double.parse((precio).toStringAsFixed(4));
  }

  List<HorizontalLine> getExtraLinesY() {
    List<HorizontalLine> horizontalLines = [];
    for (double i = 0; i < 0.50; i += 0.05) {
      horizontalLines.add(HorizontalLine(
        y: i,
        strokeWidth: 1,
        dashArray: [2, 2],
        color: Colors.white30,
      ));
    }
    return horizontalLines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PVPC ${widget.boxData.fechaddMMyy}')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 10, 10),
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
                    //interval: 2,
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
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 0.05,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 4,
                        child: meta.formattedValue.endsWith('5') ||
                                meta.formattedValue.endsWith('0')
                            ? FittedBox(
                                child: Text(
                                  meta.formattedValue,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              )
                            : const SizedBox(width: 0, height: 0),
                      );
                    },
                  ),
                ),
              ),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: widget.boxData.precioMedio,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                    color: Colors.blue[100],
                    label: HorizontalLineLabel(
                      show: true,
                      padding: const EdgeInsets.only(left: 10, bottom: 4),
                      alignment: Alignment.topLeft,
                      labelResolver: (_) =>
                          'Media: ${cuatroDec(widget.boxData.precioMedio)}',
                    ),
                  ),
                  ...getExtraLinesY(),
                ],
              ),
              minY: widget.boxData.precioMin - (widget.boxData.precioMedio / 4),
              maxY: widget.boxData.precioMax + (widget.boxData.precioMedio / 3),
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
                        width: 20,
                        color: Tarifa.getColorPeriodo(periodo),
                        /* borderSide: precio.key == now.hour
                            ? const BorderSide(
                                color: Colors.white,
                                width: 10,
                              )
                            : null, */
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                },
              ).toList(),
            ),
            swapAnimationCurve: Curves.easeInOutCubic,
            swapAnimationDuration: const Duration(milliseconds: 1000),
          ),
        ),
      ),
    );
  }
}
