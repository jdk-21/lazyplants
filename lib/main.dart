import 'package:flutter/material.dart';
import 'package:lazyplants/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:lazyplants/translation.dart';
import 'dart:io';

const Color kPrimaryColor = Color(0xff0C8C5E);
const double kPadding = 20;
const Color kTextDark = Colors.black54;

Map<int, Color> primaryMaterialColor =
{
50:Color.fromRGBO(12,140,94, .1),
100:Color.fromRGBO(12,140,94, .2),
200:Color.fromRGBO(12,140,94, .3),
300:Color.fromRGBO(12,140,94, .4),
400:Color.fromRGBO(12,140,94, .5),
500:Color.fromRGBO(12,140,94, .6),
600:Color.fromRGBO(12,140,94, .7),
700:Color.fromRGBO(12,140,94, .8),
800:Color.fromRGBO(12,140,94, .9),
900:Color.fromRGBO(12,140,94, 1),
};

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // constant colors
  @override
  Widget build(BuildContext context) {
    // gets the system locale, doesn't work with web
    final String defaultLocale = Platform.localeName;
    return GetMaterialApp(
      // set translation
      translations: Translation(),
      
      locale: Locale(defaultLocale), // translations will be displayed in that locale
      fallbackLocale: Locale('de', 'DE'), // specify the fallback locale in case an invalid locale is selected.
      debugShowCheckedModeBanner: false,
      title: 'LazyPlants',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        primarySwatch: MaterialColor(0xff0C8C5E, primaryMaterialColor),
      ),
      home: HomeScreen(),
    ); 
  }
}

