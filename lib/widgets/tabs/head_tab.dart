import 'package:flutter/material.dart';

class HeadTab extends StatelessWidget {
  final String fecha;
  final String titulo;
  const HeadTab({super.key, required this.fecha, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tarifa 2.0 TD',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        Text(
          fecha,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          titulo,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        //const Divider(thickness: 0.5, height: 20),
        const SizedBox(height: 20),
      ],
    );
  }
}
