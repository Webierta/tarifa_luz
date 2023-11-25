import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:tarifa_luz/theme/style_app.dart';

class BonoSocial extends StatelessWidget {
  const BonoSocial({super.key});

  Future<void> launchURL(
      {required BuildContext context, required String url}) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not launch $url'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle headlineLarge = Theme.of(context)
        .textTheme
        .headlineLarge!
        .copyWith(fontWeight: FontWeight.w100);
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bono Social'),
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.info)),
              Tab(icon: Icon(Icons.verified_user)),
              Tab(icon: Icon(Icons.miscellaneous_services_outlined)),
              Tab(icon: Icon(Icons.add_circle)),
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              OverflowBox(
                maxWidth: 800,
                maxHeight: 800,
                child: Icon(
                  Icons.electrical_services,
                  size: 800,
                  color: Colors.black.withAlpha(150),
                ),
              ),
              Container(
                decoration: StyleApp.mainDecoration,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TabBarView(
                  //physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Text('¿Qué es?', style: headlineLarge),
                            const SizedBox(height: 20),
                            const BonoSocialDescription(),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Text('Requisitos', style: headlineLarge),
                            const SizedBox(height: 20),
                            const StepperBonoSocial(),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Cómo solicitarlo',
                                style: headlineLarge,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text('Enlaces externos:'),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () {
                                launchURL(
                                  context: context,
                                  url:
                                      'https://www.cnmc.es/bono-social#dirigir-solicitud',
                                );
                              },
                              icon: const Icon(Icons.contact_support),
                              label: const Text(
                                'Comercializadores de referencia',
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () {
                                launchURL(
                                  context: context,
                                  url:
                                      'https://www.cnmc.es/bono-social#que-documentacion',
                                );
                              },
                              icon: const Icon(Icons.description),
                              label: const Text('Documentación'),
                            ),
                            const SizedBox(height: 20),
                            const BonoSocialTramite(),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Enlaces de interés',
                                style: headlineLarge,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                launchURL(
                                  context: context,
                                  url: 'https://www.bonosocial.gob.es/',
                                );
                              },
                              child: const Text(
                                  'Bono social eléctrico. Página oficial'),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                launchURL(
                                  context: context,
                                  url: 'https://civio.es/bono-social/',
                                );
                              },
                              child: const Text('Fundación Civio'),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                launchURL(
                                  context: context,
                                  url: 'https://www.cnmc.es/bono-social',
                                );
                              },
                              child: const Text(
                                  'Comisión Nacional de los Mercados y la Competencia'),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                launchURL(
                                  context: context,
                                  url:
                                      'https://www.boe.es/eli/es/rd/2017/10/06/897/con',
                                );
                              },
                              child: const Text(
                                  'Real Decreto 897/2017 de 6 de octubre'),
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

class BonoSocialDescription extends StatelessWidget {
  const BonoSocialDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'El Bono Social es un mecanismo de protección social que reconoce el derecho a un descuento '
          'en la factura eléctrica (Real Decreto 897/2017 de 6 de octubre), con el fin de proteger '
          'a determinados colectivos de consumidores económica o socialmente más vulnerables.',
        ),
        SizedBox(height: 20),
        Text(
          'El descuento del Bono Social se aplica sobre el PVPC (precio voluntario para el pequeño '
          'consumidor) tanto sobre el término de energía como de potencia, aunque en el término de '
          'energía existe un límite máximo anual con derecho a descuento.',
        ),
        SizedBox(height: 20),
        Text(
          'El descuento aplicable al consumidor vulnerable es del 25% sobre el PVPC. En el caso '
          'de reunir las condiciones de consumidor vulnerable severo, el descuento será del 40%.',
        ),
      ],
    );
  }
}

