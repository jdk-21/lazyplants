import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazyplants/components/db_models.dart';
import 'package:lazyplants/screens/add_plant/add_plant_screen2.dart';

void main() {
  group('Add plant Screen 2', () {

    final titleFinder = find.text("addPlant2_title");
    final nextFinder = find.text('next');
    final backFinder = find.text('back');

    testWidgets('create Add plant Screen 2', (WidgetTester tester) async {
      Plant plant;
      await tester.pumpWidget(MaterialApp(home: AddPlantScreen2(plant: plant)));

      expect(titleFinder, findsOneWidget);
      expect(nextFinder, findsOneWidget);
      expect(backFinder, findsOneWidget);
    });
    testWidgets('tap next test, wihtout input data', (WidgetTester tester) async {
      Plant plant;
      await tester.pumpWidget(MaterialApp(home: AddPlantScreen2(plant: plant)));
      await tester.tap(nextFinder);
      await tester.pumpAndSettle();
      expect(titleFinder, findsOneWidget);
    });
  });
}
