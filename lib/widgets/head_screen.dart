import 'package:flutter/material.dart';
import 'package:tarifa_luz/theme/style_app.dart';

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
                'Tarifa Luz',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: StyleApp.accentColor),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: const FittedBox(
              child: Text('Precio de la luz por horas'),
            ),
          ),
        ],
      ),
    );
  }
}
