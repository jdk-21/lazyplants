//Include

#include "Module.h"
//#define axyz 32 //14 Funktioniert ohne WLAN
const char* ssid = "TrojaNet";
const char* pw = "50023282650157230429";

void setup() {
  Serial.begin(115200);
  delay(500);
  pinMode(ultraschalltrigger, OUTPUT);
  pinMode(ultraschallecho, INPUT);
  pinMode(BodenfeuchtigkeitPIN, INPUT);
  //pinMode(axyz, INPUT);
  delay(1000);
  
  
}

void loop() {
// Messwerte erfassen
  delay(2000);
  int temp = temperatur();
  Serial.print("Temperatur: "); Serial.print(temp); Serial.println("°C");
  delay(500);
  int level = entfernung();
  Serial.print("Entfernung: "); Serial.print(level); Serial.println("cm");
  delay(2000);
  int Tanklevel = fuellsstand();
  Serial.print("Tankfüllung: "); Serial.print(Tanklevel); Serial.println("%");
  delay(500);
  int soilMoisture = bodenfeuchte(BodenfeuchtigkeitPIN);
  Serial.print("Bodenfeuchte: "); Serial.print(soilMoisture); Serial.println("%");
  int humidity = luftfeuchtigkeit();
  delay(500);
  Serial.print("Luftfeuchte: "); Serial.print(humidity); Serial.println("%");
  Serial.println();
  connect(ssid, pw); //WLAN Verbindung einrichten  
}
