import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:tarifa_luz/database/box_data.dart';
import 'package:tarifa_luz/theme/style_app.dart';

class GraficoHome extends StatelessWidget {
  final BoxData boxData;
  const GraficoHome({required this.boxData, super.key});

  @override
  Widget build(BuildContext context) {
    final double altoScreen = MediaQuery.of(context).size.height;
    final now = DateTime.now().toLocal();

    double cuatroDec(double precio) {
      return double.parse((precio).toStringAsFixed(4));
    }

    return ClipPath(
      clipper: StyleApp.kBorderClipper,
      child: Container(
        padding: const EdgeInsets.all(20),
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
                      return Text(meta.formattedValue);
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
                  y: boxData.precioMedio,
                  strokeWidth: 1,
                  dashArray: [2, 2],
                  color: Theme.of(context).colorScheme.onBackground,
                )
              ],
            ),
            minY: boxData.precioMin - (boxData.precioMedio / 4),
            maxY: boxData.precioMax + (boxData.precioMedio / 3),
            lineBarsData: [
              LineChartBarData(
                spots: boxData.preciosHora
                    .asMap()
                    .entries
                    .map((precio) => FlSpot(
                        precio.key.toDouble() + 1, cuatroDec(precio.value)))
                    .toList(),
                isCurved: true,
                barWidth: 2,
                color: Colors.white,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (p0, p1, p2, p3) {
                    if (p3 == now.hour) {
                      return FlDotCirclePainter(
                        color: Colors.red,
                        radius: 6,
                        strokeColor: Colors.white,
                        strokeWidth: 2,
                      );
                    }
                    return FlDotCirclePainter(
                      color: Colors.white,
                      strokeWidth: 0,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
