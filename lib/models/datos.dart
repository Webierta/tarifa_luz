import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

import 'package:tarifa_luz/models/datos_pvpc.dart';
import 'package:tarifa_luz/utils/estados.dart';

class Datos {
  String fecha = '';
  List<double> preciosHora = <double>[];
  Status status = Status.none;

  /* double roundDouble(double value, int places) {
    double mod = pow(10.0, places) as double; //.toDouble();
    return ((value * mod).round().toDouble() / mod);
  } */

  Future getPreciosHoras(String fecha) async {
    var url = 'https://api.esios.ree.es/archives/70/download_json?date=$fecha';
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token == 'token' || token == '' || token == null) {
      const char = 'abcdefghijklmnopqrstuvwxyz0123456789';
      Random rnd = Random();
      String randomString() => String.fromCharCodes(Iterable.generate(
          64, (_) => char.codeUnitAt(rnd.nextInt(char.length))));
      token = randomString();
    }

    Map<String, String> headers = {
      'Accept': 'application/json; application/vnd.esios-api-v1+json',
      'Host': 'api.esios.ree.es',
      'x-api-key': token,
      'Cookie': '',
    };

    try {
      var response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      if (response.body.contains('Access denied')) {
        status = Status.accessDenied;
      } else if (response.statusCode == 200) {
        Map<String, dynamic> objJson = jsonDecode(response.body);
        var datosJson = DatosJson.fromJson(objJson);
        List<String> listaPrecios = <String>[];
        for (var obj in datosJson.datosPVPC) {
          listaPrecios.add(obj.precio);
        }
        for (var precio in listaPrecios) {
          //var precioDouble = roundDouble((double.tryParse(precio.replaceAll(',', '.'))! / 1000), 5);
          var precioDouble =
              double.tryParse(precio.replaceAll(',', '.'))! / 1000;
          preciosHora.add(precioDouble);
        }
        // HORARIO DE VERANO: Adelanto de 1 Hora
        if (fecha == '2022-03-27' ||
            fecha == '2023-03-26' ||
            fecha == '2024-03-31' ||
            fecha == '2025-03-30' ||
            fecha == '2026-03-29') {
          preciosHora.insert(2, 0);
        }
        status = preciosHora.length == 24 ? Status.ok : Status.error;
      } else {
        status = Status.noAcceso;
      }
    } on TimeoutException catch (_) {
      status = Status.tiempoExcedido;
    } on SocketException {
      status = Status.noInternet;
    } on Error {
      status = Status.error;
    }
  }

  Future getPreciosHorasFile(String fecha) async {
    var url = 'https://api.esios.ree.es/archives/80/download?date=$fecha';
    HttpClientRequest? request;
    HttpClientResponse? response;
    String? responseBody;
    XmlDocument? objetoXml;
    String? strXml;
    try {
      HttpClient http = HttpClient();
      request = await http.getUrl(Uri.parse(url)); // Uri.tryParse(url)
      response = await request.close().timeout(const Duration(seconds: 10));
      responseBody = await response.transform(utf8.decoder).join();
      //objetoXml = parse(responseBody);
      objetoXml = XmlDocument.parse(responseBody);
      strXml = objetoXml.toString();

      var start = '<IdentificacionSeriesTemporales v="IST10"/>';
      const end = '</SeriesTemporales>';
      final startIndex = strXml.indexOf(start);
      final endIndex = strXml.indexOf(end, startIndex);
      var subXml = strXml.substring(startIndex, endIndex);

      List<double> listaPrecios = <double>[];
      for (var i = 1; i < 25; i++) {
        var inicio = '<Pos v="$i"/><Ctd v="';
        const termino = '"/></Intervalo>';
        final indice1 = subXml.indexOf(inicio);
        final indice2 = subXml.indexOf(termino, indice1);
        final double? subPrecio =
            double.tryParse(subXml.substring(indice1 + inicio.length, indice2));
        //preciosHoras.clear();
        if (subPrecio != null) {
          listaPrecios.add(subPrecio);
        }
      }
      preciosHora = List.from(listaPrecios);
      //status = Status.ok;
      status = preciosHora.length == 24 ? Status.ok : Status.error;
    } on TimeoutException {
      status = Status.tiempoExcedido;
    } on SocketException {
      status = Status.noInternet;
    } catch (e) {
      status = Status.error;
    } finally {
      request = null;
      response = null;
      responseBody = null;
      objetoXml = null;
      strXml = null;
    }
  }

  double calcularPrecioMedio(List<double> precios) {
    return precios.reduce((a, b) => a + b) / precios.length;
  }

  double precioMin(List<double> precios) {
    return precios.reduce((curr, next) => curr < next ? curr : next);
  }

  double precioMax(List<double> precios) {
    return precios.reduce((curr, next) => curr > next ? curr : next);
  }

  String getHora(List<double> precios, double precio) {
    int pos = precios.indexOf(precio);
    return '${pos}h - ${pos + 1}h';
  }

  int getHour(List<double> precios, double precio, [start = 0]) {
    return precios.indexOf(precio, start);
  }

  DateTime getDataTime(String fecha, int hora) {
    //var hora = getHour(precios, precio);
    var fechaString = '$fecha $hora';
    DateTime date = DateFormat('yyyy-MM-dd H').parse(fechaString);
    return date;
  }

  double getPrecio(List<double> precios, int hora) {
    return precios[hora];
  }

  Map<int, double> ordenarPrecios(List<double> listaPrecios) {
    /* if (listaPrecios.isEmpty) {
      return <int, double>{};
    } */

    Map<int, double> mapPrecios = listaPrecios.asMap();

    var sortedKeys = mapPrecios.keys.toList(growable: false)
      ..sort((k1, k2) => mapPrecios[k1]!.compareTo(mapPrecios[k2]!));
    /* Map<int, double> mapPreciosSorted = Map.fromIterable(
      sortedKeys,
      key: (k) => k,
      value: (k) => mapPrecios[k],
    ); */
    Map<int, double> mapPreciosSorted = {
      for (var k in sortedKeys) k: mapPrecios[k]!
    };
    return mapPreciosSorted;
  }
}
