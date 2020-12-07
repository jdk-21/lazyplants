import 'dart:async';
import 'package:glob/glob.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'steps.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob(r"test_driver/features/appbar.feature"),Glob(r"test_driver/features/navigationbar.feature"),Glob(r"test_driver/features/settings.feature")]
    ..stepDefinitions = []
    ..reporters = [ProgressReporter(), TestRunSummaryReporter()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart"
    ..exitAfterTestRun = true;
  return GherkinRunner().execute(config);
}