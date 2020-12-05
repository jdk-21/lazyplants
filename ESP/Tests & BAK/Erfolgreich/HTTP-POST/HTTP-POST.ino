#include "WiFi.h"
#include <HTTPClient.h>
//#include "Module.h"

String ipadresse = "178.238.227.46:3000";
String token = "cwapZ8RI3Y8HtK09S5P8RpAaVGUwLgjrlBuKj308rZgt8K0bGkMEizTjeGhuE3eZ";
String table = "waterplants";
String ServerPath = ("http://"+ipadresse+"/api/"+ table + "?access_token=" + token);
const char* ssid = "TrojaNet";
const char* password = "50023282650157230429";
 
int senden(){
    HTTPClient http;
    http.begin(ServerPath);
    http.addHeader("Content-Type", "application/json"); //Typ des Body auf json Format festlegen
    //int httpResponseCode = http.POST("{\"UserID\":\"1\",\"PlantID\":\"1\",\"water\":\"false\",\"date\":\"2020-11-16T10:54:25.035Z\"}");
    int httpResponseCode = http.POST("{\"UserID\":\"1\",\"PlantID\":\"1\",\"water\":\"false\"\"}");
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);    
    
    http.end();
    return httpResponseCode;
  }

void setup() {
  int counter = 0;
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

  counter = 0;
  Stop = false;
  int ResponseCode = senden();
  while ((ResponseCode < 0) && !(Stop)){
    counter ++;
    ResponseCode = senden();
    delay(500);
    if (counter >= 13){
      Stop = true;
    }
  }
}
 
void loop() {}
