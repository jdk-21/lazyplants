import 'package:flutter/material.dart';
import 'package:lazyplants/components/db_models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lazyplants/main.dart';
import 'add_plant_screen2.dart';
import 'package:get/get.dart';

class AddPlantScreen1 extends StatelessWidget {
  
  AddPlantScreen1({
    Key key,
  }) : super(key: key);

  final Plant plant = Plant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, kPrimaryColor],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(
                  "addPlant1_title" .tr,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 20.0, left: 40.0, right: 40.0),
                child: Text(
                  'addPlant1_body' .tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              /*Container(
                margin: EdgeInsets.only(left: 40, right: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black38.withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text("blub"),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.copy,
                          color: Colors.white,
                        ),
                        tooltip: "Copy to clipboard",
                        onPressed: () {}),
                  ],
                ),
              ),*/
              FlatButton(
                child: Text('addPlant1_helpText' .tr,
                    style: TextStyle(
                        color: Colors.white.withAlpha(200), fontSize: 15)),
                onPressed: () async {
                  var helpUrl = 'addPlant1_helpUrl' .tr;
                  if (await canLaunch(helpUrl)) {
                    await launch(helpUrl);
                  } else {
                    final snackBar = SnackBar(content: Text('urlLaunchError' .tr + helpUrl));
                    // Find the ScaffoldMessenger in the widget tree and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar); 
                  }
                },
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddPlantScreen2(plant: plant,)),
                    );
                  },
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(
                        colors: <Color>[
                          // TODO: Better gradient
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        left: 45.0, right: 45.0, top: 12, bottom: 12),
                    child: Text(
                      'next'.tr,
                      key: Key('nextButton'),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Colors.white,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10, bottom: 10),
                  child: Text(
                    'cancel' .tr,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
