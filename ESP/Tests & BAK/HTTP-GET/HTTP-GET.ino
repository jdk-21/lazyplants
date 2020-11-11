#include "WiFi.h"
#include <HTTPClient.h>
#include <Arduino_JSON.h>

String ipadresse = "178.238.227.46:3000";
String token = "cwapZ8RI3Y8HtK09S5P8RpAaVGUwLgjrlBuKj308rZgt8K0bGkMEizTjeGhuE3eZ";
String table = "waterplants";
String ServerPath = ("http://"+ipadresse+"/api/"+ table + "?access_token=" + token);
const char* ssid = "TrojaNet";
const char* password = "50023282650157230429";

int counter = 0;
 
void setup() { 
  bool Stop = false;
  
  Serial.begin(9600);
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
    Serial.println("Connected to the WiFi network");
  }
  Serial.println();
}
 
void loop() {
  HTTPClient http;
  http.begin(ServerPath);
  counter ++;
  int ResponseCode =  http.GET();
  
  if (ResponseCode>0) {
    Serial.print("HTTP Response code: ");
    Serial.println(ResponseCode);
    String payload = http.getString();
    http.end();
    JSONVar myObject = JSON.parse(payload);
  
      // JSON.typeof(jsonVar) can be used to get the type of the var
      if (JSON.typeof(myObject) == "undefined") {
        Serial.println("Parsing input failed!");
        return;
      }
    
      Serial.print("JSON object = ");
      Serial.println(myObject);
    
      // myObject.keys() can be used to get an array of all the keys in the object
      JSONVar keys = myObject.keys();
    
      for (int i = 0; i < keys.length(); i++) {
        JSONVar value = myObject[keys[i]];
        Serial.print(keys[i]);
        Serial.print(" = ");
        Serial.println(value);
      }
  
  } 
  else {
    Serial.print("Error code: ");
    Serial.println(ResponseCode);
  }  
  delay(5000);
  if (counter >= 5){
    Serial.println("END");
    //http.end();
    exit;
  }
}
