import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazyplants/components/api_connector2.dart';
import 'package:lazyplants/screens/login/login_screen.dart';

import '../main.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 40.0, // soften the shadow
                      spreadRadius: 5.0, //extend the shadow
                      offset: Offset(
                        10.0, // Move to right 10  horizontally
                        10.0, // Move to bottom 10 Vertically
                      )),
                ],
              ),
              width: double.infinity,
              padding: EdgeInsets.all(20),
              //color: Theme.of(context).primaryColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 125,
                          margin: EdgeInsets.only(top: 30, bottom: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: CircleAvatar(
                                  backgroundImage: ExactAssetImage(
                                      "assets/images/avatar.jpg"),
                                  maxRadius: 35,
                                ),
                              ),
                              Text(
                                "John Hanley",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Lvl 21: Almost pro!",
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListTile(
                leading: Icon(Icons.house_outlined),
                title: Text(
                  "home".tr,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart_outlined),
              title: Text(
                "statistics".tr,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.wifi_tethering_outlined),
              title: Text(
                "howToConnect".tr,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text(
                "settings".tr,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: ListTile(
                leading: Icon(Icons.account_circle_outlined),
                title: Text(
                  "about".tr,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red[700],
              ),
              title: Text(
                "logout".tr,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              onTap: () async {
                Logout logout = new Logout();
                logout.setRequest(new PostRequest());
                if (await logout.request() == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('successfulLogout'.tr),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('somethingWrong'.tr),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
