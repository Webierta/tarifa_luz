import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tarifa_luz/database/box_data.dart';
import 'package:tarifa_luz/utils/constantes.dart';

class Storage {
  Box<BoxData> box = Hive.box<BoxData>(boxStore);

  void saveBoxData(BoxData boxData) {
    final String fechaKey = DateFormat('yyyy-MM-dd').format(boxData.fecha);
    box.put(fechaKey, boxData);
  }

  BoxData? getBoxData(DateTime fecha) {
    final String fechaKey = DateFormat('yyyy-MM-dd').format(fecha);
    return box.get(fechaKey);
  }

  List<BoxData> get listBoxData => List.of(box.values.toList());

  List<BoxData> get listBoxDataSort {
    List<BoxData> listBoxDataSorted = List.of(box.values.toList());
    if (listBoxDataSorted.isNotEmpty) {
      listBoxDataSorted.sort(
        (a, b) => (b.fecha).compareTo(a.fecha),
      );
    }
    return listBoxDataSorted;
  }

  bool fechaInBoxData(DateTime fecha) {
    final String fechaKey = DateFormat('yyyy-MM-dd').format(fecha);
    return box.containsKey(fechaKey);
  }

  DateTime get lastFecha {
    List<BoxData> listBoxDataSort = List.of(box.values.toList());
    listBoxDataSort.sort((a, b) => b.fecha.compareTo(a.fecha));
    return listBoxDataSort.first.fecha;
  }

  void deleteBoxData(BoxData boxData) {
    final String fechaKey = DateFormat('yyyy-MM-dd').format(boxData.fecha);
    box.delete(fechaKey);
  }

  void deleteFirst() {
    if (box.values.isNotEmpty) {
      box.deleteAt(0);
    }
  }

  void clearBox() {
    box.values.toList().clear(); // ??
    box.clear();
  }
}
