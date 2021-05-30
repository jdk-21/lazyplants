import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:lazyplants/components/db_models.dart';
import 'package:lazyplants/main.dart';
import 'package:lazyplants/screens/add_plant/add_plant_screen4.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  Directory dir = await getApplicationDocumentsDirectory();
  //Datenbank laden
  Hive
    ..init(dir.path)
    ..registerAdapter(PlantAdapter())
    ..registerAdapter(PlantDataAdapter());
  group('Add plant Screen 4', () {
    final titleFinder = find.text("addPlant4_title");
    final finishFinder = find.text("finish");
    final backFinder = find.text('back');
    final cameraFinder = find.text('useCamera');
    final galleryFinder = find.text('pickGallery');

    testWidgets('create Add plant Screen 4', (WidgetTester tester) async {
      Plant plant = Plant();
      await tester.pumpWidget(MaterialApp(home: AddPlantScreen4(plant: plant)));

      expect(titleFinder, findsOneWidget);
      expect(backFinder, findsOneWidget);
      expect(cameraFinder, findsOneWidget);
      expect(galleryFinder, findsOneWidget);
      expect(finishFinder, findsOneWidget);
    });
    testWidgets('tap finish', (WidgetTester tester) async {
      Plant plant = Plant();
      await tester.runAsync(() async {
        // init Boxes
        api.settingsBox = await Hive.openBox('settings');
        api.settingsBox.put('token', "testToken");
      });
      await tester.pumpWidget(MaterialApp(home: AddPlantScreen4(plant: plant)));
      await tester.tap(finishFinder);
      await tester.pumpAndSettle();
      expect(titleFinder, findsNothing);
      api.settingsBox.clear();
    });
    testWidgets('tap back', (WidgetTester tester) async {
      Plant plant = Plant();
      await tester.pumpWidget(MaterialApp(home: AddPlantScreen4(plant: plant)));
      await tester.tap(backFinder);
      await tester.pumpAndSettle();
      expect(titleFinder, findsNothing);
    });
    testWidgets('tap useCamera', (WidgetTester tester) async {
      Plant plant = Plant();
      plant.plantId = "plantId";
      plant.espName = "espName";
      plant.plantName = "plantName";
      plant.room = "roomName";
      plant.soilMoisture = 80.0;
      await tester.runAsync(() async {
        api.settingsBox = await Hive.openBox('settings');
        api.settingsBox.put('token', "testToken");
      });

      await tester.pumpWidget(MaterialApp(home: AddPlantScreen4(plant: plant)));
      await tester.tap(cameraFinder);
      await tester.pumpAndSettle();
      expect(titleFinder, findsNothing);
      api.settingsBox.clear();
    });
  });
}
