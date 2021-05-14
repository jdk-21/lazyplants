import 'dart:convert';
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
a.login.request
*/
class ApiMember extends ApiConnector {
//Post Plant wird nicht verwendet
  String mail;
  String pw;
  String firstName;
  String lastName;
  String userName;
  String userId;
  ApiMember();
  ApiMember.createAccount(String mail, String pw, String firstName,
      String lastName, String userName) {
    this.mail = mail;
    this.pw = pw;
    this.firstName = firstName;
    this.lastName = lastName;
    this.userName = userName;
  }
  ApiMember.memberData(this.userId) {
    this.userId = userId;
  }
  ApiMember.login(this.mail, this.pw) {
    this.mail = mail;
    this.pw = pw;
  }
  ApiMember.logout();

  var uri = Uri.parse(ApiConnector.baseUrl + "Members");

  RequestVerhalten requestVerhalten = new GetRequest();
  void setRequest(RequestVerhalten requestVerhalten) {
    this.requestVerhalten = requestVerhalten;
  }

  Future request() async {}
}

class Login extends ApiMember {
  Login(String mail, String pw) : super.login(mail, pw);
  Future request() async {
    var uri = Uri.parse(ApiConnector.baseUrl + "Members/login");
    RequestVerhalten rv = requestVerhalten;
    var body = jsonDecode('{"email": $mail, "password": $pw}');
    var response = requestVerhalten.request(uri, body);
    if (response.statusCode == 200) {
      print("ok");
      var data = await jsonDecode(response.body);
      settingsBox.put("token", data["id"]);
      settingsBox.put("userId", data['userId']);
      userId = data['userId'];
      setRequest(GetRequest());
      await request(); //first- and lastName to DB
      setRequest(rv);
      return 0;
    } else {
      print('error: ' + response.statusCode.toString());
      return 1;
    }
  }
}

class Logout extends ApiMember {
  Logout() : super.logout();
  Future request() async {
    uri = Uri.parse(
        uri.toString() + "/logout?access_token=" + settingsBox.get('token'));
    var body = "";
    var response = requestVerhalten.request(uri, body);
    try {
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
}

class CrateAccount extends ApiMember {
  CrateAccount(String mail, String pw, String firstName, String lastName,
      String userName)
      : super.createAccount(mail, pw, firstName, lastName, userName);
  Future request() async {
    var body = jsonDecode('''{
        "firstname": $firstName,
        "lastname": $lastName,
        "username": $userName,
        "email": $mail,
        "password": $pw
      }''');
    var response = requestVerhalten.request(uri, body);
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      settingsBox.put('userId', data['id']);
      settingsBox.put('firstName', data['firstname']);
      settingsBox.put('lastName', data['lastname']);
      Login login = Login(mail, pw);
      if (await login.request() != 0) return 4;
      return 0;
    } else if (response.statusCode == 422) {
      bool usernameExists;
      bool emailExists;
      try {
        emailExists = data['error']['details']['messages']['email'][0] ==
            "Email already exists";
      } catch (e) {
        emailExists = false;
      }
      try {
        usernameExists = data['error']['details']['messages']['username'][0] ==
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
  }
}

class MemberData extends ApiMember {
  MemberData(String userId) : super.memberData(userId);
  Future request() async {
    try {
      var response = await client.get(Uri.parse(ApiConnector.baseUrl +
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
}

class ApiPlantData extends ApiConnector {
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

class ApiPlant extends ApiConnector {
  //Post Plant wird nicht verwendet
  Plant plant;
  ApiPlant();
  ApiPlant.patch(this.plant);
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
