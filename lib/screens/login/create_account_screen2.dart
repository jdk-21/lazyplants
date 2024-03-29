import 'package:flutter/material.dart';
import 'package:lazyplants/components/custom_colors.dart';
import 'package:lazyplants/components/lp_custom_button.dart';
import 'package:lazyplants/components/lp_custom_text_button.dart';
import 'package:lazyplants/main.dart';
import 'package:get/get.dart';
import 'package:lazyplants/screens/home_screen.dart';
import 'package:lazyplants/screens/login/login_screen.dart';

class CreateAccountScreen2 extends StatefulWidget {
  final String firstName;
  final String lastName;

  CreateAccountScreen2(this.firstName, this.lastName);

  @override
  _CreateAccountScreen2State createState() => _CreateAccountScreen2State();
}

class _CreateAccountScreen2State extends State<CreateAccountScreen2> {
  String username;

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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'createAccount'.tr,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
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
                        padding: const EdgeInsets.only(left: 10.0, right: 0.0),
                        child: Icon(Icons.email_outlined, color: CustomColors.kPrimaryColor),
                      ),
                      Expanded(
                        child: TextField(
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
                        padding: const EdgeInsets.only(left: 10.0, right: 0.0),
                        child: Icon(Icons.lock_outline, color: CustomColors.kPrimaryColor),
                      ),
                      Expanded(
                        child: TextField(
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
                child: LPCustomButton(
                  onPressed: () async {
                    if (mail != null && password != null) {
                      var success = await api.postCreateAccount(
                          widget.firstName,
                          widget.lastName,
                          mail,
                          password);
                      if (success == 0) {
                        // if login was successfull push to HomeScreen()
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      }
                      if (success == 1 || success == 2) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('emailExists'.tr),
                          ),
                        );
                      }
                      if (success == 1 || success == 3) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('passwordToShort'.tr),
                          ),
                        );
                      }
                      if (success == 4) {
                        // no internet connection or something else
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('somethingWrong'.tr),
                          ),
                        );
                      }
                      if (success == 5) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('invalidEmail'.tr),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('credentialsMissing'.tr),
                        ),
                      );
                    }
                  },
                  btnText: 'createAccount'.tr,
                ),
              ),
              LPCustomTextButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }, btnText: 'loginInstead' .tr),
            ],
          ),
        ));
  }
}
