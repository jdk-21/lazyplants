import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class ApiConnector {
  http.Client client;
  ApiConnector(http.Client client) {
    this.client = client;
  }

  var baseUrl = 'https://api.kie.one/';

  Box dataBox;
  Box plantBox;
  Box settingsBox;

  initBox() async {
    dataBox = await Hive.openBox('plantData');
    plantBox = await Hive.openBox('plants');
    settingsBox = await Hive.openBox('settings');
  }

  postRequest(String endpoint, String body) async {
    String bearer = "Bearer ";
    if (settingsBox.containsKey('token')) {
      bearer += settingsBox.get('token');
    }

    return await client.post(Uri.parse(baseUrl + endpoint),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": bearer
        },
        body: body);
  }

  getRequest(String endpoint) async {
    String bearer = "Bearer ";
    if (settingsBox.containsKey('token')) {
      bearer += settingsBox.get('token');
    }

    return await client.get(Uri.parse(baseUrl + endpoint), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": bearer
    });
  }

  patchRequest(String endpoint, String body) async {
    String bearer = "Bearer ";
    if (settingsBox.containsKey('token')) {
      bearer += settingsBox.get('token');
    }

    return await client.patch(Uri.parse(baseUrl + endpoint),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Authorization": bearer
        },
        body: body);
  }

  getExactPlantData(int limit, String plantId) async {
    try {
      var response =
          await getRequest("dataplant/" + plantId + "/" + limit.toString());
      if (response.statusCode == 200) {
        print(await jsonDecode(response.body));
        return await jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // show login screen
        return "${response.statusCode} error";
      } else
        return "${response.statusCode} error";
    } catch (socketException) {
      print(socketException);
      print('No internet connection');
    }
  }

  getPlant() async {
    try {
      var response = await getRequest("plant");
      if (response.statusCode == 200) {
        print("got plants");
        print(response.body);
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

  patchPlant(plant) async {
    try {
      var response = await patchRequest("plant/" + plant.plantId,
          '{ "plantName": "$plant.plantName", "soilMoisture": $plant.soilMoisture }');
      if (response.statusCode == 204) {
        print("ok");
        return 204;
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

  Future<int> getMembersData() async {
    try {
      var response = await getRequest("user/me");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        settingsBox.put('firstName', data['firstName']);
        settingsBox.put('lastName', data['lastName']);
        print("got Members data");
        return 0;
      } else if (response.statusCode == 401) {
        // show login screen
        print(response.statusCode);
        return 1;
      } else
        print(response.statusCode);
      print(response.body);
      return 1;
    } catch (socketException) {
      print(socketException);
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
      var response = await postRequest(
          "user/login", jsonEncode({"email": mail, "password": password}));
      if (response.statusCode == 200) {
        print("ok");
        var data = await jsonDecode(response.body);
        settingsBox.put("token", data["token"]);
        settingsBox.put("userId", data['userId']);
        await getMembersData();
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

  void logout() {
    settingsBox.delete('token');
    plantBox.clear();
    dataBox.clear();
  }

  Future<int> postCreateAccount(
      String firstName, String lastName, String mail, String password) async {
    try {
      print(jsonEncode({
        "email": mail,
        "password": password,
        "firstName": firstName,
        "lastName": lastName
      }));
      var response = await postRequest(
          "user/signup",
          jsonEncode({
            "email": mail,
            "password": password,
            "firstName": firstName,
            "lastName": lastName
          }));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        settingsBox.put('userId', data['userId']);
        settingsBox.put('firstName', data['firstName']);
        settingsBox.put('lastName', data['lastName']);
        print("created Account");
        if (await postLogin(mail, password) != 0) return 4;
        return 0;
      } else if (response.statusCode == 422) {
        var data = jsonDecode(response.body);
        bool passwordRequirements;
        bool emailExists;
        bool notAnEmail;
        notAnEmail = data['error']['message'] == "invalid email";
        emailExists = data['error']['message'].contains("ER_DUP_ENTRY");
        passwordRequirements =
            data['error']['message'] == "password must be minimum 8 characters";
        if (emailExists && passwordRequirements)
          return 1;
        else if (emailExists)
          return 2;
        else if (passwordRequirements)
          return 3;
        else if (notAnEmail) return 5;
        return 4;
      } else {
        print(response.statusCode.toString());
        print(response.body);
        print('error');
        return 4;
      }
    } catch (socketException) {
      print(socketException.toString());
      print('No internet connection');
      return 4;
    }
  }
}
