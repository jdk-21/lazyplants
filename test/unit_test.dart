import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lazyplants/components/db_models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hive/hive.dart';

import 'package:lazyplants/components/api_connector.dart';
import 'package:path_provider/path_provider.dart';
import 'unit_test.mocks.dart';

class Plant {
  final String memberId;
  final String plantId;
  final String plantName;
  final DateTime plantdate;
  final String room;
  final double soilMoisture;
  final double humidity;
  final String espId;

  Plant(
      {this.memberId,
      this.plantId,
      this.plantName,
      this.plantdate,
      this.room,
      this.soilMoisture,
      this.humidity,
      @required this.espId});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
        memberId: json['memberId'],
        plantId: json['plantId'],
        plantName: json['plantName'],
        plantdate: json['plantdate'],
        room: json['room'],
        soilMoisture: json['soilMoisture'],
        humidity: json['humidity'],
        espId: json['espId']);
  }
}

class PlantData {
  final String espId;
  final String memberId;
  final String plantId;
  final double soilMoisture;
  final double humidity;
  final double temperature;
  final double watertank;
  final DateTime measuringTime;
  final bool water;

  PlantData(
      {@required this.espId,
      this.memberId,
      this.plantId,
      this.soilMoisture,
      this.humidity,
      this.temperature,
      this.watertank,
      @required this.measuringTime,
      this.water});

  factory PlantData.fromJson(Map<String, dynamic> json) {
    return PlantData(
        espId: json['espId'],
        memberId: json['memberId'],
        plantId: json['plantId'],
        soilMoisture: json['soilMoisture'],
        humidity: json['humidity'],
        temperature: json['temperature'],
        watertank: json['watertank'],
        measuringTime: json['measuringTime'],
        water: json['water']);
  }
}

Box dataBox;
Box plantBox;
Box settingsBox;

setUpAll() async {
  print("Setup All");
  Directory dir = await getApplicationDocumentsDirectory();
  //Datenbank laden
  Hive
    ..init(dir.path)
    ..registerAdapter(PlantAdapter())
    ..registerAdapter(PlantDataAdapter());

  await initBox();
  print("Init Box finish");
}

initBox() async {
  dataBox = await Hive.openBox('plantData');
  plantBox = await Hive.openBox('plants');
  settingsBox = await Hive.openBox('settings');
}

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  setUpAll();
  var baseUrl = 'https://api.kie.one/api/';

  group('get', () {
    test('getData', () async {
      print("Test: getData");
      final client = MockClient();
      final ApiConnector api = ApiConnector();
      var body =
          '{"espId": "espBlume3","soilMoisture": 26,"humidity": 41,"temperature": 24.4,"watertank": 36,"water": false,"measuringTime": "2021-03-05T13:43:46.000Z","id": "6042278d701e762c3a840970","plantsId": "5fcf98e9f106a01bbacc5a79","memberId": "5fbd47595421905a1a869a55"}';
      settingsBox.put('token', "TEST-TOKEN");
      when(client.get(Uri.https(
              'api.kie.one',
              "/api/PlantData?access_token=" +
                  settingsBox.get('token') +
                  "&filter[order]=date%20DESC&filter[limit]=20")))
          .thenAnswer((_) async {
        return http.Response(body, 200);
      });
      var data = await api.getData(client);
      expect(data, jsonDecode(body));
    });
  });
}
