#include "Arduino.h"
#include <Arduino.h>
#include <vector>
#include <WiFi.h>
#include <Arduino_JSON.h>


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

/*
String converte_AtoJ(String Message[][2], int length_Message){
  //msg zusammenbauen im JSON Format ("{\"UserID\":\"1\",\"PlantID\":\"1\",\"water\":\"false\"\"}")
  String msg = "{";
  for (int i=0;i < length_Message; i++){
    msg = msg + "\"" + Message[i][0] + "\":\"" + Message[i][1] +"\",";
  }
  msg.remove(msg.length()-1); //löschen des letzten ',' da kein weiterer Parameter kommt
  msg = msg + "}";
  return msg;
}

int senden(String ServerPath, String Message[][2],int length_Message){
    HTTPClient http;
    http.begin(ServerPath);
    http.addHeader("Content-Type", "application/json"); //Typ des Body auf json Format festlegen

    int httpResponseCode = http.POST(converte_AtoJ(Message[][2], length_Message));

    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);    
    
    http.end();
    return httpResponseCode;
  }
  */