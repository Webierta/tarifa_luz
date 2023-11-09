import 'package:flutter/material.dart';

import 'package:tarifa_luz/theme/theme_app.dart';

class HeadTab extends StatelessWidget {
  final String fecha;
  final String titulo;
  const HeadTab({super.key, required this.fecha, required this.titulo});

  @override
  Widget build(BuildContext context) {
    final Color onBackgroundColor = ThemeApp(context).onBackgroundColor;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tarifa 2.0 TD',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: onBackgroundColor),
            ),
          ],
        ),
        Text(
          fecha,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: onBackgroundColor),
        ),
        Text(
          titulo,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: onBackgroundColor),
        ),
        //const Divider(thickness: 0.5, height: 20),
        const SizedBox(height: 20),
      ],
    );
  }
}
