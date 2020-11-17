#include "Arduino.h"
#include <Arduino.h>
#include <vector>
#include <WiFi.h>
#include <Arduino_JSON.h>
#include <HTTPClient.h>


bool connect(const char* ssid,const char* password){
    WiFi.begin(ssid, password);
    delay(500);
    Serial.println();
    Serial.print("Connecting to WiFi..");
    bool Stop = false;
    int counter =0;

    while ((WiFi.status() != WL_CONNECTED) && !(Stop)) {
      counter ++;
      delay(1000);
      Serial.print(".");
      if (counter == 8){
        Serial.println();
        WiFi.begin(ssid, password);
        delay(500);
      }
      if (counter >= 20){
        Stop = true;
        Serial.println();
        Serial.println("No Connection!!!");
        Serial.println("scan start");
        // WiFi.scanNetworks will return the number of networks found
        int n = WiFi.scanNetworks();
        Serial.println("scan done");
        if (n == 0) {
            Serial.println("no networks found");
        } else {
            Serial.print(n);
            Serial.println(" networks found: ");
            for (int i = 0; i < n; ++i) {
                // Print SSID and RSSI for each network found
                Serial.print(i + 1);
                Serial.print(": ");
                Serial.print(WiFi.SSID(i));
                Serial.print(" (");
                Serial.print(WiFi.RSSI(i));
                Serial.print(")");
                Serial.println((WiFi.encryptionType(i) == WIFI_AUTH_OPEN)?" ":"*");
                delay(10);
            }
        }
        //ESP.restart();
        return false;
      }
    }
    if (counter < 30){
      Serial.println();
      Serial.println("Connected to the WiFi network");
      Serial.println();
      return true;
    }
    

}

int patch_json(String ServerPath, JSONVar Message){
    // http://178.238.227.46:3000/api/plants_data?access_token=Fm8ctl15LypUYt6ICN6kA3M2BlVrwF9KCMijBPSfqAGtHMv220PAZSHvisDZxBq6 //POST
    // HTTP header
    // TEST
    HTTPClient http;
    //http.begin(ServerPath + "&filter[where][UserID]=1&filter[where][PlantID]=1");
    http.begin(ServerPath);
    http.addHeader("Content-Type", "application/json"); //Typ des Body auf json Format festlegen
    //int httpResponseCode = http.PATCH("{\"UserID\":\"1\",\"PlantID\":\"1\",\"water\":\"false\"}");
    String msg = JSON.stringify(Message);
    int httpResponseCode = http.PATCH(msg);
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);    
    
    http.end();
    return httpResponseCode;
  }

int post_json(String ServerPath, JSONVar Message){
    HTTPClient http;
    http.begin(ServerPath);
    http.addHeader("Content-Type", "application/json"); //Typ des Body auf json Format festlegen

    String msg = JSON.stringify(Message);
    int httpResponseCode = http.POST(msg);

    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);    
    
    http.end();
    return httpResponseCode;
}

JSONVar get_json(String ServerPath){
  //HTTP GET
  HTTPClient http;
  http.begin(ServerPath); //Startet Verbindung zu Server
  int httpResponseCode = http.GET();
  
  String payload = "{empty}"; 
  
  if (httpResponseCode>0) {
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);
    payload = http.getString();
  }
  else {
    Serial.print("Error code: ");
    Serial.println(httpResponseCode);
  }
  http.end(); // Free resources
  
  //Konvertieren in JSON Objekt
   JSONVar myObject = JSON.parse(payload);
  
  // JSON.typeof(jsonVar) can be used to get the type of the var
  if (JSON.typeof(myObject) == "undefined") {
    Serial.println("Parsing input failed! Retry..");
    JSONVar myObject = JSON.parse(payload);
  }
    
  Serial.print("JSON object = ");
  Serial.println(myObject);
    
  // myObject.keys() can be used to get an array of all the keys in the object
  JSONVar keys = myObject.keys();

  //Ausgabe
  for (int i = 0; i < keys.length(); i++) {
    JSONVar value = myObject[keys[i]];
    Serial.print(keys[i]);
    Serial.print(" = ");
    Serial.println(value);
  }
  return myObject;
}
