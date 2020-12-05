import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class ApiConnector {
  var baseUrl = 'https://api.kie.one/api/';
  var token =
      "ZnH7XjCmYRFpp09fifE4B3eZl980ZNepC4ADOwTM4Qif30H2FHxT0HMtDAurRYBa";

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
      var response = await http.get(baseUrl +
          "PlantData?access_token=" +
          token +
          "&filter[order]=date%20DESC&filter[limit]=20");
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
      var response = await http.get(baseUrl + "Plants?access_token=" + token);
      if (response.statusCode == 200) {
        print("ok");
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

  patchPlant(plantId, espId, plantName, room, soilMoisture, plantPic, memberId) async {
    try {
      var response = await http.patch(baseUrl + "Plants?access_token=" + token,
          body: {"plantName": plantName, "espId": espId, "id": plantId, "soilMoisture": soilMoisture, "memberId": memberId});
      if (response.statusCode == 200) {
        print("ok");
        return await jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // show login screen
      } else {
        print(response.statusCode.toString());
        print('error');
        return "error";
      }
    } catch (SocketException) {
      print(SocketException.toString());
      print('No internet connection');
    }
  }

  postLogin(mail, password) async {}
  postLogout() {}
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
