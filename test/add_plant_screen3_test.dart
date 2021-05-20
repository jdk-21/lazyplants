import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazyplants/components/db_models.dart';
import 'package:lazyplants/screens/add_plant/add_plant_screen3.dart';

Future<void> main() async {
  group('Add plant Screen 3', () {
    final titleFinder = find.text("addPlant3_title");
    final titleFinder2 = find.text("addPlant4_title");
    final nextFinder = find.text('next');
    final backFinder = find.text('back');

    testWidgets('create Add plant Screen 3', (WidgetTester tester) async {
      Plant plant = Plant();
      await tester.pumpWidget(MaterialApp(home: AddPlantScreen3(plant: plant)));

      expect(titleFinder, findsOneWidget);
      expect(nextFinder, findsOneWidget);
      expect(backFinder, findsOneWidget);
    });
    testWidgets('tap next, without input data, show AddPlantScreen4',
        (WidgetTester tester) async {
      Plant plant = Plant();
      await tester.pumpWidget(MaterialApp(home: AddPlantScreen3(plant: plant)));
      await tester.tap(nextFinder);
      await tester.pumpAndSettle();
      expect(titleFinder2, findsOneWidget);
    });
    testWidgets('tap back',
        (WidgetTester tester) async {
      Plant plant = Plant();
      await tester.pumpWidget(MaterialApp(home: AddPlantScreen3(plant: plant)));
      await tester.tap(backFinder);
      await tester.pumpAndSettle();
      expect(titleFinder, findsNothing);
    });
  });
}
