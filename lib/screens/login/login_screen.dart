import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazyplants/main.dart';
import 'package:lazyplants/screens/home_screen.dart';
import 'package:lazyplants/screens/login/loading_screen.dart';

class LoginScreen extends StatelessWidget {
  String mail;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFA2BEC2),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/login_flower.jpg'),
                fit: BoxFit.cover),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 225, left: 25, bottom: 100),
                child: Text(
                  'helloThere'.tr,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 45, right: 45),
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: kPadding),
                  height: 46,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 50,
                          color: Colors.black38,
                        )
                      ]),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 0.0),
                        child: Icon(Icons.email_outlined, color: kPrimaryColor),
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            mail = value;
                          },
                          decoration: InputDecoration(
                            hintText: "email".tr,
                            hintStyle: TextStyle(
                              color: kPrimaryColor.withOpacity(0.5),
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                            ),
                          ),
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 45, right: 45),
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: kPadding),
                  height: 46,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 50,
                          color: Colors.black38,
                        )
                      ]),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 0.0),
                        child: Icon(Icons.lock_outline, color: kPrimaryColor),
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: InputDecoration(
                            hintText: "password".tr,
                            hintStyle: TextStyle(
                              color: kPrimaryColor.withOpacity(0.5),
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                            ),
                          ),
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextButton(
                  onPressed: () async {
                    if (mail != null && password != null) {
                      if (await api.postLogin(mail, password) == 0) {
                        // if login was successfull push to HomeScreen()
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('credentialsIncorrect'.tr),
                          ),
                        );
                      }
                    }
                    else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('credentialsMissing'.tr),
                          ),
                        );
                      }
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors
                          .transparent; // Defer to the widget's default.
                    }),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(
                        colors: <Color>[
                          // TODO: Better gradient
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        left: 45.0, right: 45.0, top: 12, bottom: 12),
                    child: Text(
                      'login'.tr,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.transparent; // Defer to the widget's default.
                  }),
                ),
                child: Text(
                  'createAccount'.tr,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ));
  }
}
