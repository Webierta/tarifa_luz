import 'package:flutter/material.dart';

import 'package:tarifa_luz/utils/estados.dart';

const TextStyle textBlanco = TextStyle(color: Colors.white);
const TextStyle textBlanco70 = TextStyle(color: Colors.white70);

class GeneracionError extends StatelessWidget {
  const GeneracionError({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(Generacion.renovable.tipo, style: textBlanco),
          trailing: const Text('N/D', style: textBlanco),
        ),
        ListTile(
          title: Text(Generacion.noRenovable.tipo, style: textBlanco),
          trailing: const Text('N/D', style: textBlanco),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text('Datos no disponibles', style: textBlanco70),
          ),
        ),
      ],
    );
  }
}
