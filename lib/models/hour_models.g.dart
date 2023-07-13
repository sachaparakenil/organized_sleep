// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hour_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HoursAdapter extends TypeAdapter<Hours> {
  @override
  final int typeId = 0;

  @override
  Hours read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Hours(
      hour: fields[1] as String,
      index: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Hours obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.hour);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HoursAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
