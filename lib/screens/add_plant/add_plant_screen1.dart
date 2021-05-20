import 'package:flutter/material.dart';
import 'package:lazyplants/components/custom_gradient_background.dart';
import 'package:lazyplants/components/db_models.dart';
import 'package:lazyplants/components/lp_custom_text_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_plant_screen2.dart';
import 'package:get/get.dart';
import 'package:lazyplants/components/lp_custom_button.dart';

class AddPlantScreen1 extends StatelessWidget {
  AddPlantScreen1({
    Key key,
  }) : super(key: key);

  final Plant plant = Plant();

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
              "addPlant1_title".tr,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 20.0, left: 40.0, right: 40.0),
            child: Text(
              'addPlant1_body'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          TextButton(
            child: Text('addPlant1_helpText'.tr,
                style: TextStyle(
                    color: Colors.white.withAlpha(200), fontSize: 15)),
            onPressed: () async {
              var helpUrl = 'addPlant1_helpUrl'.tr;
              if (await canLaunch(helpUrl)) {
                await launch(helpUrl);
              } else {
                final snackBar =
                    SnackBar(content: Text('urlLaunchError'.tr + helpUrl));
                // Find the ScaffoldMessenger in the widget tree and use it to show a SnackBar.
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
          const SizedBox(height: 30),
          LP_CustomButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPlantScreen2(
                    plant: plant,
                  ),
                ),
              );
            },
            btnText: 'next'.tr,
            textKey: Key('nextButton'),
          ),
          LP_CustomTextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              btnText: 'cancel'.tr)
        ],
      ),
    );
  }
}
