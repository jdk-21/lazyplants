import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class ApiConnector {
  var baseUrl = 'https://api.kie.one/api/';

  Box dataBox;
  Box plantBox;
  Box settingsBox;

  initBox() async {
    dataBox = await Hive.openBox('plantData');
    plantBox = await Hive.openBox('plants');
    settingsBox = await Hive.openBox('settings');
  }

  getData() async {
    try {
      var response = await http.get(Uri.parse(baseUrl +
          "PlantData?access_token=" +
          settingsBox.get('token') +
          "&filter[order]=date%20DESC&filter[limit]=20"));
      if (response.statusCode == 200) {
        print(await jsonDecode(response.body));
        return await jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // show login screen
        return "error";
      } else
        return "error";
    } catch (SocketException) {
      print('No internet connection');
    }
  }

  getPlant() async {
    try {
      var response = await http.get(Uri.parse(
          baseUrl + "Plants?access_token=" + settingsBox.get('token')));
      if (response.statusCode == 200) {
        print("ok");
        return await jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // show login screen
        print(response.statusCode);
        return "error";
      } else
        print(response.statusCode);
      return "error";
    } catch (SocketException) {
      print('No internet connection');
    }
  }

  patchPlant(
      plantId, espId, plantName, room, soilMoisture, plantPic, memberId) async {
    try {
      var response = await http.patch(
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
    } catch (SocketException) {
      print(SocketException.toString());
      print('No internet connection');
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
      var response = await http.post(Uri.parse(baseUrl + "Members/login"),
          body: {"email": mail, "password": password});
      if (response.statusCode == 200) {
        print("ok");
        var data = await jsonDecode(response.body);
        settingsBox.put("token", data["id"]);
        return 0;
      } else {
        print(response.statusCode.toString());
        print('error');
        return 1;
      }
    } catch (SocketException) {
      print(SocketException.toString());
      print('No internet connection');
      return 1;
    }
  }

  Future<int> postLogout() async {
    try {
      var response = await http.post(Uri.parse(
          baseUrl + "Members/logout?access_token" + settingsBox.get('token')));
      if (response.statusCode == 204) {
        settingsBox.delete('token');
        print("logged out");

        return 0;
      } else {
        print(response.statusCode.toString());
        print('error');
        return 1;
      }
    } catch (SocketException) {
      print(SocketException.toString());
      print('No internet connection');
      return 1;
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
    Map plantMap = plantBox.toMap();
    print(plantMap);
    return plantMap;
  }

  plantCount() {
    return plantBox.length;
  }

  readPlantData() {}
}
