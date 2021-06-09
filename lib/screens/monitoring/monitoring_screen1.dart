import 'package:flutter/material.dart';
import 'package:lazyplants/components/custom_colors.dart';
import 'package:lazyplants/main.dart';
import 'package:lazyplants/components/db_models.dart';
import 'package:lazyplants/screens/home_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; // für primaryYAxis

class MonitoringScreen1 extends StatefulWidget {
  final Plant plant;
  MonitoringScreen1({
    Key key,
    @required this.plant,
  }) : super(key: key);

  @override
  _MonitoringScreen1State createState() => _MonitoringScreen1State();
}

class _MonitoringScreen1State extends State<MonitoringScreen1> {
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  int selectLimit = 10;

  int selectedValue = 1;

  String wert;
  String name;
  Iterable<String> limitList = {"5", "10", "20", "30", "50", "100"};

  var textStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    switch (selectedValue) {
      case 1:
        wert = "temperature";
        name = "Temperatur";
        break;
      case 2:
        wert = "humidity";
        name = "Luftfeuchtigkeit";
        break;
      case 3:
        wert = "soilMoisture";
        name = "Bodenfeuchtigkeit";
        break;
      case 4:
        wert = "watertank";
        name = "Tanklevel";
        break;
      default:
        wert = "temperature";
        name = "Temperatur";
    }
    return FutureBuilder(
        future: api.getExactPlantData(selectLimit, widget.plant.plantId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> plantData) {
          if (!plantData.hasData) {
            return Scaffold(
              body:
                  Center(child: Container(child: CircularProgressIndicator())),
              floatingActionButton: HomeButton(),
            );
          } else if (plantData.data is String) {
            return Scaffold(
              backgroundColor: Colors.red[800],
              body: Center(
                child: Text(plantData.data.toString(),
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              floatingActionButton: HomeButton(),
            );
          } else if (plantData.data[0] == null) {
            return Scaffold(
              backgroundColor: Colors.orange[800],
              body: Center(
                child: Text("Pflanze besitzt keine Daten",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              floatingActionButton: HomeButton(),
            );
          }

          var mittelwert = 0.0;
          var count = 0;

          plantData.data.forEach((element) {
            mittelwert += element[wert];
            count++;
          });
          mittelwert = mittelwert / count;
          var measuringTime = DateFormat('dd.MM.yy HH:mm')
              .format(DateTime.parse(plantData.data[0]['measuringTime']));
          return Scaffold(
              appBar: AppBar(
                title: Text('Monitoring'),
              ),
              body: ListView(
                padding: EdgeInsets.all(5),
                children: [
                  Center(
                      child: Text(widget.plant.plantName,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ))),
                  SizedBox(height: 10),
                  Container(
                    height: 300,
                    child: CustomDiagram(
                        plant: widget.plant,
                        limit: selectLimit,
                        plantData: plantData.data,
                        wert: wert,
                        tooltipBehavior: _tooltipBehavior),
                  ),
                  SizedBox(height: 5), // Abstand von 5zwischen Containern
                  Text("letzter Messzeitpunkt: ${measuringTime.toString()}",
                      style: TextStyle(color: Colors.black)),
                  Text("Mittelwert: $mittelwert",
                      style: TextStyle(color: Colors.black)),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: Center(
                        child: Row(
                          children: [
                            DropdownButton(
                                underline: Container(
                                    height: 0,
                                    color: CustomColors.kPrimaryColor),
                                iconDisabledColor: CustomColors.kPrimaryColor,
                                dropdownColor: Colors.green[100],
                                value: selectedValue,
                                items: [
                                  DropdownMenuItem(
                                      child: IconText(
                                          icon: Icons.thermostat,
                                          text: "Temperatur",
                                          fontSize: 15),
                                      value: 1),
                                  DropdownMenuItem(
                                      child: IconText(
                                          icon: Icons.air,
                                          text: "Luftfeuchtigkeit",
                                          fontSize: 15),
                                      value: 2),
                                  DropdownMenuItem(
                                      child: IconText(
                                          icon: Icons.water_damage_outlined,
                                          text: "Bodenfeuchtigkeit",
                                          fontSize: 15),
                                      value: 3),
                                  DropdownMenuItem(
                                      child: IconText(
                                          icon: Icons.water,
                                          text: "Tanklevel",
                                          fontSize: 15),
                                      value: 4),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                }),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 100),
                                child: TextField(
                                  key: Key('limit'),
                                  onSubmitted: (value) {
                                    setState(() {
                                      if (int.parse(value, radix: 10) >= 0) {
                                        selectLimit =
                                            int.parse(value, radix: 10);
                                      } else {
                                        value = selectLimit.toString();
                                      }
                                    });
                                  },
                                  autofillHints: limitList,
                                  autofocus: false,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: selectLimit.toString(),
                                    helperText: "Datensätze",
                                  ),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                      child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text("Aktuelle Werte:\n", style: textStyle),
                        ],
                      ),
                      IconText(
                          icon: Icons.thermostat,
                          text:
                              "Temperatur: ${plantData.data[0]['temperature']}°C"),
                      IconText(
                          icon: Icons.air,
                          text:
                              "Luftfeuchtigkeit: ${plantData.data[0]['humidity']}%"),
                      IconText(
                          icon: Icons.water_damage_outlined,
                          text:
                              "Bodenfeuchtigkeit: ${plantData.data[0]['soilMoisture']}%"),
                      IconText(
                          icon: Icons.water,
                          text: "Tanklevel: ${plantData.data[0]['watertank']}%"),
                    ],
                  )),
                ],
              ));
        });
  }
}

