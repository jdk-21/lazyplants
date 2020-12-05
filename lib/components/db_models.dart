import 'dart:ui';
import 'package:hive/hive.dart';

part 'db_models.g.dart';

@HiveType(typeId: 0)
class Plant {

  @HiveField(0)
  String memberId;

  @HiveField(1)
  String plantId;

  @HiveField(2)
  String plantName;

  @HiveField(3)
  Image plantPic;

  @HiveField(4)
  DateTime plantDate;

  @HiveField(5)
  String room;

  @HiveField(6)
  double soilMoisture;

  @HiveField(7)
  double humidity;

  @HiveField(8)
  String espId;

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