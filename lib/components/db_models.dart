import 'package:hive/hive.dart';

part 'db_models.g.dart';

@HiveType(typeId: 0)
class Plant {
  @HiveField(0)
  String plantId;

  @HiveField(1)
  String plantName;

  @HiveField(2)
  String espName;

  @HiveField(3)
  DateTime plantDate;

  @HiveField(4)
  String room;

  @HiveField(5)
  double soilMoisture;

  @HiveField(6)
  double humidity;

  @HiveField(7)
  double temperature;
}

@HiveType(typeId: 1)
class PlantData {
  @HiveField(0)
  String espId;

  @HiveField(1)
  String memberId;

  @HiveField(2)
  String plantId;

  @HiveField(3)
  double soilMoisture;

  @HiveField(4)
  double humidity;

  @HiveField(5)
  double temperature;

  @HiveField(6)
  double watertank;

  @HiveField(7)
  DateTime measuringTime;

  @HiveField(8)
  bool water;
}
