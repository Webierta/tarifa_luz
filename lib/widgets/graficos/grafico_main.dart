import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tarifa_luz/models/datos.dart';
import 'package:tarifa_luz/theme/style_app.dart';

class GraficoMain extends StatelessWidget {
  final Datos dataHoy;
  final String fecha;

  const GraficoMain({
    super.key,
    required this.dataHoy,
    required this.fecha,
  });

  @override
  Widget build(BuildContext context) {
    List<double> precios = List.from(dataHoy.preciosHora);
    //var axisMin = (dataHoy.precioMin(precios)) - 0.01;
    double altoScreen = MediaQuery.of(context).size.height;

    final now = DateTime.now().toLocal();
    //final today = DateTime(now.year, now.month, now.day);
    DateTime fechaData = DateFormat('dd/MM/yyyy').parse(fecha);
    fechaData = DateTime(
        fechaData.year, fechaData.month, fechaData.day, now.hour, now.minute);

    //DateTime hoy = today == fechaData ? now : fechaData;
    /*DateTime hoy = DateTime(today.year, today.month, today.day)
                .difference(
                    DateTime(fechaData.year, fechaData.month, fechaData.day))
                .inDays ==
            0
        ? now
        : fechaData;*/
    //DateTime hoy = fechaData;
    //DateTime hoy = DateTime.now().toLocal();
    //int hora = hoy.hour;
    //int horaValor = -1;

    double cuatroDec(double precio) {
      return double.parse((precio).toStringAsFixed(4));
    }

    return ClipPath(
      clipper: StyleApp.kBorderClipper,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
        width: double.infinity,
        height: altoScreen / 3,
        decoration: StyleApp.kBoxDeco,
        child: LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 2,
                  getTitlesWidget: (value, meta) {
                    if (int.parse(meta.formattedValue).isEven) {
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
                  y: dataHoy.calcularPrecioMedio(dataHoy.preciosHora),
                  strokeWidth: 1,
                  dashArray: [2, 2],
                  color: Theme.of(context).colorScheme.onBackground,
                  /* label: HorizontalLineLabel(
                    show: true,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    alignment: Alignment.topLeft,
                    labelResolver: (_) =>
                        'Media: ${cuatroDec(dataHoy.calcularPrecioMedio(dataHoy.preciosHora))}',
                  ), */
                )
              ],
            ),
            lineBarsData: [
              LineChartBarData(
                spots: precios.map((precio) {
                  return FlSpot(precios.indexOf(precio).toDouble() + 1,
                      cuatroDec(precio));
                }).toList(),
                isCurved: true,
                barWidth: 2,
                color: Colors.white,
                /* dotData: FlDotData(
                  show: false,
                  getDotPainter: (p0, p1, p2, p3) =>
                      FlDotCirclePainter(color: Colors.green),
                ), */

                belowBarData: BarAreaData(
                  show: false,
                  /* gradient: Gradient(),
          gradientFrom: Offset(0, 0),
          gradientTo: Offset(0, 1),
          colors: [
            Colors.black.withOpacity(0.1),
            Colors.black.withOpacity(0),
          ] */
                ),
              ),
            ],
            /* lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    final textStyle = TextStyle(
                      color: touchedSpot.bar.gradient?.colors[0] ??
                          touchedSpot.bar.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    );
                    return LineTooltipItem(
                        '${touchedSpot.y.toStringAsFixed(2)}\n${fecha.substring(0, 5)}',
                        textStyle);
                  }).toList();
                },
              ),
              touchCallback: (_, __) {},
              handleBuiltInTouches: true,
            ), */

            /* lineBarsData: precios.map((precio) {
              return LineChartBarData(
                spots: precios.map((e) => FlSpot(e, 0)).toList(),
                isCurved: true,
                barWidth: 3,
                color: Colors.indigo,
              );
            }).toList(), */
          ),
        ),
      ),
    );
  }
}
