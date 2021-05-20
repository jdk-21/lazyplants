import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazyplants/components/custom_colors.dart';
import 'package:lazyplants/components/lp_custom_button.dart';
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
    var children2 = [
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
                    margin: EdgeInsets.symmetric(horizontal: CustomColors.kPadding),
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
                              Icon(Icons.email_outlined, color: CustomColors.kPrimaryColor),
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
                                color: CustomColors.kPrimaryColor.withOpacity(0.5),
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
                    margin: EdgeInsets.symmetric(horizontal: CustomColors.kPadding),
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
                          child: Icon(Icons.lock_outline, color: CustomColors.kPrimaryColor),
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
                                color: CustomColors.kPrimaryColor.withOpacity(0.5),
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
                  child: LP_CustomButton(
                    onPressed: () async {
                      if (mail != null && password != null) {
                        print("found credentials");
                        if (await api.postLogin(mail, password) == 0) {
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
                    btnText: 'login'.tr,
                    key: Key('login'),
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
              ];
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
              children: children2,
            ),
          ),
        ));
  }
}
