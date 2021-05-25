import 'package:flutter/material.dart';
import 'package:lazyplants/components/custom_colors.dart';
import 'package:lazyplants/components/custom_gradient_background.dart';
import 'package:lazyplants/components/db_models.dart';
import 'package:lazyplants/components/lp_custom_button.dart';
import 'package:lazyplants/components/lp_custom_text_button.dart';
import 'package:lazyplants/screens/add_plant/add_plant_screen3.dart';
import 'package:lazyplants/main.dart';
import 'package:get/get.dart';

class AddPlantScreen2 extends StatefulWidget {
  final Plant plant;

  AddPlantScreen2({
    Key key,
    @required this.plant,
  }) : super(key: key);

  @override
  _AddPlantScreen2State createState() => _AddPlantScreen2State();
}

class _AddPlantScreen2State extends State<AddPlantScreen2> {
  String dropdownValue = "addPlant2_dropDown".tr;
  String dropdownHelper;
  String plantName;

  espList() {
    var list = <String>["addPlant2_dropDown".tr];
    var data = api.readPlant();
    if (data !=  null && data != "error") {
      data.forEach((key, value) {
        if (!value.containsKey('plantName')) {
          list.add(value['espId']);
        }
      });
      print(list.toString());
    }
    dropdownValue = list[0];
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradientBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              "addPlant2_title".tr,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text("addPlant2_helpText".tr),
          Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
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
                  onChanged: (value) {
                    plantName = value;
                  },
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "addPlant2_hintName".tr,
                    hintStyle: TextStyle(
                      color: CustomColors.kPrimaryColor.withOpacity(0.5),
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
            dropdownColor: CustomColors.kPrimaryColor,
            underline: Container(height: 0, color: Colors.grey),
            onChanged: (String newValue) {
              dropdownHelper = newValue;
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: espList().map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: LPCustomButton(
              btnText: 'next'.tr,
              onPressed: () {
                if (plantName == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('addPlant2_noName'.tr),
                    ),
                  );
                } else if (dropdownHelper == "addPlant2_dropDown".tr ||
                    dropdownHelper == null) {
                  print(dropdownHelper);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('addPlant2_noESP'.tr),
                    ),
                  );
                } else {
                  // save plant data to plant object
                  widget.plant.plantName = plantName;
                  widget.plant.espId = dropdownHelper;
                  print(widget.plant.espId);
                  // get plantId from espId
                  api.readPlant().forEach((key, value) {
                    if (value['espId'] == dropdownHelper) {
                      widget.plant.plantId = value['id'];
                      widget.plant.memberId = value['memberId'];
                    }
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPlantScreen3(
                              plant: widget.plant,
                            )),
                  );
                }
              },
            ),
          ),
          LPCustomTextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            btnText: 'back'.tr,
          ),
        ],
      ),
    );
  }
}