class IconText extends StatelessWidget {
  const IconText(
      {Key key, @required this.icon, @required this.text, this.fontSize})
      : super(key: key);

  final IconData icon;
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
        fontSize: fontSize == null ? 20 : fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.black);
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Icon(
            icon,
            color: Colors.black,
          ),
        ),
        Text(text, style: textStyle)
      ],
    );
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      key: Key('home'),
      child: Icon(
        Icons.home,
      ),
      backgroundColor: CustomColors.kPrimaryColor,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
    );
  }
}

class CustomDiagram extends StatelessWidget {
  final Plant plant;
  final String wert;
  final plantData;
  final TooltipBehavior _tooltipBehavior;
  final int limit;

  const CustomDiagram({
    Key key,
    @required this.plant,
    @required this.limit,
    @required this.plantData,
    @required this.wert,
    @required TooltipBehavior tooltipBehavior,
  })  : _tooltipBehavior = tooltipBehavior,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var label;
    String name;
    switch (wert) {
      case "temperature":
        name = "Temperatur";
        label = '{value}°C';
        break;
      case "humidity":
        name = "Luftfeuchtigkeit";
        label = '{value}%';
        break;
      case "soilMoisture":
        name = "Bodenfeuchtigkeit";
        label = '{value}%';
        break;
      case "watertank":
        name = "Tanklevel";
        label = '{value}%';
        break;
      default:
        label = '{value}°C';
        name = "Temperatur";
    }
    return Container(
        child: SfCartesianChart(
      // Diagramm
      title: ChartTitle(text: name),
      tooltipBehavior: _tooltipBehavior,
      borderColor: CustomColors.kPrimaryColor,
      borderWidth: 2,
      primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement
              .shift), // Anpassen der X-Achse (2021 soll noch im ganz Sichtbar sein)
      primaryYAxis: NumericAxis(labelFormat: label),
      /*numberFormat: NumberFormat.simpleCurrency(
                      decimalDigits:
                          0)) // Einfügen des $ Symbols an der Y-Achse*/
      series: <ChartSeries>[
        LineSeries<dynamic, DateTime>(
            name: name,
            dataSource: plantData,
            color: CustomColors.kPrimaryColor,
            yValueMapper: (dynamic p, _) => p[wert], //Initalisierung X-Achse
            xValueMapper: (dynamic p, _) => DateTime.parse(p['measuringTime']),
            dataLabelSettings: DataLabelSettings(
                isVisible:
                    false), // Anzeigen der einzelnen Werte der Y-Achse im Diagram
            enableTooltip: true

            //Iniatalisierung Y-Achse
            )
      ],
    ));
  }
}
