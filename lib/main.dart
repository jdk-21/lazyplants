import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:lazyplants/screens/login/loading_screen.dart';
import 'package:lazyplants/translation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'components/api_connector.dart';
import 'package:http/http.dart' as http;
import 'components/custom_colors.dart';
import 'components/db_models.dart';

http.Client client = http.Client();
var api = ApiConnector(client);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory dir = await getApplicationDocumentsDirectory();
  //Datenbank laden
  Hive
    ..init(dir.path)
    ..registerAdapter(PlantAdapter())
    ..registerAdapter(PlantDataAdapter());
  print('init end');
  //Boxen laden
  await api.initBox();
  print('box opened');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // gets the system locale, doesn't work with web
    final String defaultLocale = Platform.localeName;

    return GetMaterialApp(
      // set translation
      translations: Translation(),

      locale: Locale(
          defaultLocale), // translations will be displayed in that locale
      fallbackLocale: Locale('en',
          'US'), // specify the fallback locale in case an invalid locale is selected.
      debugShowCheckedModeBanner: false,
      title: 'LazyPlants',
      theme: ThemeData(
        primaryColor: CustomColors.kPrimaryColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        primarySwatch: MaterialColor(0xff0C8C5E, CustomColors.primaryMaterialColor),
      ),
      home: LoadingScreen(),
    );
  }
}
