import 'package:flutter/material.dart';

import 'package:tarifa_luz/models/datos.dart';
import 'package:tarifa_luz/models/datos_generacion.dart';
import 'package:tarifa_luz/models/tarifa.dart';
import 'package:tarifa_luz/theme/style_app.dart';
import 'package:tarifa_luz/theme/theme_app.dart';
import 'package:tarifa_luz/utils/estados.dart';
import 'package:tarifa_luz/widgets/datos_hoy.dart';
import 'package:tarifa_luz/widgets/generacion_balance.dart';
import 'package:tarifa_luz/widgets/generacion_error.dart';
import 'package:tarifa_luz/widgets/graficos/grafico_main.dart';
import 'package:tarifa_luz/widgets/list_tile_fecha.dart';

class MainTab extends StatelessWidget {
  final String fecha;
  final Datos data;
  final DatosGeneracion? dataGeneracion;

  const MainTab(
      {super.key,
      required this.fecha,
      required this.data,
      this.dataGeneracion});

  Periodo get periodoMin => Tarifa.getPeriodo(data.getDataTime(
        data.fecha,
        data.getHour(
          data.preciosHora,
          data.precioMin(data.preciosHora),
        ),
      ));

  Periodo get periodoMax => Tarifa.getPeriodo(data.getDataTime(
        data.fecha,
        data.getHour(
          data.preciosHora,
          data.precioMax(data.preciosHora),
        ),
      ));

  double get desviacionMin =>
      data.precioMin(data.preciosHora) -
      data.calcularPrecioMedio(data.preciosHora);

  double get desviacionMax =>
      data.precioMax(data.preciosHora) -
      data.calcularPrecioMedio(data.preciosHora);

  String get horaPeriodoMin => data.getHora(
        data.preciosHora,
        data.precioMin(data.preciosHora),
      );

  String get horaPeriodoMax => data.getHora(
        data.preciosHora,
        data.precioMax(data.preciosHora),
      );

  String get precioPeriodoMin =>
      data.precioMin(data.preciosHora).toStringAsFixed(5);

  String get precioPeriodoMax =>
      data.precioMax(data.preciosHora).toStringAsFixed(5);

  double get total {
    return (dataGeneracion!.generacion[Generacion.renovable.texto] ?? 0) +
        (dataGeneracion!.generacion[Generacion.noRenovable.texto] ?? 0);
  }

  Map<String, double> sortedMap(Map<String, double> mapDataGeneracion) {
    var mapGeneracion = <String, double>{};
    mapGeneracion = Map.from(mapDataGeneracion);
    return Map.fromEntries(mapGeneracion.entries.toList()
      ..sort((e1, e2) => (e2.value).compareTo((e1.value))));
  }

  /* Map<String, double> sortedMapRenovables() {
    var mapRenovables = <String, double>{};
    mapRenovables = Map.from(dataGeneracion!.mapRenovables);
    return Map.fromEntries(mapRenovables.entries.toList()
      ..sort((e1, e2) => (e2.value).compareTo((e1.value))));
  }

  Map<String, double> sortedMapNoRenovables() {
    var mapNoRenovables = <String, double>{};
    mapNoRenovables = Map.from(dataGeneracion!.mapNoRenovables);
    return Map.fromEntries(mapNoRenovables.entries.toList()
      ..sort((e1, e2) => (e2.value).compareTo((e1.value))));
  } */

  String calcularPorcentaje(double valor) {
    return ((valor * 100) / total).toStringAsFixed(1);
  }

  double valueLinearProgress(String typo) {
    return (double.tryParse(
                calcularPorcentaje(dataGeneracion!.generacion[typo] ?? 100)) ??
            100) /
        100;
  }

  @override
  Widget build(BuildContext context) {
    double altoScreen = MediaQuery.of(context).size.height;
    final Color onBackgroundColor = ThemeApp(context).onBackgroundColor;
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          DatosHoy(dataHoy: data, fecha: fecha),
          const SizedBox(height: 20),
          GraficoMain(dataHoy: data, fecha: fecha),
          SizedBox(height: altoScreen / 20),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: onBackgroundColor,
                      size: 24,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Precios mínimo y máximo',
                      style: TextStyle(color: onBackgroundColor, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              ClipPath(
                clipper: StyleApp.kBorderClipper,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  decoration: StyleApp.kBoxDeco,
                  child: Column(
                    children: [
                      ListTileFecha(
                        periodo: periodoMin,
                        hora: horaPeriodoMin,
                        precio: precioPeriodoMin,
                        desviacion: desviacionMin,
                      ),
                      Divider(
                        color: onBackgroundColor.withOpacity(0.5),
                        indent: 20,
                        endIndent: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTileFecha(
                          periodo: periodoMax,
                          hora: horaPeriodoMax,
                          precio: precioPeriodoMax,
                          desviacion: desviacionMax,
                        ),
                      ),
                      Divider(
                        color: onBackgroundColor.withOpacity(0.5),
                        indent: 20,
                        endIndent: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Precio Medio: ${(data.calcularPrecioMedio(data.preciosHora)).toStringAsFixed(5)} €/kWh',
                          style: TextStyle(color: onBackgroundColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: altoScreen / 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                Icon(Icons.bolt, color: onBackgroundColor, size: 24),
                const SizedBox(width: 4),
                Text(
                  'Balance Generación',
                  style: TextStyle(color: onBackgroundColor, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          ClipPath(
            clipper: StyleApp.kBorderClipper,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
              width: double.infinity,
              decoration: StyleApp.kBoxDeco,
              child: (dataGeneracion == null ||
                          dataGeneracion?.status == StatusGeneracion.error) ||
                      (dataGeneracion?.generacion.isEmpty ?? true) ||
                      (dataGeneracion?.mapRenovables.isEmpty ?? true) ||
                      (dataGeneracion?.mapNoRenovables.isEmpty ?? true) ||
                      (!dataGeneracion!.generacion
                          .containsKey(Generacion.renovable.texto)) ||
                      !dataGeneracion!.generacion
                          .containsKey(Generacion.noRenovable.texto)
                  ? const GeneracionError()
                  : Column(
                      children: [
                        GeneracionBalance(
                          sortedMap: sortedMap(dataGeneracion!.mapRenovables),
                          //sortedMap: sortedMapRenovables(),
                          generacion: Generacion.renovable,
                          total: total,
                        ),
                        LinearProgressIndicator(
                          value:
                              valueLinearProgress(Generacion.renovable.texto),
                          backgroundColor: Colors.grey,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 20),
                        GeneracionBalance(
                          sortedMap: sortedMap(dataGeneracion!.mapNoRenovables),
                          //sortedMap: sortedMapNoRenovables(),
                          generacion: Generacion.noRenovable,
                          total: total,
                        ),
                        LinearProgressIndicator(
                          value:
                              valueLinearProgress(Generacion.noRenovable.texto),
                          backgroundColor: Colors.grey,
                          color: Colors.red,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              DateTime.now()
                                          .difference(
                                              DateTime.parse(data.fecha))
                                          .inDays >=
                                      1
                                  ? 'Datos programados'
                                  : 'Datos previstos',
                              style: TextStyle(
                                color: onBackgroundColor.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          SizedBox(height: altoScreen / 20),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Divider(color: onBackgroundColor.withOpacity(0.5)),
                Text('Fuente: REE (e·sios y REData)',
                    style: TextStyle(
                      color: onBackgroundColor.withOpacity(0.5),
                    )),
                Divider(color: onBackgroundColor.withOpacity(0.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
