import 'package:flutter/material.dart';
import 'package:lazyplants/screens/add_plant/add_plant_screen4.dart';
import 'package:lazyplants/main.dart';

class AddPlantScreen3 extends StatefulWidget {
  const AddPlantScreen3({
    Key key,
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
                  'The Humidity Slider:',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    '0 represents 0% humidity and 100 represents 100%. If you set the slider to 75%, LazyPlants will water your plant if the humidity is below 75%.',
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
                padding: const EdgeInsets.only(bottom: 80),
                child: Text(
                  "Set your defaults",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                child: Text(
                  "At what percentage should LazyPlants water your plants?",
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
                      setState(() {
                        _currentHumiditySliderValue = value;
                      });
                    }),
              ),
              FlatButton(
                onPressed: () {
                  _showMyDialog();
                },
                textColor: Colors.white,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 10,
                  ),
                  child: const Text(
                    'Need help?',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPlantScreen4()),
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
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 14),
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
                  child: const Text(
                    'Back',
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
