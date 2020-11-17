#include <Arduino.h>
#include <Esp.h>
#include "Esp.h"
#include <WiFi.h>


bool connect(const char* ssid,const char* password){
    WiFi.begin(ssid, password);
    delay(300);
    Serial.println();
    Serial.print("Connecting to WiFi..");
    bool Stop = false;
    int counter =0;

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
    //int httpResponseCode = http.POST("{\"UserID\":\"1\",\"PlantID\":\"1\",\"water\":\"false\",\"date\":\"2020-11-16T10:54:25.035Z\"}");
    int httpResponseCode = http.POST("{\"UserID\":\"1\",\"PlantID\":\"1\",\"water\":\"false\"\"}");
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);    
    
    http.end();
    return httpResponseCode;
  }