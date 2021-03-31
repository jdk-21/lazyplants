import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';
import 'create_account_screen.dart';

class WelcomeScreen extends StatelessWidget {
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
            Expanded(),
            Text(
              'lazyPlants'.tr,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            Text('aNewWay'.tr),
            RaisedButton(
              child: Text('login'.tr),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            OutlineButton(
              child: Text('createAccount'.tr),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateAccountScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
