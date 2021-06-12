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
  api.settingsBox.put('token', "testToken");

  var header = {
    "Accept": "application/json",
    "content-type": "application/json",
    "Authorization": "Bearer testToken"
  };

  group('GET', () {
    group('getExactPlantData', () {
      const int limit = 1;
      const String plantId = "espBlume3";
      var uri = Uri.parse(
          api.baseUrl + "dataplant/" + plantId + "/" + limit.toString());
      test('getexactPlantData successful', () async {
        print("Test: getData, working");
        print(uri);
        var response =
            '{"plantId": "espBlume3","soilMoisture": 26,"humidity": 41,"temperature": 24.4,"watertank": 36,"water": false,"measuringTime": "2021-03-05T13:43:46.000Z","id": "6042278d701e762c3a840970","plantsId": "5fcf98e9f106a01bbacc5a79","memberId": "5fbd47595421905a1a869a55"}';
        // mock the api request
        when(client.get(uri, headers: header))
            .thenAnswer((_) async => http.Response(response, 200));
        var data = await api.getExactPlantData(limit, plantId);
        expect(data, jsonDecode(response));
        //clear();
      });
      test('getExactPlantData with exception', () async {
        print("Test: getExactPlantData, error");
        var response = 'error';
        // mock the api request
        when(client.get(uri, headers: header))
            .thenAnswer((_) async => http.Response(response, 401));
        var data = await api.getExactPlantData(limit, plantId);
        expect(data, "401 error");
        //clear();
      });
    });

    group('getPlant', () {
      var uri = Uri.parse(api.baseUrl + "plant");
      test('getPlant successful', () async {
        print("Test: getPlant, working");
        var response =
            '{"plantName": "Pflanze 1","plantDate": "2020-12-08T08:02:32.084Z","espId": "espBlume4","soilMoisture": 45,"humidity": 30,"id": "5fcf34c5e4f580d626f63922","memberId": "5fbd47795421905a1a869a56"}';
        // mock the api request
        when(client.get(uri, headers: header))
            .thenAnswer((_) async => http.Response(response, 200));
        var data = await api.getPlant();
        expect(data, jsonDecode(response));
      });
      test('getPlant with exception', () async {
        print("Test: getPlant, error");
        var response = 'error';
        // mock the api request
        when(client.get(uri, headers: header))
            .thenAnswer((_) async => http.Response(response, 401));
        var data = await api.getPlant();
        expect(data, "error");
      });
    });

    group('getMembersData', () {
      var uri = Uri.parse(api.baseUrl + "user/me");
      test('getMembersData successful', () async {
        print("Test: getMembersData, working");
        var response = '{"firstName": "Max","lastName": "Mustermann"}';
        // mock the api request
        when(client.get(uri, headers: header))
            .thenAnswer((_) async => http.Response(response, 200));
        var data = await api.getMembersData();
        expect(data, 0);
        expect(api.settingsBox.get('firstName'), "Max");
        expect(api.settingsBox.get('lastName'), "Mustermann");
      });
      test('getMembersData with exception', () async {
        print("Test: getMembersData, error");
        var response = 'error';
        // mock the api request
        when(client.get(uri, headers: header))
            .thenAnswer((_) async => http.Response(response, 401));
        var data = await api.getMembersData();
        expect(data, 1);
      });

      test('getMembersData with other Statuscode', () async {
        print("Test: getMembersData, other Statuscode");
        var response = 'error';
        // mock the api request
        when(client.get(uri, headers: header))
            .thenAnswer((_) async => http.Response(response, 501));
        var data = await api.getMembersData();
        expect(data, 1);
      });
    });
  }); //GET

  group('PATCH', () {
    group('patchPlant', () {
      Plant plant = Plant();
      plant.plantId = "5fc76bf50b487e3b0415f56d";
      var uri = Uri.parse(api.baseUrl + "plant/" + plant.plantId);
      plant.espName = "espBlume3";
      plant.plantName = "TEST";
      plant.room = "t";
      plant.soilMoisture = 25.0;
      plant.humidity = 20.0;

      test('patchPlant successful', () async {
        print("Test: patchPlant, working");
        var response =
            '{"plantName": "${plant.plantName}","plantDate": "2020-12-02T09:29:16.519Z","espId": "${plant.espName}","soilMoisture": ${plant.soilMoisture},"humidity": ${plant.humidity},"id": "${plant.plantId}","memberId": "5fbd47595421905a1a869a55"}';
        // mock the api request
        when(client.patch(uri, headers: header, body: {
          "plantName": plant.plantName,
          "soilMoisture": plant.soilMoisture
        })).thenAnswer((_) async => http.Response(response, 204));
        var data = await api.patchPlant(plant);
        expect(data, 204);
      });

      test('patchPlant with exception', () async {
        print("Test: patchPlant, error");
        var response = 'error';
        // mock the api request
        when(client.patch(uri, headers: header, body: {
          "plantName": plant.plantName,
          "soilMoisture": plant.soilMoisture
        })).thenAnswer((_) async => http.Response(response, 401));
        var data = await api.patchPlant(plant);
        expect(data, 401);
      });

      test('patchPlant with other Statuscode', () async {
        print("Test: patchPlant, other Statuscode");
        var response = 'error';
        // mock the api request
        when(client.patch(uri, headers: header, body: {
          "plantName": plant.plantName,
          "soilMoisture": plant.soilMoisture
        })).thenAnswer((_) async => http.Response(response, 501));
        var data = await api.patchPlant(plant);
        expect(data, "error");
      });
    }); //patchPlant
  }); //PATCH

  /*group('POST', () {
    group('postLogin', () {
      var mail = "max@max.com";
      var pw = "max123";
      var uri = Uri.parse(api.baseUrl + "user/login");
      var token = "POST_TOKEN";
      var userId = "userId";
      var t = api.settingsBox.get('token');

      test('postLogin successful', () async {
        print("Test: postLogin, working");
        var response = '{"token": "' +
            token +
            '","ttl": 1209600,"created": "2021-05-10T17:35:49.490Z","userId": "' +
            userId +
            '"}';
        // mock the api request
        when(client.post(uri, headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": "Bearer testToken"
        }, body: '''{
          "email": "$mail",
          "password": "$pw"
        }'''))
            .thenAnswer((_) async => http.Response(response, 200));
        expect(await api.postLogin(mail, pw), 0);
        expect(api.settingsBox.get('token'), token);
        expect(api.settingsBox.get('userId'), userId);
        api.settingsBox.put('token', 'testToken');
      });

      test('postLogin with exception', () async {
        print("Test: postLogin, error");
        var response = 'error';
        // mock the api request
        when(client.post(uri, body: {"email": mail, "password": pw}))
            .thenAnswer((_) async => http.Response(response, 401));
        expect(await api.postLogin(mail, pw), 1);
        expect(api.settingsBox.get('token'), t);
      });
    }); //postLogin

    group('postCreateAccount', () {
      var uri = Uri.parse(api.baseUrl + "user/signup");
      var uriLogin = Uri.parse(api.baseUrl + "user/login");
      var firstName = "Reiner";
      var lastName = "Zufall";
      var username = "Reinerzufall";
      var mail = "r@zufall.de";
      var password = "passwort";
      var userId = "id";
      var token = api.settingsBox.get('token');
      var responseSuccsess = '{"firstname": "' +
          firstName +
          '","lastname": "' +
          lastName +
          '","username": "' +
          username +
          '","email": "' +
          mail +
          '","id": "' +
          userId +
          '"}';
      var responseLogin = '{"id": "' +
          token +
          '","ttl": 1209600,"created": "2021-05-10T17:35:49.490Z","userId": "' +
          userId +
          '"}';
      test('postCreateAccount successful', () async {
        print("Test: postCreateAccount, working");
        print(uri);
        var body = '{"email":"$mail","password":"$password","firstName":"$firstName","lastName":"$lastName"}';
        print(body);
        // mock the api request
        when(client.post(uri,
                headers: {
                  "Accept": "application/json",
                  "content-type": "application/json",
                  "Authorization": "Bearer testToken"
                },
                body: body))
            .thenAnswer((_) async => http.Response(responseSuccsess, 200));
        when(client.post(uriLogin,
                body: {"email": mail, "password": password}, headers: header))
            .thenAnswer((_) async => http.Response(responseLogin, 200));
        expect(await api.postCreateAccount(firstName, lastName, mail, password),
            0);
        expect(api.settingsBox.get('userId'), userId);
        expect(api.settingsBox.get('firstName'), firstName);
        expect(api.settingsBox.get('lastName'), lastName);
        expect(api.settingsBox.get('token'), token);
        expect(api.settingsBox.get('userId'), userId);
      });

      test('postCreateAccount with exist Account', () async {
        print("Test: postCreateAccount, exist Account");
        var response = 'error';
        var token = api.settingsBox.get('token');
        // mock the api request
        when(client.post(uri, body: {
          "firstName": firstName,
          "lastName": lastName,
          "email": mail,
          "password": password
        })).thenAnswer((_) async => http.Response(responseSuccsess, 200));

        when(client.post(uriLogin, body: {"email": mail, "password": password}))
            .thenAnswer((_) async => http.Response(response, 401));
        expect(await api.postCreateAccount(firstName, lastName, mail, password),
            4);
        expect(api.settingsBox.get('token'), token);
        expect(api.settingsBox.get('userId'), userId);
        expect(api.settingsBox.get('firstName'), firstName);
        expect(api.settingsBox.get('lastName'), lastName);
      });

      test('postCreateAccount with exist Email', () async {
        print("Test: postCreateAccount, error");
        var response = '{"error":' +
            '{"details":' +
            '{"messages":' +
            '{"email":[' +
            '"Email already exists"]}}}}';
        print(response);
        // mock the api request
        when(client.post(uri, body: {
          "firstname": firstName,
          "lastname": lastName,
          "username": username,
          "email": mail,
          "password": password
        })).thenAnswer((_) async => http.Response(response, 422));
        expect(await api.postCreateAccount(firstName, lastName, mail, password),
            2);
      });

      test('postCreateAccount with exist Username', () async {
        print("Test: postCreateAccount, error");
        var response = '{"error":' +
            '{"details":' +
            '{"messages":' +
            '{"username":[' +
            '"User already exists"]}}}}'; // mock the api request
        when(client.post(uri, body: {
          "firstname": firstName,
          "lastname": lastName,
          "username": username,
          "email": mail,
          "password": password
        })).thenAnswer((_) async => http.Response(response, 422));
        expect(await api.postCreateAccount(firstName, lastName, mail, password),
            3);
      });
      test('postCreateAccount with exist Username & Email', () async {
        print("Test: postCreateAccount, error");
        var response = '{"error":' +
            '{"details":' +
            '{"messages":' +
            '{"username":["User already exists"],' +
            '"email":["Email already exists"]' +
            '}}}}'; // mock the api request
        when(client.post(uri, body: {
          "firstname": firstName,
          "lastname": lastName,
          "username": username,
          "email": mail,
          "password": password
        })).thenAnswer((_) async => http.Response(response, 422));
        expect(await api.postCreateAccount(firstName, lastName, mail, password),
            1);
      });
      test('postCreateAccount with exception', () async {
        print("Test: postCreateAccount, error");
        var response = "error";
        api.settingsBox.put('userId', null);
        api.settingsBox.put('firstName', null);
        api.settingsBox.put('lastName', null);
        // mock the api request
        when(client.post(uri, body: {
          "firstname": firstName,
          "lastname": lastName,
          "username": username,
          "email": mail,
          "password": password
        })).thenAnswer((_) async => http.Response(response, 501));
        expect(await api.postCreateAccount(firstName, lastName, mail, password),
            4);
        expect(api.settingsBox.get('userId'), null);
        expect(api.settingsBox.get('firstName'), null);
        expect(api.settingsBox.get('lastName'), null);
      });
    }); //postCreateAccount
  }); //POST

  test('checkLoggedIn', () {
    print("Test: checkLoggedIn");
    api.settingsBox.put('token', null);
    expect(api.checkLoggedIn(), false);
    api.settingsBox.put('token', "test");
    expect(api.checkLoggedIn(), true);
  });*/
} //main
