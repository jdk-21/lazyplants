import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class ApiConnector {
  http.Client client;
  ApiConnector(http.Client client) {
    this.client = client;
  }

  var baseUrl = 'https://api.kie.one/api/';

  Box dataBox;
  Box plantBox;
  Box settingsBox;

  initBox() async {
    dataBox = await Hive.openBox('plantData');
    plantBox = await Hive.openBox('plants');
    settingsBox = await Hive.openBox('settings');
  }

  getExactPlantData(int limit, String espId) async {
    try {
      var response = await client.get(Uri.parse(baseUrl +
          "PlantData?access_token=" +
          settingsBox.get('token') +
          "&filter[order]=date%20DESC&filter[limit]=" +
          limit.toString() +
          "&filter[espId]=" +
          espId));
      if (response.statusCode == 200) {
        print(await jsonDecode(response.body));
        return await jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // show login screen
        return "error";
      } else
        return "error";
    } catch (socketException) {
      print(socketException);
      print('No internet connection');
    }
  }

  getPlant() async {
    try {
      var response = await client.get(Uri.parse(
          baseUrl + "Plants?access_token=" + settingsBox.get('token')));
      if (response.statusCode == 200) {
        print("got plants");
        return await jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // show login screen
        print(response.statusCode);
        return "error";
      } else
        print(response.statusCode);
      return "error";
    } catch (socketException) {
      print('No internet connection');
    }
  }

  patchPlant(
      plantId, espId, plantName, room, soilMoisture, plantPic, memberId) async {
    try {
      var response = await client.patch(
          Uri.parse(
              baseUrl + "Plants?access_token=" + settingsBox.get('token')),
          body: {
            "plantName": plantName,
            "espId": espId,
            "id": plantId,
            "soilMoisture": soilMoisture,
            "memberId": memberId
          });
      if (response.statusCode == 200) {
        print("ok");
        return await jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // show login screen
        return 401;
      } else {
        print(response.statusCode.toString());
        print('error');
        return 'error';
      }
    } catch (socketException) {
      print(socketException.toString());
      print('No internet connection');
    }
  }

  Future<int> getMembersData(String userId) async {
    try {
      var response = await client.get(Uri.parse(baseUrl +
          "Members/" +
          userId +
          "?access_token=" +
          settingsBox.get('token')));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        settingsBox.put('firstName', data['firstname']);
        settingsBox.put('lastName', data['lastname']);
        print("got Members data");
        return 0;
      } else if (response.statusCode == 401) {
        // show login screen
        print(response.statusCode);
        return 1;
      } else
        print(response.statusCode);
      return 1;
    } catch (socketException) {
      print('No internet connection');
      return 1;
    }
  }

  checkLoggedIn() {
    if (settingsBox.get("token") != null)
      return true;
    else
      return false;
  }

  Future<int> postLogin(mail, password) async {
    try {
      var response = await client.post(Uri.parse(baseUrl + "Members/login"),
          body: {"email": mail, "password": password});
      if (response.statusCode == 200) {
        print("ok");
        var data = await jsonDecode(response.body);
        settingsBox.put("token", data["id"]);
        settingsBox.put("userId", data['userId']);
        await getMembersData(data['userId']);
        return 0;
      } else {
        print(response.statusCode.toString());
        print('error');
        return 1;
      }
    } catch (socketException) {
      print(socketException.toString());
      print('No internet connection');
      return 1;
    }
  }

  Future<int> postLogout() async {
    try {
      var response = await client.post(Uri.parse(
          baseUrl + "Members/logout?access_token=" + settingsBox.get('token')));
      if (response.statusCode == 204) {
        settingsBox.delete('token');
        print("logged out");

        return 0;
      } else {
        print(response.statusCode.toString());
        print('error');
        return 1;
      }
    } catch (socketException) {
      print(socketException.toString());
      print('No internet connection');
      return 1;
    }
  }

  Future<int> postCreateAccount(String firstName, String lastName,
      String username, String mail, String password) async {
    try {
      var response = await client.post(Uri.parse(baseUrl + "Members"), body: {
        "firstname": firstName,
        "lastname": lastName,
        "username": username,
        "email": mail,
        "password": password
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        settingsBox.put('userId', data['id']);
        settingsBox.put('firstName', data['firstname']);
        settingsBox.put('lastName', data['lastname']);
        print("created Account");
        if (await postLogin(mail, password) != 0) return 4;
        return 0;
      } else if (response.statusCode == 422) {
        var data = jsonDecode(response.body);
        bool usernameExists;
        bool emailExists;
        try {
          emailExists = data['error']['details']['messages']['email'][0] ==
              "Email already exists";
        } catch (e) {
          emailExists = false;
        }
        try {
          usernameExists = data['error']['details']['messages']['username']
                  [0] ==
              "User already exists";
        } catch (e) {
          usernameExists = false;
        }
        if (emailExists && usernameExists)
          return 1;
        else if (emailExists)
          return 2;
        else if (usernameExists) return 3;
        return 0;
      } else {
        print(response.statusCode.toString());
        print('error');
        return 4;
      }
    } catch (socketException) {
      print(socketException.toString());
      print('No internet connection');
      return 4;
    }
  }

  cachePlant() {
    getPlant().then((data) {
      if (data == "error") {
        // TODO: display error message and retry
        print("error");
      } else {
        plantBox.clear().then((value) {
          for (var d in data) {
            plantBox.add(d);
          }
          print('cached');
        });
      }
    });
  }

  cachePlantData() {}

  readPlant() {
    Map plantMap;
    if (plantBox != null) {
      plantMap = plantBox.toMap();
      print(plantMap);
    }
    return plantMap;
  }

  plantCount() {
    return plantBox.length;
  }

  readPlantData() {}
}
