// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DetailsModelAdapter extends TypeAdapter<DetailsModel> {
  @override
  final int typeId = 0;

  @override
  DetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DetailsModel(
      sleepAt: fields[0] as String,
      wakeAt: fields[1] as String,
      maxVoice: fields[2] as String,
      avgVoice: fields[3] as String,
      sniffing: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, DetailsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.sleepAt)
      ..writeByte(1)
      ..write(obj.wakeAt)
      ..writeByte(2)
      ..write(obj.maxVoice)
      ..writeByte(3)
      ..write(obj.avgVoice)
      ..writeByte(4)
      ..write(obj.sniffing);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
