import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'welcomeBack'.tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TextField(),
          TextField(),
          RaisedButton(
            child: Text('login'.tr),
          ),
          FlatButton(
            onPressed: () {},
            textColor: Colors.white,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: 10,
              ),
              child: Text(
                'createAccount'.tr,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
