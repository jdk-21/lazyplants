// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantAdapter extends TypeAdapter<Plant> {
  @override
  final int typeId = 0;

  @override
  Plant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Plant()
      ..plantId = fields[0] as String
      ..plantName = fields[1] as String
      ..espName = fields[2] as String
      ..plantDate = fields[3] as DateTime
      ..room = fields[4] as String
      ..soilMoisture = fields[5] as double
      ..humidity = fields[6] as double
      ..temperature = fields[7] as double;
  }

  @override
  void write(BinaryWriter writer, Plant obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.plantId)
      ..writeByte(1)
      ..write(obj.plantName)
      ..writeByte(2)
      ..write(obj.espName)
      ..writeByte(3)
      ..write(obj.plantDate)
      ..writeByte(4)
      ..write(obj.room)
      ..writeByte(5)
      ..write(obj.soilMoisture)
      ..writeByte(6)
      ..write(obj.humidity)
      ..writeByte(7)
      ..write(obj.temperature);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlantDataAdapter extends TypeAdapter<PlantData> {
  @override
  final int typeId = 1;

  @override
  PlantData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantData()
      ..espId = fields[0] as String
      ..memberId = fields[1] as String
      ..plantId = fields[2] as String
      ..soilMoisture = fields[3] as double
      ..humidity = fields[4] as double
      ..temperature = fields[5] as double
      ..watertank = fields[6] as double
      ..measuringTime = fields[7] as DateTime
      ..water = fields[8] as bool;
  }

  @override
  void write(BinaryWriter writer, PlantData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.espId)
      ..writeByte(1)
      ..write(obj.memberId)
      ..writeByte(2)
      ..write(obj.plantId)
      ..writeByte(3)
      ..write(obj.soilMoisture)
      ..writeByte(4)
      ..write(obj.humidity)
      ..writeByte(5)
      ..write(obj.temperature)
      ..writeByte(6)
      ..write(obj.watertank)
      ..writeByte(7)
      ..write(obj.measuringTime)
      ..writeByte(8)
      ..write(obj.water);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
