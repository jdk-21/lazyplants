import 'package:flutter/material.dart';
import 'package:lazyplants/components/custom_colors.dart';
import 'package:lazyplants/main.dart';
import 'package:lazyplants/components/db_models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; // für primaryYAxis
import 'package:intl/date_symbol_data_file.dart';
initializeDateFormatting('de_DE');

class MonitoringScreen1 extends StatelessWidget {
  final Plant plant;
  MonitoringScreen1({
    Key key,
    @required this.plant,
  }) : super(key: key);
  TooltipBehavior _tooltipBehavior =
      TooltipBehavior(enable: true); // Anzeige der Datenpunkte beim Anklicken
  int limit = 5;
  String wert = "temperature";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: api.getExactPlantData(limit, plant.espId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> plantData) {
          if (!plantData.hasData) {
            return CircularProgressIndicator();
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
              body: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    CustomDiagram(
                        plant: plant,
                        limit: limit,
                        plantData: plantData.data,
                        wert: wert,
                        tooltipBehavior: _tooltipBehavior),
                    SizedBox(height: 5), // Abstand von 5zwischen Containern
                    // Auswahlmöglichkeit Verschiedene "werte"
                    Container(
                        //color: Colors.blue,
                        height: 200,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "letzter Messzeitpunkt: ${measuringTime.toString()}\nMittelwert: $mittelwert \n",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        )),
                  ],
                ),
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
