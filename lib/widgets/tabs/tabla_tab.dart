import 'package:flutter/material.dart';

import 'package:tarifa_luz/models/datos.dart';
import 'package:tarifa_luz/theme/theme_app.dart';
import 'package:tarifa_luz/utils/estados.dart';
import 'package:tarifa_luz/models/tarifa.dart';
import 'package:tarifa_luz/widgets/tabs/head_tab.dart';

class TablaTab extends StatelessWidget {
  final int page;
  final String fecha;
  final String titulo;
  final Datos data;
  const TablaTab(
      {super.key,
      required this.page,
      required this.fecha,
      required this.titulo,
      required this.data});

  Color getColorPeriodo(int index) {
    final Periodo periodo =
        Tarifa.getPeriodo(data.getDataTime(data.fecha, index));
    if (periodo == Periodo.valle) {
      return const Color(0xFF81C784);
    } else if (periodo == Periodo.punta) {
      return const Color(0xFFE57373);
    } else {
      return Colors.amberAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = ThemeApp(context).backgroundColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: <Widget>[
          HeadTab(fecha: fecha, titulo: titulo),
          ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    height: 0.2,
                    color: backgroundColor.withOpacity(0.2),
                  ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.preciosHora.length,
              itemBuilder: (context, index) {
                List<double> precios;
                int indice;
                if (page == 2) {
                  precios = data.preciosHora;
                  indice = index;
                } else {
                  //var listaPrecios = List.from(data.preciosHora);
                  List<double> listaPrecios = data.preciosHora;
                  Map<int, double> mapPreciosOrdenados =
                      data.ordenarPrecios(listaPrecios);
                  precios = mapPreciosOrdenados.values.toList();
                  var listaKeys = mapPreciosOrdenados.keys.toList();
                  indice = listaKeys[index];
                }
                Color color = Tarifa.getColorFondo(precios[index]);
                Periodo periodo =
                    Tarifa.getPeriodo(data.getDataTime(data.fecha, indice));
                Color colorPeriodo = Tarifa.getColorPeriodo(periodo);
                double precioMedio = data.calcularPrecioMedio(data.preciosHora);
                double desviacion = precios[index] - precioMedio;

                BorderRadius borderRadius = const BorderRadius.all(Radius.zero);
                if (index == 0) {
                  borderRadius = const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  );
                } else if (index == data.preciosHora.length - 1) {
                  borderRadius = const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  );
                }

                return Container(
                  clipBehavior: Clip.hardEdge,
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    /* border: Border(
                      bottom: const BorderSide(width: 0.8, color: Colors.grey),
                      left: BorderSide(width: 10.0, color: _colorPeriodo),
                    ), */
                    gradient: LinearGradient(
                      stops: const [0.04, 0.02], //const [0.02, 0.02],
                      colors: [colorPeriodo, color],
                    ),
                    borderRadius: borderRadius,
                    color: color,
                  ),
                  child: ListTile(
                    leading: page == 2
                        ? Tarifa.getIconCara(precios, precios[index])
                        : Text(
                            '${index + 1}',
                            style: TextStyle(color: backgroundColor),
                          ),
                    title: page == 2
                        ? Text(
                            '${(precios[index]).toStringAsFixed(5)} €/kWh',
                            style: TextStyle(
                              color: backgroundColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            '${indice}h - ${indice + 1}h',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                    subtitle: page == 2
                        ? Text(
                            '${index}h - ${index + 1}h',
                            style: TextStyle(
                              color: backgroundColor,
                            ),
                          )
                        : Text(
                            '${precios[index].toStringAsFixed(5)} €/kWh',
                            style: TextStyle(color: backgroundColor),
                          ),
                    trailing: Column(
                      children: [
                        Flexible(
                          child: Icon(
                            desviacion > 0 ? Icons.upload : Icons.download,
                            //size: 45,
                            color: desviacion > 0 ? Colors.red : Colors.green,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '${desviacion.toStringAsFixed(4)} €',
                            style: TextStyle(
                              fontSize: 12,
                              color: backgroundColor,
                            ),
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
