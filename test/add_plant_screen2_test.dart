import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazyplants/screens/add_plant/add_plant_screen2.dart';

void main() {
  group('Add plant Screen 2', () {

    final titleFinder = find.text("addPlant2_title");
    final nextFinder = find.text('next');
    final backFinder = find.text('back');

    testWidgets('create Add plant Screen 2', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddPlantScreen2()));

      expect(titleFinder, findsOneWidget);
      expect(nextFinder, findsOneWidget);
      expect(backFinder, findsOneWidget);
    });
    
  });
}
