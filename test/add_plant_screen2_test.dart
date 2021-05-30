import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazyplants/components/db_models.dart';
import 'package:lazyplants/screens/add_plant/add_plant_screen2.dart';

Future<void> main() async {
  group('Add plant Screen 2', () {
    final titleFinder = find.text("addPlant2_title");
    final nextFinder = find.text('next');
    final backFinder = find.text('back');

    testWidgets('create Add plant Screen 2', (WidgetTester tester) async {
      Plant plant;
      var espData;
      await tester.pumpWidget(MaterialApp(
          home: AddPlantScreen2(
        plant: plant,
        espData: espData,
      )));

      expect(titleFinder, findsOneWidget);
      expect(nextFinder, findsOneWidget);
      expect(backFinder, findsOneWidget);
    });
    testWidgets('tap next test, without input data',
        (WidgetTester tester) async {
      Plant plant;
      var espData;
      await tester.pumpWidget(MaterialApp(
          home: AddPlantScreen2(
        plant: plant,
        espData: espData,
      )));
      await tester.tap(nextFinder);
      await tester.pumpAndSettle();
      expect(titleFinder, findsOneWidget);
    });
    /*testWidgets('tap next test, with input data', (WidgetTester tester) async {
      final client = MockClient();
      final ApiConnector api = ApiConnector(client);
      Directory dir = await getApplicationDocumentsDirectory();
      //Datenbank laden
      Hive
        ..init(dir.path)
        ..registerAdapter(PlantAdapter())
        ..registerAdapter(PlantDataAdapter());
      await tester.runAsync(() async {
        // create apiConnector and init Boxes
        api.dataBox = await Hive.openBox('plantData');
        api.plantBox = await Hive.openBox('plants');
        api.settingsBox = await Hive.openBox('settings');
        api.settingsBox.put('token', "testToken");
        print("setup finished");
      });
      print("next");
      Plant plant;
      var data = '''{
        "plantName": "TEST",
        "plantDate": "2020-12-02T09:29:16.519Z",
        "espId": "espBlume3",
        "soilMoisture": 25,
        "humidity": 30,
        "id": "5fc76bf50b487e3b0415f56d",
        "memberId": "5fbd47595421905a1a869a55"
      }''';
      //await tester.runAsync(() async => await setup());
      print("blub");
      api.plantBox.add(data);
      print(api.plantBox.isEmpty);
      print("bla");
      await tester.pumpAndSettle();
      await tester.pumpWidget(MaterialApp(home: AddPlantScreen2(plant: plant)));
      await tester.tap(nextFinder);
      await tester.pumpAndSettle();
      expect(titleFinder, findsOneWidget);
    });*/
  });
}
