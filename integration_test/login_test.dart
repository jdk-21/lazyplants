import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lazyplants/main.dart' as app;

void main() {
  group('App Test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    final fabFinder = find.byKey(Key('fab'));
    final nextButtonFinder = find.byKey(Key('nextButton'));
    final emailFinder = find.byKey(Key('email'));
    final passwordFinder = find.byKey(Key('password'));
    final loginFinder = find.byKey(Key('login'));

    

    testWidgets("login test", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.enterText(emailFinder, "max@max.com");
      await tester.enterText(passwordFinder, "max123");
      await tester.pumpAndSettle();
      await tester.tap(loginFinder);
      await tester.pumpAndSettle(Duration(seconds: 5));
      expect(fabFinder, findsOneWidget);
    });
    /* testWidgets("adds a plant", (WidgetTester tester) async {
      await tester.pumpAndSettle(Duration(seconds: 5));
      await tester.enterText(emailFinder, "max@max.com");
      await tester.enterText(passwordFinder, "max123");
      await tester.pumpAndSettle();
      await tester.tap(loginFinder);
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 5));
      await tester.tap(fabFinder);
      await tester.pumpAndSettle();
      expect(nextButtonFinder, findsOneWidget);
    });*/
  });
}
