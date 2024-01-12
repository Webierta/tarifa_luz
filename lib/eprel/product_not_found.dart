import 'package:flutter/material.dart';

import 'package:tarifa_luz/eprel/api.dart';

class ProductNotFound extends StatelessWidget {
  final Api api;
  final TextEditingController controllerModelo;
  final TextEditingController controllerModeloSuggested;

  const ProductNotFound({
    required this.api,
    required this.controllerModelo,
    required this.controllerModeloSuggested,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String title = 'Producto no encontrado.';
    if (api.formatLabel == FormatLabel.none) {
      title = 'Error en generación de etiqueta';
    }
    String subTitle = '';
    if (api.status == StatusEprel.networkError) {
      subTitle = 'Error de conexión.';
    }
    if (api.status == StatusEprel.error || api.status == StatusEprel.nullData) {
      subTitle = 'Error obteniendo los datos.';
    }
    if (api.status == StatusEprel.notFound) {
      subTitle = 'Parece que el producto no está registrado.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        Text(subTitle),
        const SizedBox(height: 10),
        if (api.productSimilares.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Algunas sugerencias: '),
              TextField(
                readOnly: true,
                controller: controllerModeloSuggested,
                decoration: InputDecoration(
                  filled: true,
                  suffixIcon: PopupMenuButton<String>(
                    icon: const Icon(Icons.expand_more),
                    //initialValue: api.productSimilares.first,
                    itemBuilder: (BuildContext context) {
                      return api.productSimilares
                          .map((String product) => PopupMenuItem<String>(
                                value: product,
                                child: Text(product),
                              ))
                          .toList();
                    },
                    onSelected: (product) {
                      controllerModelo.text = product;
                      controllerModeloSuggested.text = product;
                    },
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 10),
        const Text('El campo Modelo distingue mayúsculas y minúsculas.'),
        const SizedBox(height: 10),
        const Text(
          'Puedes obtener sugerencias de modelos parecidos si al menos introduces '
          'los tres primeros caracteres.',
        ),
      ],
    );
  }
}
