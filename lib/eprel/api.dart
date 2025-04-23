import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'product_groups.dart';
import '../env/env.dart';

enum StatusEprel {
  stopped,
  starting,
  networkError,
  success,
  error,
  nullData,
  notFound,
}

enum FormatLabel { pdf, png, svg, none }

class Api {
  String marca;
  String modelo;
  String productGroups;
  Api({
    required this.marca,
    required this.modelo,
    required this.productGroups,
  });

  String eprelRegistrationNumber = '';
  int numberCavitiesHornos = 1;
  List<String> productSimilares = [];
  StatusEprel status = StatusEprel.stopped;
  String label = '';
  FormatLabel formatLabel = FormatLabel.pdf;
  static const String urlProduction = 'https://eprel.ec.europa.eu/api';

  Future<void> getEprelRegistrationNumber() async {
    if (Env.eprelToken.isEmpty) {
      status = StatusEprel.error;
      return;
    }
    String urlProductGroups = '/products/$productGroups';
    //String paginas = '_page=5';
    String limite = '_limit=100';
    String filterMarca = 'supplierOrTrademark=$marca';
    String filterModelo = 'modelIdentifier=$modelo';
    String oldProducts = 'includeOldProducts=true';
    final String url =
        '$urlProduction$urlProductGroups?$limite&$filterMarca&$filterModelo&$oldProducts';

    Map<String, String> headers = {
      //'Accept': 'application/json; application/vnd.esios-api-v1+json',
      //'Host': 'public-energy-label-acceptance.ec.europa.eu',
      //'Host': 'eprel.ec.europa.eu',
      'User-Agent': 'Mozilla/5.0',
      'x-api-key': Env.eprelToken,
      //'Cookie': '',
    };

    http.Response response;
    try {
      response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 6));
    } on TimeoutException catch (_) {
      status = StatusEprel.networkError;
      return;
    } on SocketException {
      status = StatusEprel.networkError;
      return;
    } on Error {
      status = StatusEprel.networkError;
      return;
    }

    if (response.statusCode != 200) {
      status = StatusEprel.networkError;
      return;
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> data = {};
      try {
        data = jsonDecode(response.body);
        var size = data['size'] as int;
        if (size == 0) {
          status = StatusEprel.nullData;
          return;
        }
        List hits = data['hits'];
        for (final hit in hits) {
          var modelFound = hit['modelIdentifier'] as String;
          if (productGroups == ProductGroups.ovens.name) {
            numberCavitiesHornos = hit['numberCavities'];
          }
          final decodedString = utf8.decode(modelFound.codeUnits);
          if (decodedString == modelo) {
            eprelRegistrationNumber = hit['eprelRegistrationNumber'];
          } else {
            status = StatusEprel.notFound;
            if (modelo.length > 2 &&
                modelo.startsWith(modelFound.substring(0, 2))) {
              final decodedString = utf8.decode(modelFound.codeUnits);
              productSimilares.add(decodedString);
            }
          }
        }
      } catch (e) {
        status = StatusEprel.error;
        return;
      }
    }
  }

  Future<void> getApi() async {
    await getEprelRegistrationNumber();
    if (eprelRegistrationNumber.isNotEmpty) {
      await buildLabel(eprelRegistrationNumber, productGroups);
      status = StatusEprel.success;
      return;
    }
    /*  else {
      status = Status.notFound;
    } */
  }

  Future<void> buildLabel(String eprelRN, String productGroups) async {
    String urlProduct = '/product/$eprelRN/labels';
    String noRedirect = 'noRedirect=true';
    //String format = 'format=${formatLabel.formato}'; // PDF / PNG / SVG
    String format = 'format=${formatLabel.name.toUpperCase()}';
    String url = '$urlProduction$urlProduct?$noRedirect&$format';

    if (productGroups == ProductGroups.ovens.name && numberCavitiesHornos > 1) {
      String instance = 'instance=1'; // ONLY FOR DOMESTIC OVENS
      url = '$url&$instance';
    }

    if (productGroups == ProductGroups.lightsources.name) {
      String bigColor = 'BIG_COLOR'; // ONLY FOR LIGHT SOURCES
      url = '$url&$bigColor';
    }

    Map<String, String> headers = {
      //'Accept': 'application/json; application/vnd.esios-api-v1+json',
      //'Host': 'public-energy-label-acceptance.ec.europa.eu',
      'User-Agent': 'Mozilla/5.0',
      //'x-api-key': token,
      //'Cookie': '',
    };

    http.Response response;
    try {
      response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 6));
    } on TimeoutException catch (_) {
      formatLabel = FormatLabel.none;
      return;
    } on SocketException {
      formatLabel = FormatLabel.none;
      return;
    } on Error {
      formatLabel = FormatLabel.none;
      return;
    }

    if (response.statusCode != 200) {
      if (formatLabel == FormatLabel.pdf) {
        formatLabel = FormatLabel.png;
        await buildLabel(eprelRN, productGroups);
      } else if (formatLabel == FormatLabel.png) {
        formatLabel = FormatLabel.svg;
        await buildLabel(eprelRN, productGroups);
      } else if (formatLabel == FormatLabel.svg) {
        formatLabel = FormatLabel.none;
      }
      return;
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> data = {};
      String address = '';
      try {
        data = jsonDecode(response.body);
        address = data['address'] as String;
      } catch (e) {
        if (formatLabel == FormatLabel.pdf) {
          formatLabel = FormatLabel.png;
          await buildLabel(eprelRN, productGroups);
        } else if (formatLabel == FormatLabel.png) {
          formatLabel = FormatLabel.svg;
          await buildLabel(eprelRN, productGroups);
        } else if (formatLabel == FormatLabel.svg) {
          formatLabel = FormatLabel.none;
          return;
        }
      }

      // {"address":"/label/Label_603418.svg"}
      if (address.isNotEmpty) {
        label = 'https://eprel.ec.europa.eu$address';
      } else {
        formatLabel = FormatLabel.none;
      }
    }
  }
}
