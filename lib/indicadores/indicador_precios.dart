import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';

import '../database/box_data.dart';

class IndicadorPrecios extends StatelessWidget {
  final BoxData boxData;

  const IndicadorPrecios({super.key, required this.boxData});

  List<RangeLinearGauge> getRangeLinear() {
    //final double precioMin = double.parse(boxData.precioMin.toStringAsFixed(4));
    final double precioMax = double.parse(boxData.precioMax.toStringAsFixed(4));

    return [
      RangeLinearGauge(
        color: Colors.lightGreen,
        start: 0,
        end: precioMax < 0.10 ? precioMax : 0.10,
      ),
      if (precioMax > 0.10)
        RangeLinearGauge(
          color: Colors.yellow.shade200,
          start: 0.10,
          end: precioMax < 0.15 ? precioMax : 0.15,
        ),
      if (precioMax > 0.15)
        RangeLinearGauge(
          color: Colors.red.shade200,
          start: 0.15,
          end: precioMax,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final hora = DateTime.now().toLocal().hour;
    //final hora = boxData.fecha.hour;
    final precios = boxData.preciosHora;
    final precioMin = double.parse(boxData.precioMin.toStringAsFixed(4));
    final precioMax = double.parse(boxData.precioMax.toStringAsFixed(4));

    return LinearGauge(
      rulers: RulerStyle(
        rulerPosition: RulerPosition.right,
        showPrimaryRulers: true,
        primaryRulerColor: Colors.white,
        showLabel: true,
        textStyle: TextStyle(color: Colors.white),
        showSecondaryRulers: false,
        secondaryRulerColor: Colors.white,
      ),
      gaugeOrientation: GaugeOrientation.vertical,
      start: 0, //precioMin,
      end: precioMax,
      steps: 1,
      rangeLinearGauge: getRangeLinear(),
      linearGaugeBoxDecoration: LinearGaugeBoxDecoration(thickness: 10),
      pointers: [
        if (precioMax > 0.1)
          Pointer(
            value: 0.10,
            shape: PointerShape.rectangle,
            color: Colors.white,
            height: 2,
            pointerPosition: PointerPosition.left,
            showLabel: true,
            labelStyle: TextStyle(fontSize: 12),
          ),
        if (precioMax > 0.15)
          Pointer(
            value: 0.15,
            shape: PointerShape.rectangle,
            color: Colors.white,
            height: 2,
            pointerPosition: PointerPosition.left,
            showLabel: true,
            labelStyle: TextStyle(fontSize: 12),
          ),
        Pointer(
          value:
              double.parse(boxData.getPrecio(precios, hora).toStringAsFixed(4)),
          shape: PointerShape.triangle,
          //color: Tarifa.getColorBorder(boxData.getPrecio(precios, hora)),
          color: Colors.white,
          pointerPosition: PointerPosition.left,
          //showLabel: true,
        ),
        Pointer(
          value:
              double.parse(boxData.getPrecio(precios, hora).toStringAsFixed(4)),
          pointerPosition: PointerPosition.right,
          //color: Tarifa.getColorBorder(boxData.getPrecio(precios, hora)),
          color: Colors.white,
          shape: PointerShape.triangle,
          //showLabel: true,
        ),
        Pointer(
          value: precioMin,
          pointerPosition: PointerPosition.right,
          shape: PointerShape.rectangle,
          height: 2,
          color: Colors.green,
          showLabel: true,
          labelStyle: TextStyle(
            //fontSize: 14,
            color: Colors.green,
          ),
        ),
        Pointer(
          value: double.parse(boxData.precioMedio.toStringAsFixed(4)),
          pointerPosition: PointerPosition.right,
          shape: PointerShape.rectangle,
          height: 2,
          color: Colors.white54,
          showLabel: true,
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
