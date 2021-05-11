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

final client = MockClient();
final ApiConnector api = ApiConnector(client);

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
void clear() {
  api.dataBox.clear();
  api.plantBox.clear();
  api.settingsBox.clear();
}

@GenerateMocks([http.Client])
void main() async {
  Directory dir = await getApplicationDocumentsDirectory();
  //Datenbank laden
  Hive
    ..init(dir.path)
    ..registerAdapter(PlantAdapter())
    ..registerAdapter(PlantDataAdapter());

  // create apiConnector and init Boxes
  api.dataBox = await Hive.openBox('plantData');
  api.plantBox = await Hive.openBox('plants');
  api.settingsBox = await Hive.openBox('settings');

  var baseUrl = 'https://api.kie.one/api/';
  group('getData', () {
    var uri = baseUrl +
        "Plants?access_token=" +
        api.settingsBox.get('token') +
        "&filter[order]=date%20DESC&filter[limit]=20";

    test('getData successful', () async {
      print("Test: getData, working");

      var body =
          '{"espId": "espBlume3","soilMoisture": 26,"humidity": 41,"temperature": 24.4,"watertank": 36,"water": false,"measuringTime": "2021-03-05T13:43:46.000Z","id": "6042278d701e762c3a840970","plantsId": "5fcf98e9f106a01bbacc5a79","memberId": "5fbd47595421905a1a869a55"}';
      api.settingsBox.put('token', "TEST-TOKEN");
      // mock the api request
      when(client.get(Uri.parse(uri)))
          .thenAnswer((_) async => http.Response(body, 200));
      var data = await api.getData();
      expect(data, jsonDecode(body));
      clear();
    });
    test('getData with exception', () async {
      var body = 'error';
      api.settingsBox.put('token', "TEST-TOKEN");
      // mock the api request
      when(client.get(Uri.parse(uri)))
          .thenAnswer((_) async => http.Response(body, 401));
      var data = await api.getData();
      expect(data, "error");
      clear();
    });
  });

  group('getPlant', () {
    var uri = baseUrl + "Plants?access_token=" + api.settingsBox.get('token');
    test('getPlant successful', () async {
      print("Test: getPlant, working");
      var body =
          '{"plantName": "Pflanze 1","plantDate": "2020-12-08T08:02:32.084Z","espId": "espBlume4","soilMoisture": 45,"humidity": 30,"id": "5fcf34c5e4f580d626f63922","memberId": "5fbd47795421905a1a869a56"}';
      api.settingsBox.put('token', "TEST-TOKEN");
      // mock the api request
      when(client.get(Uri.parse(uri)))
          .thenAnswer((_) async => http.Response(body, 200));
      var data = await api.getPlant();
      expect(data, jsonDecode(body));
      clear();
    });
    test('getPlant with exception', () async {
      print("Test: getPlant, working");
      var body = 'error';
      api.settingsBox.put('token', "TEST-TOKEN");
      // mock the api request
      when(client.get(Uri.parse(uri)))
          .thenAnswer((_) async => http.Response(body, 401));
      var data = await api.getPlant();
      expect(data, "error");
      clear();
    });
  });

  group('patchPlant', () {
    var uri = baseUrl + "Plants?access_token=" + api.settingsBox.get('token');
    clear();
    test('patchPlant successful', () async {
      print("Test: patchPlant, working");
      var body =
          '"plantName": "TEST","espId": "espBlume3","id": "5fc76bf50b487e3b0415f56d","soilMoisture": 25.0,"memberId": "5fbd47595421905a1a869a55"';
      var response =
          '{"plantName": "TEST","plantDate": "2020-12-02T09:29:16.519Z","espId": "espBlume3","soilMoisture": 25,"humidity": 30,"id": "5fc76bf50b487e3b0415f56d","memberId": "5fbd47595421905a1a869a55"}';
      api.settingsBox.put('token', "TEST-TOKEN");
      // mock the api request
      when(client.patch(
          Uri.parse(
              baseUrl + "Plants?access_token=" + api.settingsBox.get('token')),
          body: {
            "plantName": "TEST",
            "espId": "espBlume3",
            "id": "5fc76bf50b487e3b0415f56d",
            "soilMoisture": "25.0",
            "memberId": "5fbd47595421905a1a869a55"
          })).thenAnswer((_) async => http.Response(response, 200));
      var data = await api.patchPlant("5fc76bf50b487e3b0415f56d", "espBlume3",
          "TEST", "room", 25.0, "plantPic", "5fbd47595421905a1a869a55");
      expect(data, jsonDecode(response));
      clear();
    });
    test('patchPlant with exception', () async {
      print("Test: patchPlant, error");
      var body = 'error';
      api.settingsBox.put('token', "TEST-TOKEN");
      // mock the api request
      when(client.get(Uri.parse(uri)))
          .thenAnswer((_) async => http.Response(body, 401));
      var data = await api.patchPlant("5fc76bf50b487e3b0415f56d", "espBlume3",
          "TEST", "room", 25.0, "plantPic", "5fbd47595421905a1a869a55");
      expect(data, "error");
      clear();
    });
  });

  group('getMembersData', () {
    var userId = "606600e9701e762c3a8418f0";
    var uri = baseUrl +
        "Members/" +
        userId +
        "?access_token=" +
        api.settingsBox.get('token');
    clear();
    test('getData successful', () async {
      print("Test: getMembersData, working");
      var response =
          '{"firstname": "Max","lastname": "Mustermann","memberPic": {},"realm": "string","username": "max123","email": "max@max.com","emailVerified": false,"id": "606600e9701e762c3a8418f0"}';
      // mock the api request
      when(client.get(Uri.parse(uri)))
          .thenAnswer((_) async => http.Response(response, 200));
      await api.getMembersData(userId);
      expect(api.settingsBox.get('firstName'), "Max");
      expect(api.settingsBox.get('lastName'), "Mustermann");
      clear();
    });
    test('getData with exception', () async {
      print("Test: getMembersData, error");
      var response = 'error';
      api.settingsBox.put('token', "TEST-TOKEN");
      // mock the api request
      when(client.get(Uri.parse(uri)))
          .thenAnswer((_) async => http.Response(response, 401));
      var data = await api.getMembersData(userId);
      expect(data, 1);
      clear();
    });
  });

  test('checkLoggedIn', () {
    print("Test: checkLoggedIn");
    api.settingsBox.put('token', null);
    expect(api.checkLoggedIn(), false);
    api.settingsBox.put('token', "test");
    expect(api.checkLoggedIn(), true);
    clear();
  });

  group('postLogin', () {
    //TODO: Fehler zugriff auf Hive DB
    var mail = "max@max.com";
    var pw = "max123";
    var uri = baseUrl + "Members/login";
    //var _body = "{\"email\": \"" + mail + "\",\"password\": \"" + pw + "\"}";
    clear();
    test('postLogin successful', () async {
      print("Test: postLogin, working");
      var response =
          '{"id": "6EhcD9NajNSSl4dHZyzLBVw8DT35cnERG7A3hCVc2IANzrYazrFfzABfZ1MR9qpY","ttl": 1209600,"created": "2021-05-10T17:35:49.490Z","userId": "606600e9701e762c3a8418f0"}';
      // mock the api request
      when(client.post(Uri.parse(uri), body: {"email": mail, "password": pw}))
          .thenAnswer((_) async => http.Response(response, 200));
      expect(await api.postLogin(mail, pw), 0);
      expect(api.settingsBox.get('token'),
          "6EhcD9NajNSSl4dHZyzLBVw8DT35cnERG7A3hCVc2IANzrYazrFfzABfZ1MR9qpY");
      expect(api.settingsBox.get('userId'), "606600e9701e762c3a8418f0");
      clear();
    });

    test('postLogin with exception', () async {
      print("Test: postLogin, error");
      var response = 'error';
      api.settingsBox.put('token', "TEST-TOKEN");
      // mock the api request
      when(client.post(Uri.parse(uri), body: {"email": mail, "password": pw}))
          .thenAnswer((_) async => http.Response(response, 401));
      expect(await api.postLogin(mail, pw), 1);
      clear();
    });
  });

  group('postLogout', () {
    var uri =
        baseUrl + "Members/logout?access_token=" + api.settingsBox.get('token');

    test('postLogout successful', () async {
      print("Test: postLogout, working");
      // mock the api request
      when(client.post(Uri.parse(uri)))
          .thenAnswer((_) async => http.Response("", 204));
      expect(await api.postLogout(), 0);
      expect(api.settingsBox.get('token'), null);
      clear();
    });

    test('postLogout with exception', () async {
      print("Test: postLogout, error");
      var response = 'error';
      var token = api.settingsBox.get('token');
      api.settingsBox.put('token', "TEST-TOKEN");
      // mock the api request
      when(client.post(Uri.parse(uri)))
          .thenAnswer((_) async => http.Response(response, 401));
      expect(await api.postLogout(), 1);
      expect(api.settingsBox.get('token'), token);
      clear();
    });
  });

  group('postCreateAccount', () {
    var uri = baseUrl + "Members";
    var firstName = "Reiner";
    var lastName = "Zufall";
    var username = "Reinerzufall";
    var mail = "r@zufall.de";
    var password = "passwort";
    var userId = "";

    test('postCreateAccount successful', () async {
      print("Test: postCreateAccount, working");
      // mock the api request
      when(client.post(Uri.parse(uri), body: {
        "firstname": firstName,
        "lastname": lastName,
        "username": username,
        "email": mail,
        "password": password
      })).thenAnswer((_) async => http.Response("", 204));
      expect(
          await api.postCreateAccount(
              firstName, lastName, username, mail, password),
          0);
      expect(api.settingsBox.get('token'), null);
      clear();
    });

    test('postLogout with exception', () async {
      print("Test: postLogout, error");
      var response = 'error';
      var token = api.settingsBox.get('token');
      api.settingsBox.put('token', "TEST-TOKEN");
      // mock the api request
      when(client.post(Uri.parse(uri), body: {
        "firstname": firstName,
        "lastname": lastName,
        "username": username,
        "email": mail,
        "password": password
      })).thenAnswer((_) async => http.Response(response, 401));
      expect(
          await api.postCreateAccount(
              firstName, lastName, username, mail, password),
          1);
      expect(api.settingsBox.get('token'), token);
      clear();
    });
  });
}
