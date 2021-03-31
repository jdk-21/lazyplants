import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  
  void checkLoggedIn() async {
    
  }

  @override
  Widget build(BuildContext context) {
    checkLoggedIn();
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}