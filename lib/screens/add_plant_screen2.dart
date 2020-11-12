import 'package:flutter/material.dart';
import 'package:lazyplants/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lazyplants/main.dart';

class AddPlantScreen2 extends StatefulWidget {
  const AddPlantScreen2({
    Key key,
  }) : super(key: key);

  @override
  _AddPlantScreen2State createState() => _AddPlantScreen2State();
}

class _AddPlantScreen2State extends State<AddPlantScreen2> {

  String dropdownValue = 'ESP 32 Living Room';

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
                  "What's your name?",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text("Name of your plant"),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: 46,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: TextField(
                      autocorrect: false,
                      enabled: true,
                      onSubmitted: (value) {
                        print(value);
                      },
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: "Totally creative name",
                        hintStyle: TextStyle(
                          color: kPrimaryColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              DropdownButton<String>(
                value: dropdownValue,
                iconEnabledColor: Colors.white,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                dropdownColor: kPrimaryColor,
                
                underline: Container(
                  height: 0,
                  color: Colors.grey
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['ESP 32 Living Room', 'ESP Bonsai Tree', 'Arduino Garden', 'Raspberry Bedroom']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen()),
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
                      'Finished',
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
