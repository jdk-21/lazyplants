/* Name: Steuerung ESP
 * Projekt: LazyPlants
 * Erstelldatum:  01.11.2020 18:00
 * Änderungsdatum: 22.11.2020 16:00
 * Version: 0.1.0
 * History:
 */


//Include
#include "Module.h"

#include <Preferences.h>
#include "DHT.h" //DHT Bibliothek laden
#include <WiFi.h>
#include <Arduino_JSON.h>
#include <HTTPClient.h>


// Declarationen
// Connections
String ipadresse = "178.238.227.46:3000";
String token = "cwapZ8RI3Y8HtK09S5P8RpAaVGUwLgjrlBuKj308rZgt8K0bGkMEizTjeGhuE3eZ";
String table = "waterplants";
String id = "/5fb3804d76949e054eeae501";
String filter = ""; //z.B. &filter[where][UserID]=1&filter[where][PlantID]=1
String ServerPath = ("http://"+ipadresse+"/api/"+ table + id + "?access_token=" + token + filter); // http://178.238.227.46:3000/api/waterplants/5fb3804d76949e054eeae501?access_token=cwapZ8RI3Y8HtK09S5P8RpAaVGUwLgjrlBuKj308rZgt8K0bGkMEizTjeGhuE3eZ
const char* ssid = "TrojaNet";
const char* pw = "50023282650157230429";

// PINS
#define ultraschalltrigger 34 // Pin an HC-SR04 Trig
#define ultraschallecho 35    // Pin an HC-SR04 Echo
#define BodenfeuchtigkeitPIN 12
#define PumpePIN 17
#define dhtPIN 23

// Umgebungs variablen
#define Relai_Schaltpunkt LOW // definition on Relai bei HIGH oder LOW schaltet
const int feuchtemin = 0;
const int feuchtemax = 3571; // Erfahrungswert, Arduino Reference sagt max. Wert bei 4095  //TODO: kallibrieren
const int max_Tankhoehe = 30 //Angabe in cm bei denen der Sensor den Tank als leer erkennt
Preferences preferences; // Permanentes Speichern von Variablen

void setup() {
  pinMode(ultraschalltrigger, OUTPUT);
  pinMode(ultraschallecho, INPUT);
  pinMode(PumpePIN, OUTPUT);
  Serial.begin(115200);
  connect(ssid, pw);
  JSONVar Datensatz = get_json(ServerPath);


}

void loop() {
  

}