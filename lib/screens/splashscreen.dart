import 'package:flutter/material.dart';
import 'package:lazyplants/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });

    return Scaffold(
      body: Center(
        child: Text(
          'LazyPlants',
          style: TextStyle(fontSize: 40, color: Colors.black87),
        ),
      ),
    );
  }
}
