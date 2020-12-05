import 'package:flutter/material.dart';
import 'package:lazyplants/components/db_models.dart';
import 'dart:ui' as ui;
import 'package:lazyplants/components/navigation_drawer.dart';
import 'package:lazyplants/components/sliver_appbar.dart';
import 'package:lazyplants/main.dart';
import 'add_plant/add_plant_screen1.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavigationDrawer(),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add_rounded,
          ),
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPlantScreen1()),
            );
          },
        ),
        body: Material(
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
                  SliverList(delegate: SliverChildListDelegate(_buildList())),
            ),
          ],
        )));
  }
}

_buildList() {
  List<Widget> listItems = List();
  //Map data;
  var data = api.readPlant();
  data.forEach((key, value) {
    Plant plant = Plant();
    value.forEach((key, value) {
      switch (key) {
        case 'plantDate':
          plant.plantDate = DateTime.parse(value);
          break;
        case 'plantName':
          plant.plantName = value;
          break;
      }
    });
    if (plant.plantName != null && plant.plantDate != null) {
      listItems.add(Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                      painter: WaterIndicator(percentage: 0.6),
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
                        "15 days alive",
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'last sync: ' + plant.plantDate.toString(),
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


class CircleIndicator extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // set the color property of the paint
    paint.color = kPrimaryColor;

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
