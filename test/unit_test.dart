import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lazyplants/components/db_models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hive/hive.dart';

import 'package:lazyplants/components/api_connector.dart';
import 'package:path_provider/path_provider.dart';
import 'unit_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() async {
  Directory dir = await getApplicationDocumentsDirectory();
  //Datenbank laden
  Hive
    ..init(dir.path)
    ..registerAdapter(PlantAdapter())
    ..registerAdapter(PlantDataAdapter());

  // create apiConnector and init Boxes
  final ApiConnector api = ApiConnector();
  api.dataBox = await Hive.openBox('plantData');
  api.plantBox = await Hive.openBox('plants');
  api.settingsBox = await Hive.openBox('settings');

  var baseUrl = 'https://api.kie.one/api/';

  group('getData', () {
    test('getData successful', () async {
      print("Test: getData, working");
      final client = MockClient();

      var body =
          '{"espId": "espBlume3","soilMoisture": 26,"humidity": 41,"temperature": 24.4,"watertank": 36,"water": false,"measuringTime": "2021-03-05T13:43:46.000Z","id": "6042278d701e762c3a840970","plantsId": "5fcf98e9f106a01bbacc5a79","memberId": "5fbd47595421905a1a869a55"}';
      api.settingsBox.put('token', "TEST-TOKEN");
      // mock the api request
      when(client.get(Uri.parse(baseUrl +
              "Plants?access_token=" +
              api.settingsBox.get('token') +
              "&filter[order]=date%20DESC&filter[limit]=20")))
          .thenAnswer((_) async => http.Response(body, 200));
      var data = await api.getData(client);
      expect(data, jsonDecode(body));
    });
    test('getData with exception', () async {
      final client = MockClient();

      var body = 'error';
      api.settingsBox.put('token', "TEST-TOKEN");
      // mock the api request
      when(client.get(Uri.parse(baseUrl +
              "Plants?access_token=" +
              api.settingsBox.get('token') +
              "&filter[order]=date%20DESC&filter[limit]=20")))
          .thenAnswer((_) async => http.Response(body, 401));
      var data = await api.getData(client);
      expect(data, "error");
    });
  });
}
