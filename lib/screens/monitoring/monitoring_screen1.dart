import 'package:flutter/material.dart';
import 'package:lazyplants/components/custom_colors.dart';
import 'package:lazyplants/main.dart';
import 'package:lazyplants/components/db_models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; // für primaryYAxis
import 'package:intl/date_symbol_data_file.dart';
//initializeDateFormatting('de_DE', null);

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
  int limit = 5;

  int selectedValue = 1;

  String wert;

  var textStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    switch (selectedValue) {
      case 1:
        wert = "temperature";
        break;
      case 2:
        wert = "humidity";
        break;
      case 3:
        wert = "soilMoisture";
        break;
      case 4:
        wert = "tanklevel";
        break;
      default:
        wert = "temperature";
    }
    return FutureBuilder(
        future: api.getExactPlantData(limit, widget.plant.plantId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> plantData) {
          if (!plantData.hasData) {
            return Scaffold(
                body: Container(child: CircularProgressIndicator()));
          } else if (plantData.data is String) {
            return Scaffold(
                backgroundColor: Colors.red[800],
                body: Center(
                    child: Text(plantData.data.toString(),
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black))
                    //TODO: zurück button
                    ));
          }

          var mittelwert = 0.0;
          var count = 0;

          plantData.data.forEach((element) {
            mittelwert += element[wert];
            count++;
          });
          mittelwert = mittelwert / count;
          var measuringTime = DateFormat('dd.MM.yy hh:mm a')
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
                        limit: limit,
                        plantData: plantData.data,
                        wert: wert,
                        tooltipBehavior: _tooltipBehavior),
                  ),
                  SizedBox(height: 5), // Abstand von 5zwischen Containern
                  Container(
                    height: 100,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: DropdownButton(
                              underline: Container(
                                  height: 0, color: CustomColors.kPrimaryColor),
                              iconDisabledColor: CustomColors.kPrimaryColor,
                              style: TextStyle(
                                  color: CustomColors.kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                              dropdownColor: Colors.green[200],
                              value: selectedValue,
                              items: [
                                DropdownMenuItem(
                                    child: Text("Temperatur"), value: 1),
                                DropdownMenuItem(
                                    child: Text("Luftfeuchtigkeit"), value: 2),
                                DropdownMenuItem(
                                    child: Text("Bodenfeuchtigkeit"), value: 3),
                                //DropdownMenuItem(
                                //  child: Text("Tank Level"), value: 4),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              }),
                        )),
                  ),
                  Container(
                      //color: Colors.blue,
                      height: 200,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "letzter Messzeitpunkt: ${measuringTime.toString()} \n",
                              style: textStyle),
                          Text("Mittelwert: $mittelwert", style: textStyle),
                        ],
                      )),
                ],
              ));
        });
  }
}

///////////////////////////////////////////////////////////////////////////////////////////
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
    if (wert == "temperatur") {
      label = '{value}°C';
    }
    return Container(
        child: SfCartesianChart(
      // Diagramm "Container"
      title: ChartTitle(text: wert),
      //legend: Legend(isVisible: true),
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
            name: wert,
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
