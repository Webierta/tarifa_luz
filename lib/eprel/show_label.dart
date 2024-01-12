import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/svg.dart';
import 'package:printing/printing.dart';

import 'package:tarifa_luz/eprel/api.dart';

class ShowLabel extends StatelessWidget {
  final Api api;
  const ShowLabel({required this.api, super.key});

  Future<Uint8List?> fetchPdfContent(final String url) async {
    try {
      http.Response response = await http.get(Uri.parse(url));
      return response.bodyBytes;
    } catch (e) {
      //return Uint8List(0);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: fetchPdfContent(api.label),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AspectRatio(
            aspectRatio: 0.5,
            child: PdfPreview(
              allowPrinting: true,
              allowSharing: true,
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              dpi: 200,
              build: (format) => snapshot.data!,
              onError: (context, error) {
                if (api.formatLabel == FormatLabel.png) {
                  return getLabelPng(api);
                } else if (api.formatLabel == FormatLabel.svg) {
                  return getLabelSvg(api);
                } else {
                  return const Text('Etiqueta no encontrada.');
                }
              },
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

Widget getLabelPng(Api api) {
  return AspectRatio(
    aspectRatio: 0.5, // 2144 / 4287,
    child: Image.network(
      api.label,
      errorBuilder: (context, exception, stackTrace) {
        return const Text('Etiqueta no encontrada.');
      },
    ),
  );
}

Widget getLabelSvg(Api api) {
  try {
    return AspectRatio(
      aspectRatio: 0.5, // 2144 / 4287,
      child: SvgPicture.network(
        api.label,
        semanticsLabel: 'Label',
        fit: BoxFit.fitWidth,
        //placeholderBuilder: (BuildContext context) =>
        //    const Text('Etiqueta no encontrada.'),
      ),
    );
  } catch (e) {
    return const Text('Etiqueta no encontrada.');
  }
}
