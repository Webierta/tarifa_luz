import 'package:flutter/material.dart';

class ReadFile extends StatelessWidget {
  final String archivo;
  const ReadFile({super.key, required this.archivo});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString(archivo),
      builder: (context, snapshot) {
        return Text(
          snapshot.data ?? 'Error: archivo no encontrado',
          softWrap: true,
          style: Theme.of(context).textTheme.bodyLarge,
        );
      },
    );
  }
}
