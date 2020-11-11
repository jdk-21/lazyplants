#include "WiFi.h"
#include <HTTPClient.h>

String token = "cwapZ8RI3Y8HtK09S5P8RpAaVGUwLgjrlBuKj308rZgt8K0bGkMEizTjeGhuE3eZ";
String ServerPath = ("http://178.238.227.46:3000/api/Plant_Data?access_token="+token);
const char* ssid = "TrojaNet";
const char* password = "50023282650157230429";
 
int senden(){
    // http://178.238.227.46:3000/api/plants_data?access_token=Fm8ctl15LypUYt6ICN6kA3M2BlVrwF9KCMijBPSfqAGtHMv220PAZSHvisDZxBq6 //POST
    // HTTP header
    // TEST
    /*Dominik Klein, [01.11.20 17:25]
    {
      "name": "string",
      "date": "2020-11-01T16:20:25.756Z",
      "soil_moisture": 0,
      "humidity": 0,
      "temperature": 0,
      "watertank": 0,
      "id": "string"
    }*/
    HTTPClient http;
    http.begin(ServerPath);
    http.addHeader("Content-Type", "application/json"); //Typ des Body auf json Format festlegen
    int httpResponseCode = http.POST("{\"UserID\":\"2\",\"PlantID\":\"2\",\"Plantname\":\"ESP-Post-2\",\"date\":\"2020-11-11T10:54:25.035Z\"}");
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
