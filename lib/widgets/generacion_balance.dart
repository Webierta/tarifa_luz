import 'package:flutter/material.dart';

import 'package:tarifa_luz/utils/estados.dart';

class GeneracionBalance extends StatelessWidget {
  final Map<String, double> sortedMap;
  final Generacion generacion;
  final double total;
  const GeneracionBalance(
      {super.key,
      required this.sortedMap,
      required this.generacion,
      required this.total});

  String calcularPorcentaje(double valor) {
    return ((valor * 100) / total).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: DropdownButton<double>(
        underline: Container(height: 0),
        isExpanded: true,
        hint: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    generacion.tipo,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FittedBox(
                child: Text(
                  '${calcularPorcentaje(sortedMap[generacion.texto] ?? 0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
            ),
          ],
        ),
        style: const TextStyle(color: Colors.white),
        //iconEnabledColor: Colors.blueAccent,
        icon: Container(
          transform: Matrix4.translationValues(8.0, 0.0, 0.0),
          child: const Icon(Icons.zoom_in), //size 24
        ),
        dropdownColor: Colors.blue,
        isDense: true,
        items: sortedMap
            .map((description, value) {
              return MapEntry(
                  description,
                  DropdownMenuItem<double>(
                    value: value,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FittedBox(child: Text(description)),
                            Text('${calcularPorcentaje(value)}%'),
                          ],
                        ),
                        LinearProgressIndicator(
                          value: ((double.tryParse(calcularPorcentaje(value)) ??
                                  100)) /
                              100,
                          backgroundColor: Colors.black12,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ));
            })
            .values
            .toList(),
        onChanged: (_) {},
      ),
    );
  }
}
