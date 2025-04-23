import 'package:flutter/material.dart';
import 'package:tarifa_luz/database/box_data.dart';
import 'package:tarifa_luz/models/tarifa.dart';
import 'package:tarifa_luz/tabs/head_tab.dart';
import 'package:tarifa_luz/theme/style_app.dart';
import 'package:tarifa_luz/utils/estados.dart';

class PreciosTab extends StatelessWidget {
  final int tab;
  final BoxData boxData;
  const PreciosTab({required this.tab, required this.boxData, super.key});

  String get titulo => tab == 1
      ? 'Evolución diaria del Precio €/kWh'
      : 'Horas por Precio €/kWh ascendente';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: <Widget>[
          HeadTab(fecha: boxData.fechaddMMyy, titulo: titulo),
          ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    height: 0.2,
                    //color: StyleApp.backgroundColor.withOpacity(0.2),
                    color: StyleApp.backgroundColor.withAlpha(20),
                  ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: boxData.preciosHora.length,
              itemBuilder: (context, index) {
                List<double> precios;
                int indice;
                if (tab == 1) {
                  precios = boxData.preciosHora;
                  indice = index;
                } else {
                  List<double> listaPrecios = boxData.preciosHora;
                  Map<int, double> mapPreciosOrdenados =
                      boxData.ordenarPrecios(listaPrecios);
                  precios = mapPreciosOrdenados.values.toList();
                  var listaKeys = mapPreciosOrdenados.keys.toList();
                  indice = listaKeys[index];
                }
                Color color = Tarifa.getColorFondo(precios[index]);
                DateTime fechaHour = boxData.fecha.copyWith(hour: indice);
                Periodo periodo = Tarifa.getPeriodo(fechaHour);
                Color colorPeriodo = Tarifa.getColorPeriodo(periodo);
                double precioMedio = boxData.precioMedio;
                double desviacion = precios[index] - precioMedio;

                BorderRadius borderRadius = const BorderRadius.all(Radius.zero);
                if (index == 0) {
                  borderRadius = const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  );
                } else if (index == boxData.preciosHora.length - 1) {
                  borderRadius = const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  );
                }

                return Container(
                  clipBehavior: Clip.hardEdge,
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      //stops: const [0.04, 0.02],
                      stops: const [0.04, 0.04],
                      colors: [colorPeriodo, color],
                    ),
                    borderRadius: borderRadius,
                    color: color,
                  ),
                  child: ListTile(
                    leading: tab == 1
                        //? Tarifa.getIconCara(precios, precios[index])
                        ? Text(
                            Tarifa.getEmojiCara(precios, precios[index]),
                            style: TextStyle(fontSize: 30),
                          )
                        : Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: StyleApp.backgroundColor,
                            ),
                          ),
                    title: tab == 1
                        ? Text(
                            (precios[index]).toStringAsFixed(5),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: StyleApp.backgroundColor),
                          )
                        : Text(
                            '${indice}h - ${indice + 1}h',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: StyleApp.backgroundColor),
                          ),
                    subtitle: tab == 1
                        ? Text(
                            '${index}h - ${index + 1}h',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: StyleApp.backgroundColor),
                          )
                        : Text(
                            precios[index].toStringAsFixed(5),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: StyleApp.backgroundColor),
                          ),
                    trailing: Column(
                      children: [
                        Flexible(
                          child: Icon(
                            desviacion > 0 ? Icons.upload : Icons.download,
                            color: desviacion > 0 ? Colors.red : Colors.green,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '${desviacion.toStringAsFixed(4)} €',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: StyleApp.backgroundColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
