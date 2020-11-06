/* Name: Test DHT22
 * Projekt: LazyPlants
 * Erstelldatum:  01.11.2020 18:00
 * Änderungsdatum: 01.11.2020 18:00
 * Version: 0.0.1
 * History:
 */


//Include
#include "DHT.h"

  //Sensoren
  #define DHTPIN 4 // Datapin für den DHT22
  #define DHT_TYPTE DHT22 //Typ von DHT
  DHT dht(DHTPIN, DHT_TYPTE);

//SETUP 
void setup() {
  dht.begin();
  Serial.begin(9600);//Test
}

// Funktionen
 
  float Luftfeuchtigkeit(){
    return dht.readHumidity();
  }
  
  float Temperatur(){
    return dht.readTemperature();
  }
  
//Main
void loop() {
  Serial.print("Luftfeuchte: ");
  Serial.println(Luftfeuchtigkeit());
  Serial.print("Temperatur: ");
  Serial.println(Temperatur());
  delay(5000);
  Serial.println(" ");
}
