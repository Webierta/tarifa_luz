import 'package:flutter/material.dart';

class IconografiaScreen extends StatelessWidget {
  const IconografiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Divider divider = Divider(
      height: 0.1,
      color: Theme.of(context).colorScheme.background.withOpacity(0.2),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iconografía'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Periodos horarios:',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    Card(
                      elevation: 4.0,
                      color: Colors.blue[50],
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const ContainerPeriodo(
                            texto: 'Periodo Punta',
                            color: Color(0xFFe57373),
                            icono: Icons.trending_up,
                            colorIcono: Colors.red,
                          ),
                          divider,
                          const ContainerPeriodo(
                            texto: 'Periodo Llano',
                            color: Colors.amberAccent,
                            icono: Icons.trending_neutral,
                            colorIcono: Colors.amber,
                          ),
                          divider,
                          const ContainerPeriodo(
                            texto: 'Periodo Valle',
                            color: Color(0xFF81C784),
                            icono: Icons.trending_down,
                            colorIcono: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Diferencia respecto al precio medio del día:',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    Card(
                      elevation: 4.0,
                      color: Colors.blue[50],
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(
                              Icons.download,
                              color: Colors.green,
                            ),
                            title: Text(
                              'Inferior',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.upload,
                              color: Colors.red,
                            ),
                            title: Text(
                              'Superior',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Rangos de horas:',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    Card(
                      elevation: 4.0,
                      color: Colors.blue[50],
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.sentiment_very_satisfied,
                              size: 30,
                              color: Colors.green[700],
                            ),
                            title: Text(
                              '8 horas más baratas',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.sentiment_neutral,
                              size: 30,
                              color: Colors.amber[700],
                            ),
                            title: Text(
                              '8 horas intermedias',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.sentiment_very_dissatisfied,
                              size: 30,
                              color: Colors.deepOrange[700],
                            ),
                            title: Text(
                              '8 horas más caras',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Rangos de precios (€/kWh):',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    Card(
                      elevation: 4.0,
                      color: Colors.blue[50],
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 60,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                ),
                                color: const Color(0xFFDCEDC8),
                                //Colors.lightGreen[100]
                                child: const Text(
                                  '< 0,10',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 60,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 4,
                                ),
                                color: const Color(0xFFFFFDE7),
                                // Colors.yellow[50]
                                child: const FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    'Intermedio',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 60,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                color: const Color(0xFFFFCDD2),
                                // Colors.red[100],
                                child: const Text(
                                  '> 0,15',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerPeriodo extends StatelessWidget {
  final String texto;
  final Color color;
  final IconData icono;
  final Color colorIcono;

  const ContainerPeriodo({
    super.key,
    required this.texto,
    required this.color,
    required this.icono,
    required this.colorIcono,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = const BorderRadius.all(Radius.zero);
    if (colorIcono == Colors.red) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      );
    } else if (colorIcono == Colors.green) {
      borderRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 40),
      height: 45,
      decoration: BoxDecoration(
        // border: Border(
        //   bottom: const BorderSide(width: 0.8, color: Colors.grey),
        //   left: BorderSide(width: 10.0, color: color),
        // ),
        gradient: LinearGradient(
          stops: const [0.04, 0.02],
          colors: [color, const Color(0xFFE3F2FD)],
        ),
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(texto),
            const SizedBox(width: 10),
            Icon(icono, color: colorIcono, size: 40),
          ],
        ),
      ),
    );
  }
}
