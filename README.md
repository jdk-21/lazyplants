# LazyPlants
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/e1dc68a8ab224306aff76362d67d6b62)](https://app.codacy.com/gh/jdk-21/lazyplants?utm_source=github.com&utm_medium=referral&utm_content=jdk-21/lazyplants&utm_campaign=Badge_Grade_Settings)
[![codecov](https://codecov.io/gh/jdk-21/lazyplants/branch/master/graph/badge.svg?token=U44AHOMHCS)](https://codecov.io/gh/jdk-21/lazyplants)

Our vision is to create an automatic plant watering system for all those that cant keep their plants alive because they’re too lazy to water them. With ‚LazyPlants‘ we want to save those sad, dried out plants. To give them back the joy of life, we want to develop a cost-effective solution.

## Documentation
Documenatation: [here](https://github.com/Kokoloris19097/LazyPlants.dokumentation) \
Blog: [here](https://lazysmartplants.wordpress.com/)

## Connecting the sensors
![](https://github.com/Kokoloris19097/LazyPlants.dokumentation/blob/c4ca5e9a913b361307ece8c8a2346931e1663eb6/assets/Schaltplan.jpg) \
The pin assignment can be adapted according to the ESP. However, the pin for the soil moisture sensor must be able to read an analogue signal. The pins for HC-SR04, DHT22 and the relay must be digitally controllable.

## Installation and adjustments of the ESP script
If everything has been wired exactly as shown in the wiring diagram, only the following changes need to be made in ESP.ino:
  -  Enter the **WiFi-SSID and password**
  ```cpp
  // WLAN
  const char* ssid = "yourSSID";
  const char* pw = "yourPW";
  ```
  -  Enter the **User-Name and the password**
  ```cpp
  String email = "your@email.com";
  String pw_API = "yourPassword";
  ```
  -  Enter a **unique espID** 
  ```cpp
  String espID = "yourEspId";
  ```
   -  Enter a **mesuring intervall**
   ```cpp
   #define IntervallTime 5
   ```
At the Module.h you have to cange the following thinks:
- the **timezone**, if you don't live at the UTC+2 _timezone
  ```
  const long utcOffsetInSeconds_winter = 3600; // Winterzeit in sek zur UTC Zeit
  const long utcOffsetInSeconds_summer = 7200; // Winterzeit in sek zur UTC Zei
  ```
- Indication of the minimum and maximum **tank level**. It is important to remember that the sensor measures the distance to the water surface. The first parameter is given in cm, the second is given as the fill level in percent.
  ```
  //weitere Parameter
  #define maxTankhoehe 30 //Angabe in cm bei denen der Sensor den Tank als leer erkennt
  #define minTanklevel 10 //Füllgrad in % b dem die Pumpe nicht mehr gießt
  ```

If you use **your own Backend** you have to cange the ServerPath and the Endpoint Names:

```
String baseUrl = "yourServerPath"; // Pfad zum Backend
String login_table = "user/login"; // Stelle an der sich der ESP bei der API einloggen muss
String tablePlant = "plant"; // Stelle an der sich der ESP die Pflanze holen kann
String tableDB = "data"; // Stelle an der ESP die Pflanzen Datensätze posten soll
```

If you have not wired the sensors and the relay as shown in the plan, you must adjust the pin assignment at the Module.h.
```
// PINs
#define ultraschalltrigger 34 // Pin an HC-SR04 Trig
#define ultraschallecho 35    // Pin an HC-SR04 Echo
#define BodenfeuchtigkeitPIN 33
#define PumpePIN 26
#define dhtPIN 23
#define dhtType DHT22
DHT dht(dhtPIN, dhtType);
```


Once you have made the specified changes, you can load the ESP.ino and Module.h onto your ESP. The debugging information is displayed via the serial monitor.
If you have not wired the sensors and the relay as shown in the plan, you must adjust the pin assignment.