class BonoSocialTramite extends StatelessWidget {
  const BonoSocialTramite({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Desde la recepción de la solicitud junto con la documentación completa, '
          'el comercializador dispone de 10 días hábiles para comunicar una respuesta. '
          'Además, en caso de denegación, debe indicar los motivos de la misma.',
        ),
        SizedBox(height: 20),
        Text(
          'El bono social se devengará a partir del primer día del ciclo de facturación en el que '
          'tenga lugar la recepción de la solicitud completa y se aplicará en la primera factura '
          'recibida tras la solicitud, siempre y cuando haya sido emitida al menos a los 15 días '
          'hábiles de la recepción de dicha solicitud. En caso contrario, la aplicación empezará '
          'en la factura inmediatamente posterior.',
        ),
        SizedBox(height: 20),
        Text(
          'El bono social solicitado se aplicará durante el plazo de dos años, siempre que con '
          'anterioridad no se produzca la pérdida de alguna de las condiciones que dan derechos a su percepción.',
        ),
        SizedBox(height: 20),
        Text(
          'En términos generales, si se siguen cumpliendo los requisitos que dieron derecho a la '
          'percepción del bono social, su renovación es automática cada dos años de forma '
          'indefinida (excepto en el caso de familias numerosas).',
        ),
      ],
    );
  }
}

class StepperBonoSocial extends StatefulWidget {
  const StepperBonoSocial({super.key});
  @override
  State<StepperBonoSocial> createState() => _StepperBonoSocialState();
}

class _StepperBonoSocialState extends State<StepperBonoSocial> {
  int _index = 0;

  static const List<String> requisitos = [
    'Bajo nivel de Renta.',
    'Familia numerosa o monoparental.',
    'Pensionistas.',
    'Beneficiario del Ingreso Mínimo Vital.',
    'Discapacidad igual o superior al 33%.',
    'Víctima de terrorismo o violencia de género.',
    'Dependencia grado II o III.',
  ];

  @override
  Widget build(BuildContext context) {
    return Stepper(
      physics: const ClampingScrollPhysics(),
      controlsBuilder: (BuildContext context, ControlsDetails controls) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: <Widget>[
              if (_index != 4)
                ElevatedButton(
                  onPressed: controls.onStepContinue,
                  child: const Text('Siguiente'),
                ),
              if (_index == 4)
                ElevatedButton(
                  onPressed: controls.onStepContinue,
                  child: const Text('Inicio'),
                ),
              if (_index != 0)
                TextButton(
                  onPressed: controls.onStepCancel,
                  child: const Text(
                    'Atrás',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        );
      },
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() => _index -= 1);
        }
      },
      onStepContinue: () {
        if (_index <= 3) {
          setState(() => _index += 1);
        } else if (_index == 4) {
          setState(() => _index = 0);
        }
      },
      onStepTapped: (int index) {
        setState(() => _index = index);
      },
      steps: <Step>[
        const Step(
          title: Text('Que el titular sea persona física'),
          content: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'El Bono Social está destinado a particulares y no a empresas.',
            ),
          ),
        ),
        const Step(
          title: Text('Vivienda habitual'),
          content: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'El Punto de Suministro para el que se solicita la aplicación del '
              'Bono Social debe ser el de la vivienda habitual.',
            ),
          ),
        ),
        const Step(
          title: Text('Mercado regulado: PVPC'),
          content: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tener contratada la tarifa regulada del precio voluntario para el '
              'pequeño consumidor (PVPC) a través de una comercializadora de referencia.',
            ),
          ),
        ),
        const Step(
          title: Text('Potencia'),
          content: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'La potencia contratada del punto de suministro debe ser igual o inferior a 10 kW.',
            ),
          ),
        ),
        Step(
          title: const Text('Consumidor vulnerable'),
          subtitle: const Text(
            'Cumplir los requisitos personales, familiares y de renta establecidos '
            'para ser considerado consumidor vulnerable:',
          ),
          content: Column(
            children: [
              for (String requisito in requisitos)
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  leading: const Icon(Icons.done),
                  title: Text(requisito),
                )
            ],
          ),
        ),
      ],
    );
  }
}
