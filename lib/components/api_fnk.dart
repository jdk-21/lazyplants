import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:lazyplants/components/db_models.dart';
import 'package:lazyplants/main.dart';
import 'api_connector2.dart';

checkLoggedIn() {
  if (settingsBox.get("token") != null)
    return true;
  else
    return false;
}

cachePlant() {
  ApiPlantData apiPlantData = new ApiPlantData();
  apiPlantData.request().then((data) {
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
