import 'package:flutter/material.dart';
import 'package:tarifa_luz/database/box_data.dart';
import 'package:tarifa_luz/graphics/grafico_home.dart';
import 'package:tarifa_luz/models/tarifa.dart';
import 'package:tarifa_luz/tabs/head_home_tab.dart';
import 'package:tarifa_luz/theme/style_app.dart';
import 'package:tarifa_luz/utils/estados.dart';
import 'package:tarifa_luz/widgets/generacion_balance.dart';
import 'package:tarifa_luz/widgets/generacion_error.dart';
import 'package:tarifa_luz/widgets/list_tile_fecha.dart';

class HomeTab extends StatelessWidget {
  final BoxData boxData;
  const HomeTab({required this.boxData, super.key});

  Periodo get periodoMin {
    int hora = boxData.getHour(boxData.preciosHora, boxData.precioMin);
    DateTime f = boxData.fecha.copyWith(hour: hora);
    return Tarifa.getPeriodo(f);
  }

  Periodo get periodoMax {
    int hora = boxData.getHour(boxData.preciosHora, boxData.precioMax);
    DateTime f = boxData.fecha.copyWith(hour: hora);
    return Tarifa.getPeriodo(f);
  }

  /* String get horaPeriodoMin => boxData.getHora(
        boxData.preciosHora,
        boxData.precioMin,
      );

  String get horaPeriodoMax => boxData.getHora(
        boxData.preciosHora,
        boxData.precioMax,
      ); */

  double get desviacionMin => boxData.precioMin - boxData.precioMedio;
  double get desviacionMax => boxData.precioMax - boxData.precioMedio;

  double get total {
    return (boxData.generacion[Generacion.renovable.texto] ?? 0) +
        (boxData.generacion[Generacion.noRenovable.texto] ?? 0);
  }

  Map<String, double> sortedMap(Map<String, double> mapDataGeneracion) {
    var mapGeneracion = <String, double>{};
    mapGeneracion = Map.from(mapDataGeneracion);
    return Map.fromEntries(mapGeneracion.entries.toList()
      ..sort((e1, e2) => (e2.value).compareTo((e1.value))));
  }

  String calcularPorcentaje(double valor) {
    return ((valor * 100) / total).toStringAsFixed(1);
  }

  double valueLinearProgress(String typo) {
    var g = typo == 'Generación renovable'
        ? sortedMap(boxData.mapRenovables!)
        : sortedMap(boxData.mapNoRenovables!);
    return (double.tryParse(calcularPorcentaje(g[typo] ?? 100)) ?? 100) / 100;
  }

  @override
  Widget build(BuildContext context) {
    double altoScreen = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          HeadHomeTab(boxData: boxData),
          const SizedBox(height: 20),
          GraficoHome(boxData: boxData),
          SizedBox(height: altoScreen / 20),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: StyleApp.onBackgroundColor,
                      size: 24,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Precios mínimo y máximo',
                      style: TextStyle(
                        color: StyleApp.onBackgroundColor,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
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
                        hora: boxData.horaPrecioMin, // horaPeriodoMin
                        precio: boxData.precioMin.toStringAsFixed(5),
                        desviacion: desviacionMin,
                      ),
                      Divider(
                        //color: StyleApp.onBackgroundColor.withOpacity(0.5),
                        color: StyleApp.onBackgroundColor.withAlpha(50),
                        indent: 20,
                        endIndent: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTileFecha(
                          periodo: periodoMax,
                          hora: boxData.horaPrecioMax, // horaPeriodoMax,
                          precio: boxData.precioMax.toStringAsFixed(5),
                          desviacion: desviacionMax,
                        ),
                      ),
                      Divider(
                        //color: StyleApp.onBackgroundColor.withOpacity(0.5),
                        color: StyleApp.onBackgroundColor.withAlpha(50),
                        indent: 20,
                        endIndent: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Precio Medio: ${(boxData.precioMedio).toStringAsFixed(5)} €/kWh',
                          style: const TextStyle(
                            color: StyleApp.onBackgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: altoScreen / 20),
          const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Row(
              children: [
                Icon(
                  Icons.bolt,
                  color: StyleApp.onBackgroundColor,
                  size: 24,
                ),
                SizedBox(width: 4),
                Text(
                  'Balance Generación',
                  style: TextStyle(
                    color: StyleApp.onBackgroundColor,
                    fontSize: 16,
                  ),
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
              child: (boxData.mapRenovables == null ||
                      boxData.mapNoRenovables == null ||
                      (boxData.mapRenovables?.isEmpty ?? true) ||
                      (boxData.mapRenovables?.isEmpty ?? true) ||
                      (!boxData.generacion
                          .containsKey(Generacion.renovable.texto)) ||
                      !boxData.generacion
                          .containsKey(Generacion.noRenovable.texto))
                  ? const GeneracionError()
                  : Column(
                      children: [
                        GeneracionBalance(
                          sortedMap: sortedMap(boxData.mapRenovables!),
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
                          sortedMap: sortedMap(boxData.mapNoRenovables!),
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
                              DateTime.now().difference(boxData.fecha).inDays >=
                                      1
                                  ? 'Datos programados'
                                  : 'Datos previstos',
                              style: TextStyle(
                                color:
                                    //StyleApp.onBackgroundColor.withOpacity(0.8),
                                    StyleApp.onBackgroundColor.withAlpha(180),
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
                //Divider(color: StyleApp.onBackgroundColor.withOpacity(0.5)),
                Divider(color: StyleApp.onBackgroundColor.withAlpha(50)),
                Text('Fuente: REE (e·sios y REData)',
                    style: TextStyle(
                      //color: StyleApp.onBackgroundColor.withOpacity(0.5),
                      color: StyleApp.onBackgroundColor.withAlpha(100),
                    )),
                //Divider(color: StyleApp.onBackgroundColor.withOpacity(0.5)),
                Divider(color: StyleApp.onBackgroundColor.withAlpha(50)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
