/* Name: Steuerung Test
 * Projekt: LazyPlants
 * Erstelldatum:  10.11.2020 18:00
 * Änderungsdatum: 16.11.2020 16:30
 * Version: 0.0.3
 * History:
 */


#include "Module.h"
#include <WiFi.h>
#include <HTTPClient.h>
#include <Arduino_JSON.h>
#include <String>

#define max_n_Value 4

String ipadresse = "178.238.227.46:3000";
String token = "cwapZ8RI3Y8HtK09S5P8RpAaVGUwLgjrlBuKj308rZgt8K0bGkMEizTjeGhuE3eZ";
String table = "waterplants";
String id = "/5fb3804d76949e054eeae501";
//String filter = "&filter[where][UserID]=1&filter[where][PlantID]=1"; //z.B. &filter[where][UserID]=1&filter[where][PlantID]=1
String filter = "";
String ServerPath = ("http://"+ipadresse+"/api/"+ table + id + "?access_token=" + token + filter);
const char* ssid = "TrojaNet";
const char* password = "50023282650157230429";

void setup() {
  Serial.begin(115200);
  connect(ssid, password);
}

void loop() {
  JSONVar J = get_json(ServerPath);
  delay(10000);
}
