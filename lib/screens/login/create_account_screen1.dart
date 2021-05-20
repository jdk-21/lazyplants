import 'package:flutter/material.dart';
import 'package:lazyplants/components/custom_colors.dart';
import 'package:lazyplants/components/lp_custom_button.dart';
import 'package:lazyplants/components/lp_custom_text_button.dart';
import 'package:get/get.dart';
import 'package:lazyplants/screens/login/login_screen.dart';

import 'create_account_screen2.dart';

// ignore: must_be_immutable
class CreateAccountScreen1 extends StatelessWidget {
  String firstName;
  String lastName;

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
                        child: Icon(Icons.person_outline, color: CustomColors.kPrimaryColor),
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            firstName = value;
                          },
                          decoration: InputDecoration(
                            hintText: "firstName".tr,
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
                        child: Icon(Icons.person_outline, color: CustomColors.kPrimaryColor),
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            lastName = value;
                          },
                          decoration: InputDecoration(
                            hintText: "lastName".tr,
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
                    if (firstName != null && lastName != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateAccountScreen2(firstName, lastName)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('pleaseAddName'.tr),
                        ),
                      );
                    }
                  },
                  btnText: 'next'.tr,
                ),
              ),
              LP_CustomTextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                btnText: 'loginInstead'.tr,
              ),
            ],
          ),
        ));
  }
}
