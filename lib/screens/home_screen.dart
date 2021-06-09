import 'package:flutter/material.dart';
import 'package:lazyplants/components/db_models.dart';
import 'dart:ui' as ui;
import 'package:lazyplants/components/navigation_drawer.dart';
import 'package:lazyplants/components/sliver_appbar.dart';
import 'package:lazyplants/main.dart';
import 'package:lazyplants/screens/monitoring/monitoring_screen1.dart';
import 'add_plant/add_plant_screen1.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lazyplants/components/custom_colors.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    loadDataInList();
  }

  List<Widget> plantList = [];

  _buildList(List<dynamic> data) {
    final timeNow = DateTime.now();
    var random = new Random();
    List<Widget> listItems = [];
    //Map data;
    if (data == null) {
      return listItems;
    }
    data.forEach((element) {
      Plant plant = Plant();
      element.forEach((key, value) {
        switch (key) {
          case 'plantDate':
            plant.plantDate = DateTime.parse(value);
            break;
          case 'plantName':
            plant.plantName = value;
            break;
          case 'plantId':
            plant.plantId = value;
            break;
          case 'plantDate':
            plant.plantDate = DateTime.parse(value);
            break;
          case 'temperature':
            plant.temperature = value;
            break;
        }
      });
      if (plant.plantName != null && plant.plantDate != null) {
        final difference = timeNow.difference(DateTime.parse(plant.plantDate.toString())).inDays;
        listItems.add(Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MonitoringScreen1(
                          plant: plant,
                        )),
              );
            },
            child: Card(
              elevation: 15,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    child: Column(
                      children: [
                        CustomPaint(
                          painter: CircleIndicator(),
                          child: Container(
                            height: 30,
                          ),
                        ),
                        CustomPaint(
                          painter: WaterIndicator(percentage: random.nextDouble()),
                          child: Container(height: 80),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plant.plantName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            difference.toString() + " days alive",
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'last sync: ' +
                                DateFormat("yy-MM-dd hh:mm").format(
                                    DateTime.parse(plant.plantDate.toString())),
                            style: TextStyle(color: Colors.black45),
                          ),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1467043198406-dc953a3defa0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=670&q=80",
                        )),
                  )
                ],
              ),
            ),
          ),
        ));
      }
    });
    if (listItems.length == 0) {
      listItems.add(Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Text(
            'home_noPlant'.tr,
            style: TextStyle(color: Colors.black87),
          ),
        ),
      ));
    }
    return listItems;
  }

  Future<Null> loadDataInList() async {
    var data = await api.getPlant();
    print(data.runtimeType);
    if (data != "error") {
      setState(() {
        plantList = _buildList(data);
      });
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawer(),
        floatingActionButton: FloatingActionButton(
          key: Key('fab'),
          child: Icon(
            Icons.add_rounded,
          ),
          backgroundColor: CustomColors.kPrimaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPlantScreen1()),
            );
          },
        ),
        body: RefreshIndicator(
          // adds pull to refresh functionality
          onRefresh: loadDataInList,
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: MySliverAppBar(
                  collapsedHeight: 60,
                  expandedHeight: 250,
                  paddingTop: 20,
                  title: "LazyPlants",
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 40),
                sliver:
                    SliverList(delegate: SliverChildListDelegate(plantList)),
              ),
            ],
          ),
        ));
  }
}

class CircleIndicator extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // set the color property of the paint
    paint.color = CustomColors.kPrimaryColor;

    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(25, 25);

    // draw the circle with center having radius 75.0
    canvas.drawCircle(center, 10.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class WaterIndicator extends CustomPainter {
  final double percentage;

  WaterIndicator({@required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 25),
        Offset(0, 55),
        [Color.fromARGB(255, 70, 96, 226), Color.fromARGB(200, 226, 70, 107)],
      );

    var rect =
        Rect.fromLTWH(16, 10 + (1 - percentage) * 50, 18, percentage * 50);

    // draw the circle with center having radius 75.0
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(10)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
