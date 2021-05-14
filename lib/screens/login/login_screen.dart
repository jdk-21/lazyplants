import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazyplants/components/api_connector2.dart';
import 'package:lazyplants/main.dart';
import 'package:lazyplants/screens/home_screen.dart';
import 'package:lazyplants/screens/login/create_account_screen1.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();
              return;
            },
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 200, left: 25, bottom: 100),
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
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 0.0),
                          child:
                              Icon(Icons.email_outlined, color: kPrimaryColor),
                        ),
                        Expanded(
                          child: TextField(
                            key: Key('email'),
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
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 0.0),
                          child: Icon(Icons.lock_outline, color: kPrimaryColor),
                        ),
                        Expanded(
                          child: TextField(
                            key: Key('password'),
                            obscureText: true,
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
                    key: Key('login'),
                    onPressed: () async {
                      if (mail != null && password != null) {
                        print("found credentials");
                        Login login = new Login(mail, password);
                        login.setRequest(PostRequest());
                        if (await login.request() == 0) {
                          // if login was successfull push to HomeScreen()
                          print("successful login");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('credentialsIncorrect'.tr),
                            ),
                          );
                        }
                      } else {
                        print("no credentials");
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
                        color: kPrimaryColor,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAccountScreen1()),
                    );
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors
                          .transparent; // Defer to the widget's default.
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
          ),
        ));
  }
}
