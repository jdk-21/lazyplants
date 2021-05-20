import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazyplants/screens/add_plant/add_plant_screen1.dart';

void main() {
  group('Add plant Screen 1', () {
    final helpFinder = find.text('addPlant1_helpText');
    final messageFinder = find.text("addPlant1_title");
    final nextFinder = find.text('next');
    final cancelFinder = find.text('cancel');
    testWidgets('create Add plant Screen 1', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddPlantScreen1()));

      expect(helpFinder, findsOneWidget);
      expect(messageFinder, findsOneWidget);
      expect(nextFinder, findsOneWidget);
      expect(cancelFinder, findsOneWidget);
    });
    testWidgets('tap next test, change to Screen 2', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddPlantScreen1()));
      await tester.tap(nextFinder);
      await tester.pumpAndSettle();
      expect(helpFinder, findsNothing);
    });
    testWidgets('tap help test, no internet connection --> nothing happens', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddPlantScreen1()));
      await tester.tap(helpFinder);
      await tester.pumpAndSettle();
      expect(helpFinder, findsOneWidget);
    });
    testWidgets('tap cancel',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddPlantScreen1()));
      await tester.tap(cancelFinder);
      await tester.pumpAndSettle();
      expect(messageFinder, findsNothing);
    });
  });
}
