import 'package:flutter/material.dart';

import 'package:tarifa_luz/models/datos.dart';
import 'package:tarifa_luz/models/datos_generacion.dart';
import 'package:tarifa_luz/widgets/tabs/main_tab.dart';
import 'package:tarifa_luz/widgets/tabs/range_tab.dart';
import 'package:tarifa_luz/widgets/tabs/tabla_tab.dart';

class DataScreen extends StatelessWidget {
  final int tab;
  final Datos data;
  final String fecha;
  final DatosGeneracion? dataGeneracion;

  const DataScreen({
    super.key,
    required this.tab,
    required this.data,
    required this.fecha,
    this.dataGeneracion,
  });

  @override
  Widget build(BuildContext context) {
    return switch (tab) {
      0 => MainTab(
          data: data,
          fecha: fecha,
          dataGeneracion: dataGeneracion,
        ),
      1 => TablaTab(
          page: 2,
          fecha: fecha,
          titulo: 'Evolución del Precio en el día',
          data: data),
      2 => TablaTab(
          page: 3,
          fecha: fecha,
          titulo: 'Horas por Precio ascendente',
          data: data),
      3 => RangeTab(fecha: fecha, data: data),
      int() => MainTab(
          data: data,
          fecha: fecha,
          dataGeneracion: dataGeneracion,
        ),
    };
  }
}
