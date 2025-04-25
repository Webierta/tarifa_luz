import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'box_data.g.dart';

@HiveType(typeId: 2)
class BoxData {
  @HiveField(0)
  final DateTime fecha;
  @HiveField(1)
  List<double> preciosHora;
  @HiveField(2)
  Map<String, double>? mapRenovables;
  @HiveField(3)
  Map<String, double>? mapNoRenovables;

  BoxData(
      {required this.fecha,
      required this.preciosHora,
      this.mapRenovables,
      this.mapNoRenovables});

  Map<String, double> get generacion => {
        ...?mapRenovables,
        ...?mapNoRenovables,
      };

  //List<double> get precios => preciosHora;

  double get precioMedio =>
      preciosHora.reduce((a, b) => a + b) / preciosHora.length;

  double get precioMin {
    if (preciosHora.isNotEmpty) {
      return preciosHora.reduce((curr, next) => curr < next ? curr : next);
    }
    return 0;
  }

  double get precioMax {
    return preciosHora.reduce((curr, next) => curr > next ? curr : next);
  }

  String get horaPrecioMin => getHora(preciosHora, precioMin);
  String get horaPrecioMax => getHora(preciosHora, precioMax);

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

  /* indexPrecio(double precio) {
    Map<int, double> mapPreciosOrdenados = ordenarPrecios(preciosHora);
    List<double> preciosOrdenados = mapPreciosOrdenados.values.toList();
    return preciosOrdenados.indexOf(precio) + 1;
  } */

  String get fechaddMMyy {
    return DateFormat('dd/MM/yy').format(fecha);
  }

  /*String get fechaDiaSemana {
    String diaSemana = DateFormat('EEEE').format(fecha);
    if (diaSemana.isEmpty) {
      return '';
    }
    return diaSemana[0].toUpperCase() + diaSemana.substring(1);
    //return DateFormat('EEE').format(fecha);
  }*/

  BoxData copyWith(
      {DateTime? fecha,
      List<double>? preciosHora,
      Map<String, double>? mapRenovables,
      Map<String, double>? mapNoRenovables}) {
    return BoxData(
      fecha: fecha ?? this.fecha,
      preciosHora: preciosHora ?? this.preciosHora,
      mapRenovables: mapRenovables ?? this.mapRenovables,
      mapNoRenovables: mapNoRenovables ?? this.mapNoRenovables,
    );
  }
}
