#include <Esp.h>
#include <Arduino.h>
#include "WiFi.h"
#include "DHT.h" //DHT Bibliothek laden

#define BodenfeuchtigkeitPIN 36
#define feuchtemin 0
#define feuchtemax 4095 // Erfahrungswert Arduino Reference sagt max. 4095  //TODO: kallibrieren
const char* ssid = "TrojaNet";
const char* pw = "50023282650157230429";
#define max_Retry 5
#define PumpePIN 33
#define dhtPIN 4
DHT dht(dhtPIN, DHT22);


void setup() {
    Serial.begin(115200);//Test
    delay(1000);
    dht.begin();
    wifi(ssid, pw);
    //WiFi.begin(ssid, pw);
}

bool wifi(const char* ssid,const char* password){
    bool Stop = false;
    int counter =0;
    
    if(WiFi.status() != WL_CONNECTED){
    WiFi.begin(ssid, password);
    delay(500);
    Serial.println();
    Serial.print("Connecting to WiFi..");    
    }else{
      Stop = true;
    }
    while ((WiFi.status() != WL_CONNECTED) && !(Stop)) {
      counter ++;
      delay(1000);
      Serial.print(".");
      if (counter == (max_Retry*2)){
        Serial.println();
        WiFi.begin(ssid, password);
        delay(500);
      }
      if (counter >= (max_Retry*4)){
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
                delay(1000);
            }
        }
        ESP.restart();
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

int bodenfeuchte(int PIN){
    int value = analogRead(PIN);
    Serial.print("Messwert: ");
    Serial.println(value);
    value = map(value, feuchtemax, feuchtemin, 0, 100); //Normierung
    Serial.print("Normwert: ");
    Serial.println(value);
    return value;
}

float luftfeuchtigkeit(){
  //dht.begin();
  float Luftfeuchtigkeit;
  int counter = 0;
  do{ 
    counter++;
    Luftfeuchtigkeit = dht.readHumidity(); // die Luftfeuchtigkeit auslesen und unter „Luftfeutchtigkeit“ speichern
    delay(500);
  }while(!(Luftfeuchtigkeit >= 0) && counter < 20);
  return Luftfeuchtigkeit;  
}

float temperatur(){  
  //dht.begin();
  float Temperatur;
  int counter = 0;
  do{ 
    counter++;
    Temperatur = dht.readTemperature(); // die Temperatur auslesen und unter „Temperatur“ speichern
    delay(500);
  }while(!(Temperatur >= 0) && counter < 20);
  return Temperatur;  
}

void loop() {    
    bodenfeuchte(BodenfeuchtigkeitPIN);
    Serial.print("Luft: ");
    Serial.println(luftfeuchtigkeit());
    Serial.print("Temperatur: ");
    Serial.println(temperatur());
    delay(2000);
}
