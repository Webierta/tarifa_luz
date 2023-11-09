import 'package:flutter/material.dart';

class HeadScreen extends StatelessWidget {
  const HeadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: FittedBox(
              child: Text(
                'App PVPC',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: FittedBox(
              child: Text(
                'Precio de la luz por horas',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
