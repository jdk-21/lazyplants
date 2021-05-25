import 'package:flutter/material.dart';
import 'package:lazyplants/components/db_models.dart';

class MonitoringScreen1 extends StatelessWidget {
  final Plant plant;
  MonitoringScreen1({
    Key key,
    @required this.plant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Monitoring'),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                color: Colors.red,
                height: 200,
              ),
              Container(color: Colors.blue, height: 200),
            ],
          ),
        ));
  }
}

/*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MonitoringScreen1(
                              plant: widget.plant,
                            )),
                  );*/
