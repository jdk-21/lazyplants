/* Name: Steuerung ESP
 * Projekt: LazyPlants
 * Erstelldatum:  01.11.2020 18:00
 * Änderungsdatum: 01.11.2020 18:00
 * Version: 0.0.1
 * History:
 */

//Include
#include <DHT.h>
#include <Esp32WifiManager.h>
#include <WiFi.h>
#include <WiFiClient.h>
#include <WiFiServer.h>
#include <WiFiUdp.h>

//Declarationen

const char* ssid = "TrojaNet"
const char* passwort = ""
#define feuchtigkeitPin A0
#define ultraschalltrigger 3 // Arduino Pin an HC-SR04 Trig
#define ultraschallecho 2    // Arduino Pin an HC-SR04 Echo
#define feuchtemax 343 //bei 100% Wasser (Bodenfeuchte)
#define feuchtemin 664 //bei 0% Wasser (Bodenfeuchte)
#define DHTPIN 8 // Datapin für den DHT22
#define PumpePin 5 //Anschluss für das Pumpenrelai
#define Relai_Schaltpunkt Low //Relai schaltet bei Low/Hight durch
#define Tankhoehe 30 //Angabe in cm bei denen der Sensor den Tank als leer erkennt

#define optimalefeuchte 60 //in %
bool giese = 0


void setup() {
  pinMode(ultraschalltrigger, OUTPUT);
  pinMode(ultraschallecho, INPUT);
  pinMode(PumpePin, OUTPUT);
  dht.begin();
  Serial.begin(9600);//Test

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED){
    delay(1000)
    Serial.println("WLAN Verbinden..");
  }
  Serial.println("WLAN Verbunden!");
}

// Funktionen
int Bodenfeuchtigkeit() {
  int sensorValue=0;
  sensorValue = analogRead(feuchtigkeitPin);
  sensorValue = -((sensorValue - feuchtemin)/feuchtemax * 100);  //für 3,3V am Feuchtigkeitssensor (nicht kapazentiv)
  //sensorValue = sensorValue * 100 / 1023; // Umrechnung in %
  return(sensorValue);
}

int Luftfeuchtigkeit(){
  return dht.readHumidity();
}

int Temperatur(){
  return dht.readTemperature();
}
int entfernung(){
  long entfernung=0;
  long zeit=0;

  digitalWrite(ultraschalltrigger, LOW);
  delayMicroseconds(3);
  noInterrupts();
  digitalWrite(ultraschalltrigger, HIGH); //Trigger Impuls 10 us
  delayMicroseconds(10);
  digitalWrite(ultraschalltrigger, LOW);
  zeit = pulseIn(ultraschallecho, HIGH); // Echo-Zeit messen
  interrupts();
  zeit = (zeit/2); // Zeit halbieren
  entfernung = zeit / 29.1; // Zeit in Zentimeter umrechnen
  return(entfernung);
}

int 

void giesen(){
  int feuchtigkeit = Bodenfeuchtigkeit();
  while (feuchtigkeit < optimalefeuchte){ 
    int feuchtigkeit = Bodenfeuchtigkeit();
    digitalWrite(PumpePin,Relai_Schaltpunkt);//Punpe einschalten
    delay(1000); //Wartezeit 1s
    digitalWrite(PumpePin,!Relai_Schaltpunkt);//Pumpe ausschalten
  }
}

int fuellsstand(){
  int Value = entfernung();
  return (Value/Tankhoehe *100);
}

//Main
void loop() {
  delay(3000);
  Serial.println("Feuchte:");
  Serial.println(Bodenfeuchtigkeit());
  Serial.println("Entfernung:");
  Serial.println(entfernung());
}
