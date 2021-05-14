import 'dart:convert';
import 'dart:js';
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:lazyplants/components/db_models.dart';
import 'package:lazyplants/main.dart';

class ApiConnector {
  static const baseUrl = 'https://api.kie.one/api/';
  initBox() async {
    dataBox = await Hive.openBox('plantData');
    plantBox = await Hive.openBox('plants');
    settingsBox = await Hive.openBox('settings');
  }

  void request() {}
}

/*
var a = new Member;
a.request(); //Standart request (get)
a.setRequest(new Post); // Umschalten auf Post
a.request(); //post
*/
abstract class ApiMember extends ApiConnector {
//Post Plant wird nicht verwendet
  String mail;
  String pw;
  String firstName;
  String lastName;
  String userName;
  String userId;
  ApiMember(String mail, String pw, String firstName, String lastName,
      String userName, String userId) {
    this.mail = mail;
    this.pw = pw;
    this.firstName = firstName;
    this.lastName = lastName;
    this.userName = userName;
    this.userId = userId;
  }
  ApiMember.getMember(this.userId) {
    this.userId = userId;
  }
  var uri = Uri.parse(ApiConnector.baseUrl + "Members");

  RequestVerhalten requestVerhalten = new GetRequest();
  void setRequest(RequestVerhalten requestVerhalten) {
    this.requestVerhalten = requestVerhalten;
  }

  Future loginRequest() {
    uri = Uri.parse(uri.toString() + "/login");
    var body = jsonDecode('{"email": $mail, "password": $pw}');
    return requestVerhalten.request(uri, body);
  }

  Future logoutRequest() {
    uri = Uri.parse(
        uri.toString() + "/logout?access_token=" + settingsBox.get('token'));
    var body = "";
    return requestVerhalten.request(uri, body);
  }

  Future request() {
    if (requestVerhalten is GetRequest) {
      uri = Uri.parse(uri.toString() +
          "/" +
          userId +
          "?access_token=" +
          settingsBox.get('token'));
    }
    var body = jsonDecode('''{
        "firstname": $firstName,
        "lastname": $lastName,
        "username": $username,
        "email": $mail,
        "password": $pw
      }''');
    return requestVerhalten.request(uri, body);
  }
}

abstract class ApiData extends ApiConnector {
  //Patch und Post wird nicht verwendet
  var uri = Uri.parse(ApiConnector.baseUrl +
      "Plants?access_token=" +
      settingsBox.get('token') +
      "&filter[order]=date%20DESC&filter[limit]=20");
  var body = "";
  RequestVerhalten requestVerhalten = new GetRequest();
  void setRequest(RequestVerhalten requestVerhalten) {
    this.requestVerhalten = requestVerhalten;
  }

  Future request() {
    return requestVerhalten.request(uri, body);
  }
}

abstract class ApiPlant extends ApiConnector {
  //Post Plant wird nicht verwendet
  final Plant plant;
  ApiPlant(this.plant);
  var uri = Uri.parse(
      ApiConnector.baseUrl + "Plants?access_token=" + settingsBox.get('token'));

  RequestVerhalten requestVerhalten = new GetRequest();
  void setRequest(RequestVerhalten requestVerhalten) {
    this.requestVerhalten = requestVerhalten;
  }

  Future request() {
    var body = jsonDecode(plant.toString());
    return requestVerhalten.request(uri, body);
  }
}

class RequestVerhalten {
  // ignore: missing_return
  request(Uri uri, var body) async {}
}

class GetRequest implements RequestVerhalten {
  @override
  request(Uri uri, var body) async {
    try {
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        print(await jsonDecode(response.body));
        return await jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // show login screen
        return "error";
      } else
        return "error";
    } catch (socketException) {
      print('No internet connection');
      return ('No internet connection');
    }
  }
}

class PostRequest implements RequestVerhalten {
  @override
  request(Uri uri, var body) async {
    try {
      var response = await client.post(uri, body: body);
      if (response.statusCode == 200) {
        print("ok");
        return await jsonDecode(response.body);
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
}

class PatchRequest implements RequestVerhalten {
  @override
  request(Uri uri, var body) async {
    try {
      var response = await client.patch(uri, body: body);
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
      return ('No internet connection');
    }
  }
}
