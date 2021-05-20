import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lazyplants/components/db_models.dart';
import 'package:lazyplants/components/lp_custom_button.dart';
import 'package:lazyplants/screens/home_screen.dart';
import 'dart:io';
import 'package:lazyplants/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AddPlantScreen4 extends StatefulWidget {
  final Plant plant;

  AddPlantScreen4({
    Key key,
    @required this.plant,
  }) : super(key: key);

  @override
  _AddPlantScreen4State createState() => _AddPlantScreen4State();
}

class _AddPlantScreen4State extends State<AddPlantScreen4> {
  // _image isn't unused
  // ignore: unused_field
  Image _image;
  final picker = ImagePicker();

  Future getImage(type) async {
    var pickedFile;
    if (type == "camera") {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    } else if (type == "gallery") {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }

    setState(() {
      if (pickedFile != null) {
        // dart:io -> File isn't available in Flutter Web
        if (kIsWeb) {
          _image = Image.network(pickedFile.path);
        } else {
          _image = Image.file(File(pickedFile.path));
        }
      } else {
        print('No image selected.');
      }
    });
  }

  saveChanges() {
    print(widget.plant.plantName.toString());
    print(widget.plant.plantId.toString());
    print(widget.plant.soilMoisture.toString());
    api.patchPlant(
        widget.plant.plantId,
        widget.plant.espId,
        widget.plant.plantName,
        widget.plant.room,
        widget.plant.soilMoisture.toString(),
        widget.plant.plantPic,
        widget.plant.memberId);
    api.cachePlant();
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
                  'addPlant4_title'.tr,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              LP_CustomButton(
                  onPressed: () {
                    getImage("camera");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                    saveChanges();
                  },
                  btnText: 'useCamera'.tr),
              const SizedBox(
                height: 5,
              ),
              LP_CustomButton(
                  onPressed: () {
                    getImage("gallery");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                    saveChanges();
                  },
                  btnText: 'pickGallery'.tr),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.transparent),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 10, bottom: 10),
                        child: Text(
                          'back'.tr,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    Text("|"),
                    TextButton(
                      onPressed: () {
                        saveChanges();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.transparent),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(
                            right: 15.0, top: 10, bottom: 10),
                        child: Text(
                          'finish'.tr,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
