import 'package:flutter_test/flutter_test.dart';

Future<void> iWaitSeconds(WidgetTester tester, dynamic seconds) async {
    // wait for 2 seconds
    await tester.runAsync(() async {
      await Future.delayed(Duration(milliseconds: int.parse(seconds)), (){print('2');});
      print('1');
    
    });
    //await Future.delayed(Duration(seconds: int.parse(seconds)), (){print('2');});
    

    
}
