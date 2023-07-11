// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hour_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class hoursAdapter extends TypeAdapter<hours> {
  @override
  final int typeId = 0;

  @override
  hours read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return hours(
      hour: fields[1] as String,
      index: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, hours obj) {
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
      other is hoursAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
