// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BoxDataAdapter extends TypeAdapter<BoxData> {
  @override
  final int typeId = 2;

  @override
  BoxData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoxData(
      fecha: fields[0] as DateTime,
      preciosHora: (fields[1] as List).cast<double>(),
      mapRenovables: (fields[2] as Map?)?.cast<String, double>(),
      mapNoRenovables: (fields[3] as Map?)?.cast<String, double>(),
    );
  }

  @override
  void write(BinaryWriter writer, BoxData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.fecha)
      ..writeByte(1)
      ..write(obj.preciosHora)
      ..writeByte(2)
      ..write(obj.mapRenovables)
      ..writeByte(3)
      ..write(obj.mapNoRenovables);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoxDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
