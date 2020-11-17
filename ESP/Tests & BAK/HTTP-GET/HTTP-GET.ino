/* Name: Steuerung Test
 * Projekt: LazyPlants
 * Erstelldatum:  10.11.2020 18:00
 * Änderungsdatum: 16.11.2020 16:30
 * Version: 0.0.3
 * History:
 */


#include "WiFi.h"
#include <HTTPClient.h>
#include <Arduino_JSON.h>
#include <String>

#define max_n_Value 4

String ipadresse = "178.238.227.46:3000";
String token = "cwapZ8RI3Y8HtK09S5P8RpAaVGUwLgjrlBuKj308rZgt8K0bGkMEizTjeGhuE3eZ";
String table = "waterplants";
String ServerPath = ("http://"+ipadresse+"/api/"+ table + "?access_token=" + token);
const char* ssid = "TrojaNet";
const char* password = "50023282650157230429";

int counter = 0;
 
void setup() { 
  bool Stop = false;
  
  Serial.begin(115200);
  delay(500);
  WiFi.begin(ssid, password);
  delay(300);
  Serial.println();
  Serial.print("Connecting to WiFi..");
  while ((WiFi.status() != WL_CONNECTED) && !(Stop)) {
    counter ++;
    delay(1000);
    Serial.print(".");
    if (counter == 15){
      Serial.println();
    }
    if (counter >= 40){
      Stop = true;
      Serial.println();
      Serial.println("No Connection!!!");
      Serial.println("Reboot..");
      ESP.restart();
    }
  }
  if (counter < 30){
    Serial.println();
    Serial.println("Connected to the WiFi network!");
  }
  Serial.println();
}
 
void loop() {
  HTTPClient http;
  http.begin(ServerPath + "&filter[where][UserID]=1&filter[where][PlantID]=1");
  counter ++;
  int ResponseCode =  http.GET();
  
  if (ResponseCode>0) {
    Serial.print("HTTP Response code: ");
    Serial.println(ResponseCode);
    String payload = http.getString();
    http.end();
    Serial.println(payload);
    Serial.println();
    
    String Teilung[max_n_Value][2] = {};
    int Anzahl_Komma = 0;
    int Anzahl_Doppelpunkte = 0;
    
    for(int i=0; i < payload.length(); i++){
      if (payload[i] == ','){
        Anzahl_Komma++;
        Anzahl_Doppelpunkte = 0;
      } 
      else if(payload[i] == ':'){
        Anzahl_Doppelpunkte = 1;
      }
      else {
        Teilung[Anzahl_Komma][Anzahl_Doppelpunkte] = Teilung[Anzahl_Komma][Anzahl_Doppelpunkte] + payload[i];
      }
    }
    // Klammern löschen
    Teilung[0][0].remove(0,2);
    Teilung[Anzahl_Komma][1].remove((Teilung[Anzahl_Komma][1].length()-2),2);

    //Ausgabe
    for (int i=0; i < max_n_Value; i++){
      Serial.print(i);
      Serial.print(": ");
      Serial.print(Teilung[i][0]);
      Serial.print("; ");
      Serial.println(Teilung[i][1]);
    }
    Serial.println();
  } 
  else {
    Serial.print("Error code: ");
    Serial.println(ResponseCode);
  }  
  delay(5000);
  if (counter >= 5){
    Serial.println("END");
  }
}
