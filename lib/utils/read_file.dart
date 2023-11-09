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
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        );
      },
    );
  }
}
