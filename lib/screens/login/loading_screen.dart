import 'package:flutter/material.dart';
import 'package:lazyplants/main.dart';
import 'package:lazyplants/screens/home_screen.dart';
import 'package:lazyplants/screens/login/login_screen.dart';

class LoadingScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    //checkLogin(context);
    if (api.checkLoggedIn()) {
      return HomeScreen();
    }
    else {
      return LoginScreen();
    } 
  }
}


