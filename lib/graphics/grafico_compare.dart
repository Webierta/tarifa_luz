import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:tarifa_luz/database/box_data.dart';

const List<Color> colores = [
  Colors.yellow,
  Colors.blue,
  Colors.red,
  Colors.green
];

class GraficoCompare extends StatefulWidget {
  final List<BoxData> boxDataList;
  const GraficoCompare({required this.boxDataList, super.key});
  @override
  State<GraficoCompare> createState() => _GraficoCompareState();
}

class _GraficoCompareState extends State<GraficoCompare> {
  Map<int, bool> visible = {0: true, 1: true, 2: true, 3: true};

  void setVisible(int index) {
    setState(() {
      if (visible[index] == true) {
        visible[index] = false;
      } else {
        visible[index] = true;
      }
    });
  }

  Color getColor(int index) {
    if (visible[index] == true) {
      return colores[index];
    } else {
      return Colors.transparent;
    }
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

  double getMaxY() {
    List<double> preciosMaxList = [];
    List<double> preciosMediosList = [];
    for (BoxData boxData in widget.boxDataList) {
      preciosMaxList.add(boxData.precioMax);
      preciosMediosList.add(boxData.precioMedio);
    }

    preciosMaxList.sort();
    preciosMediosList.sort();
    return preciosMaxList.last + (preciosMediosList.last / 3);
  }

  @override
  Widget build(BuildContext context) {
    double widthFactor = 0;
    if (widget.boxDataList.length == 3) {
      widthFactor = 0.3;
    } else {
      if (MediaQuery.of(context).size.width > 400) {
        widthFactor = 0.2;
      } else {
        widthFactor = 0.4;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparativa PVPC'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: [
                  for (BoxData boxData in widget.boxDataList)
                    FractionallySizedBox(
                      widthFactor: widthFactor,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: InputChip(
                          onPressed: () {
                            setVisible(widget.boxDataList.indexOf(boxData));
                          },
                          avatar: CircleAvatar(
                            backgroundColor: getColor(
                              widget.boxDataList.indexOf(boxData),
                            ),
                          ),
                          label: Text(
                            boxData.fechaddMMyy,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 40, 10, 0),
                  width: double.infinity,
                  child: LineChart(
                    LineChartData(
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
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 0.05,
                            getTitlesWidget: (value, meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                //space: 4,
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
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: false,
                        drawVerticalLine: true,
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.grey.withOpacity(0.4),
                            strokeWidth: 0.8,
                            dashArray: [2, 2],
                          );
                        },
                      ),
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          ...getExtraLinesY(),
                        ],
                      ),
                      minY: 0,
                      maxY: getMaxY(),
                      lineBarsData: [
                        for (BoxData boxData in widget.boxDataList)
                          //for (int index = 0; index < boxDataList.length; index++)
                          LineChartBarData(
                            spots: boxData.preciosHora
                                .asMap()
                                .entries
                                .map(
                                  (precio) => FlSpot(
                                    precio.key.toDouble() + 1,
                                    cuatroDec(precio.value),
                                  ),
                                )
                                .toList(),
                            isCurved: true,
                            barWidth: 2,
                            color: getColor(
                              widget.boxDataList.indexOf(boxData),
                            ),
                            belowBarData: BarAreaData(
                              show: visible[
                                      widget.boxDataList.indexOf(boxData)] ==
                                  true,
                              gradient: LinearGradient(
                                colors: [
                                  getColor(widget.boxDataList.indexOf(boxData))
                                      .withOpacity(0.5),
                                  getColor(widget.boxDataList.indexOf(boxData))
                                      .withOpacity(0),
                                ],
                                stops: const [0.5, 1.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
