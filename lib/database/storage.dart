import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:tarifa_luz/database/database.dart';
import 'package:tarifa_luz/models/datos.dart';
import 'package:tarifa_luz/models/datos_generacion.dart';
import 'package:tarifa_luz/utils/constantes.dart';
import 'package:tarifa_luz/utils/estados.dart';

class Storage {
  Box<Database> boxData = Hive.box<Database>(boxPVPC);

  String get lastDate {
    List<Database> listDataBase = List.of(boxData.values.toList());
    listDataBase.sort(
      (a, b) => DateFormat("dd/MM/yyyy")
          .parse(b.fecha)
          .compareTo(DateFormat("dd/MM/yyyy").parse(a.fecha)),
    );
    return listDataBase.first.fecha;
  }

  List<Database> get sortByDate {
    List<Database> listDataBase = List.of(boxData.values.toList());
    if (listDataBase.isNotEmpty) {
      listDataBase.sort(
        (a, b) => DateFormat("dd/MM/yyyy")
            .parse(b.fecha)
            .compareTo(DateFormat("dd/MM/yyyy").parse(a.fecha)),
      );
    }
    return listDataBase;
  }

  void saveDataBase(
      {required String fecha,
      required Datos data,
      DatosGeneracion? datosGeneracion}) {
    var consulta = Database(fecha: fecha, preciosHora: data.preciosHora)
      ..mapRenovables = datosGeneracion?.mapRenovables
      ..mapNoRenovables = datosGeneracion?.mapNoRenovables
      ..generacion = datosGeneracion?.generacion;
    boxData.put(fecha, consulta);
  }

  (String?, Datos?, DatosGeneracion?) getStorageByDate(String fecha) {
    String? boxFecha;
    if (boxData.isOpen && boxData.isNotEmpty && boxData.values.isNotEmpty) {
      boxFecha = boxData.values.last.fecha;
    }
    if (boxFecha != null) {
      Database? consulta = boxData.get(fecha);
      if (consulta != null) {
        var consultaDataBase = loadDataBase(consulta);
        return (consulta.fecha, consultaDataBase.$1, consultaDataBase.$2);
      } else {
        return (null, null, null);
      }
    } else {
      return (null, null, null);
    }
  }

  (Datos, DatosGeneracion) loadDataBase(Database consulta) {
    DateTime time = DateFormat('dd/MM/yyyy').parse(consulta.fecha);
    Datos datos = Datos();
    datos.fecha = DateFormat('yyyy-MM-dd').format(time);
    datos.preciosHora = List.from(consulta.preciosHora);
    datos.status = Status.ok;
    DatosGeneracion datosGeneracion = DatosGeneracion();
    if (consulta.mapRenovables != null &&
        consulta.mapNoRenovables != null &&
        consulta.generacion != null) {
      datosGeneracion.mapRenovables = consulta.mapRenovables!;
      datosGeneracion.mapNoRenovables = consulta.mapNoRenovables!;
      datosGeneracion.generacion = consulta.generacion!;
      datosGeneracion.status = StatusGeneracion.ok;
    }
    return (datos, datosGeneracion);
  }

  /* bool deleteDataBase() {
    if (boxData.isEmpty) {
      return false;
    }
    boxData.clear();
    return true;
  } */

  void deleteDataBase() {
    boxData.values.toList().clear(); // ??
    boxData.clear();
  }

  void deleteData(Database db) {
    boxData.delete(db.fecha);
  }

  void deleteByDate(String fecha) {
    List<Database> dataBase =
        boxData.values.toList().where((data) => data.fecha == fecha).toList();
    boxData.delete(dataBase.first);
  }

  bool dateInDataBase(String fecha) {
    return boxData.containsKey(fecha);
  }
}
