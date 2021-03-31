// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_app_is_running.dart';
import './step/i_wait_seconds.dart';
import './step/i_see_text.dart';
import 'package:get/get.dart';

void main() {
  group('Counter', () {
    testWidgets('Initial counter value is 0', (tester) async {
      await theAppIsRunning(tester);
      //await iWaitSeconds(tester, '500');
      await iSeeText(tester, 'LazyPlants');
    });
  });
}
