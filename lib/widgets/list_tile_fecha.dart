import 'package:flutter/material.dart';

import 'package:tarifa_luz/utils/estados.dart';
import 'package:tarifa_luz/models/tarifa.dart';

class ListTileFecha extends StatelessWidget {
  final Periodo periodo;
  final String hora;
  final String precio;
  final double desviacion;
  const ListTileFecha({
    super.key,
    required this.periodo,
    required this.hora,
    required this.precio,
    required this.desviacion,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        children: [
          Tarifa.getIconPeriodo(periodo),
          Text(
            periodo.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),
          ),
        ],
      ),
      title: Align(
        alignment: Alignment.topLeft,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            hora,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      ),
      subtitle: Text(
        '$precio €/kWh',
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Column(
        children: [
          Icon(
            desviacion > 0 ? Icons.upload : Icons.download,
            color: desviacion > 0 ? Colors.red : Colors.green,
          ),
          Text(
            '${desviacion.toStringAsFixed(4)} €',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
