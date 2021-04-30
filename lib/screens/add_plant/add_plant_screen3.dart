import 'package:flutter/material.dart';
import 'package:lazyplants/components/db_models.dart';
import 'package:lazyplants/screens/add_plant/add_plant_screen4.dart';
import 'package:lazyplants/main.dart';
import 'package:get/get.dart';

class AddPlantScreen3 extends StatefulWidget {
  Plant plant;

  AddPlantScreen3({
    Key key,
    @required this.plant,
  }) : super(key: key);

  @override
  _AddPlantScreen3State createState() => _AddPlantScreen3State();
}

class _AddPlantScreen3State extends State<AddPlantScreen3> {
  double _currentHumiditySliderValue = 70;

  Future _showMyDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'addPlant3_helpHumidityTitle'.tr,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    'addPlant3_helpHumidityText'.tr,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: addGradientColors,
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
                padding: const EdgeInsets.only(bottom: 80),
                child: Text(
                  "addPlant3_title".tr,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 60.0, right: 60.0),
                child: Text(
                  'addPlant3_humidityText'.tr,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 30.0),
                child: Slider(
                    value: _currentHumiditySliderValue,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    activeColor: Colors.blueAccent,
                    label: _currentHumiditySliderValue.round().toString(),
                    onChanged: (double value) {
                      widget.plant.soilMoisture = value;
                      setState(() {
                        _currentHumiditySliderValue = value;
                      });
                    }),
              ),
              TextButton(
                onPressed: () {
                  _showMyDialog();
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                //   textColor: Colors.white,
                //   highlightColor: Colors.transparent,
                //   hoverColor: Colors.transparent,
                //  splashColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 10,
                  ),
                  child: Text(
                    'needHelp'.tr,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // set default value if nothing has changed
                  if (widget.plant.soilMoisture == null) {
                    widget.plant.soilMoisture = _currentHumiditySliderValue;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddPlantScreen4(plant: widget.plant)),
                  );
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                //   textColor: Colors.white,
                //   highlightColor: Colors.transparent,
                //   hoverColor: Colors.transparent,
                //  splashColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                      colors: <Color>[
                        // TODO: Better gradient
                        Color(0xFF00897B),
                        Color(0xFF00897B),
                        Color(0xFF00897B),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.only(
                      left: 45.0, right: 45.0, top: 12, bottom: 12),
                  child: Text(
                    'next'.tr,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                //   textColor: Colors.white,
                //   highlightColor: Colors.transparent,
                //   hoverColor: Colors.transparent,
                //  splashColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10, bottom: 10),
                  child: Text(
                    'back'.tr,
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
