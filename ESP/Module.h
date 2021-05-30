/* Name: Module ESP
 * Projekt: LazyPlants
 * Erstelldatum:  15.11.2020 18:00
 * Änderungsdatum: 28.05.2021 13:00
 * Version: 0.1.0
 * History:
 */

#include "WiFi.h" // Verbinden mit dem WLAN (Bibliothek: Arduino Uno WiFi Dev Ed Library)
#include "DHT.h" //DHT Bibliothek laden
#include <Arduino.h>
#include <Arduino_JSON.h> // Erstellen von JSON Objekten (Bibliothek: Arduino_JSON )
#include <HTTPClient.h> // HTTP Requests (Bibliothek: ArduinoHttpClient )
#include <NTPClient.h> // Zeit abfrage (Bibliothek: NTPClient)
#include <WiFiUdp.h> // gehötz zur Zeitabfrage
#include <time.h> 

// PINs
#define ultraschalltrigger 34 // Pin an HC-SR04 Trig
#define ultraschallecho 35    // Pin an HC-SR04 Echo
#define BodenfeuchtigkeitPIN 39
#define PumpePIN 26
#define dhtPIN 23
#define dhtType DHT22
DHT dht(dhtPIN, dhtType);

// Umfeld
#define Relai_Schaltpunkt LOW // definition on Relai bei HIGH oder LOW schaltet

// Connection
const long utcOffsetInSeconds_winter = 3600; // Winterzeit in sek zur UTC Zeit
const long utcOffsetInSeconds_summer = 7200; // Winterzeit in sek zur UTC Zeit
const String baseUrl = "https://api.kie.one/";
RTC_DATA_ATTR String token = "";
String login_table = "user/login"; // zum Anmelden an der API
String tablePlant = "plant"; // Pflanze
String tableDB = "data"; // Pflanzen Datensätze
#define max_Retry 5

// Constanten
const int feuchtemin = 0;
const int feuchtemax = 4095; //Normierung des Analogwerts

//weitere Parameter
#define maxTankhoehe 30 //Angabe in cm bei denen der Sensor den Tank als leer erkennt
#define minTanklevel 10 //Füllgrad in % b dem die Pumpe nicht mehr gießt

//Connections
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

String translate(int rCode, String msg){
  //JSONVar body = JSON.parse(msg);  
  String f_msg = "";
  f_msg += rCode;
  if (f_msg == ""){
    rCode =0;
    f_msg += rCode;
  }
  switch (rCode)
  {
  case 100:
    f_msg += " Continue";
    break;
  case 101:
    f_msg += " Switching Protocols";
    break;
  case 102:
    f_msg += " Processing ";
    break;
  case 103:
    f_msg += " Early Hints ";
    break;
  case 200:
    f_msg += " OK ";
    break;
  case 201:
    f_msg += " Created";
    break;
  case 202:
    f_msg += " Accepted";
    break;
  // Fehlend 203 bis 226 
  case 300:
    f_msg += " Multiple Choices";
    break;
  // Fehlend 301 bis 308
  case 400:
    f_msg += " Bad Request";
    break;
  case 401:
    f_msg += " Unauthorized";
    break;
  case 403:
    f_msg += " Forbidden";
    break;
  case 404:
    f_msg += " Not Found";
    break;
  // Fehlend ab 405
  default:
    f_msg += " " + msg; 
    break;
  }
  return f_msg;
}

void login(String email, String pw){
  //Bereit für Loobback4
  JSONVar answer;
  String body;
  String Ans;
  int ResponseCode;
  int counter = 0;

  String ServerPath_login = baseUrl+ login_table;
  body = "{\"email\":\""+ email +"\", \"password\":\""+ pw +"\"}";

  HTTPClient http;
  http.begin(ServerPath_login);
  http.addHeader("accept", "application/json");
  http.addHeader("Content-Type", "application/json"); // Typ des Body auf json Format festlegen
  Serial.println();
  Serial.print("Login: ");
  Serial.println(body);  
  do{
    ResponseCode = http.POST(body);
    counter++;
    Serial.print("HTTP Response code: ");
    Ans = http.getString();
    Serial.println(translate(ResponseCode, Ans));
    if (ResponseCode != 200){ // Auswertung ob Verbindung ustande kam
      Serial.print("Login failed! ");
      Serial.println(counter);
      Serial.println(Ans);
      delay(1000);
    }    
  }while(ResponseCode != 200 && counter <= max_Retry); // retry bis Verbndung Zustande kommt oder 5 Versucher erreicht sind
  
  answer = JSON.parse(Ans);
  Ans = answer["token"];
  Serial.print("Token: ");
  Serial.println(Ans);
  token = "Bearer " + Ans;
  http.end();
}

int post_json_int(String ServerPath, JSONVar Message){
    // noch nicht auf Loobback4
    // HTTP-POST
    // Anlegen eines neuen Datensatzes in der Datenbank (ServerPath). Der Inhalt ist im JSON Objekt enthalten.
    // Das JSON Objekt wird in einen String umgewandelt und als Body des HTTP Requests übertragen.

    HTTPClient http;
    http.begin(ServerPath);
    http.addHeader("accept", "application/json");
    http.addHeader("Authorization", token);
    http.addHeader("Content-Type", "application/json"); // Typ des Body auf json Format festlegen

    Serial.println();
    Serial.println("POST:");
  
    String msg = JSON.stringify(Message); // konvertieren des JSON Objekts in einen String
    int httpResponseCode = http.POST(msg); // Übertragung

    Serial.print("HTTP Response code: ");
    String Ans = http.getString();
    Serial.println(translate(httpResponseCode, Ans));     
    
    http.end();
    return httpResponseCode;
}

JSONVar post_json_json(String ServerPath, JSONVar Message){
  // bereit für Loobback4
  // HTTP-POST
  // Anlegen eines neuen Datensatzes in der Datenbank (ServerPath). Der Inhalt ist im JSON Objekt enthalten.
  // Das JSON Objekt wird in einen String umgewandelt und als Body des HTTP Requests übertragen.

  JSONVar Data;
  HTTPClient http;
  String Ans;
  http.begin(ServerPath);
  http.addHeader("accept", "application/json");
  http.addHeader("Authorization", token);
  http.addHeader("Content-Type", "application/json"); // Typ des Body auf json Format festlegen

  Serial.println();
  Serial.println("POST:");
  
  String msg = JSON.stringify(Message); // konvertieren des JSON Objekts in einen String
  int httpResponseCode = http.POST(msg); // Übertragung
  msg = http.getString();
  Serial.print("HTTP Response code: ");
  Serial.println(translate(httpResponseCode, msg));    

  if (httpResponseCode != 200){
    msg = "{}";
  }
  
  Data = JSON.parse(msg);

  http.end();
  return Data;
}

JSONVar get_json(String ServerPath){
  // bereit für Loobback4
  // HTTP GET
  // Abrufen eines Datensatzes (id muss in URL hinterlegt sein) im JSON Format
  // zum Debugging wird der Datensatz und das JSON objekt auf dne Seriellen Monitor übertragen
  // Return das den Datensatz als JSON Objekt

  HTTPClient http;
  http.begin(ServerPath); //Startet Verbindung zu Server
  http.addHeader("accept", "application/json");
  http.addHeader("Authorization", token);
  http.addHeader("Content-Type", "application/json"); // Typ des Body auf json Format festlegen
  int httpResponseCode = http.GET();
  Serial.println();
  Serial.println("GET:");
  String payload = "{empty}"; 
  
  if (httpResponseCode > 0) {
    Serial.print("HTTP Response code: ");
    String Ans = http.getString();
    Serial.println(translate(httpResponseCode, Ans));
    if (httpResponseCode == 200){
      payload = Ans;
      if (payload[0] == '[') {
        payload.remove(0,1);
      }
      if (payload[(payload.length()-1)] == ']'){
        payload.remove((payload.length()-1),1);
      }
    } else{
      payload = "{}"; // leeres JSON Objekt im Fehlerfall
    }
    
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
    
  // myObject.keys() can be used to get an array of all the keys in the object
  JSONVar keys = myObject.keys();

  //Ausgabe
  for (int i = 0; i < keys.length(); i++) {
    JSONVar value = myObject[keys[i]];
    Serial.print(keys[i]);
    Serial.print(" = ");
    Serial.println(value);
  }
  Serial.println();
  return myObject;
}


//Sensoren
int entfernung(){
    // Ermittlung der Entfernung zwischen Ultraschallsensor und Objekt.
    // Berechnung erfolgt auf Basis der Schallgeschwindigkeit bei einer Lufttemperatur von 20°C (daher der Wert 29,1)
    long entfernung=0;
    long zeit=0;
    int counter=0;
    do{
      counter++;
      digitalWrite(ultraschalltrigger, LOW);
      delayMicroseconds(3);
      noInterrupts();
      digitalWrite(ultraschalltrigger, HIGH); //Trigger Impuls 10 us
      delayMicroseconds(10);
      digitalWrite(ultraschalltrigger, LOW);
      zeit = pulseIn(ultraschallecho, HIGH); // Echo-Zeit messen
      interrupts();
      zeit = (zeit/2); // Zeit halbieren, da der SChall den Weg hin und zurück überwindet
      entfernung = zeit / 29.1; // Zeit in Zentimeter umrechnen
    }while(entfernung  == 0 && counter < max_Retry);
    return(entfernung);
  }
  
int fuellsstand(){
  // Berechnung des Füllstandes des Tanks Aufgrund der Tankhöhe und der Entfernung zwischen Sensor und Wasseroberfläche. Angabe in %.
  int Tankhoehe = maxTankhoehe;
  int value = entfernung();
  value = value * 100 / Tankhoehe;
  if (value <= minTanklevel){
    value = 0; // Sicherheitsspielraum für die Pumpe
  }
  return (value);
}

int bodenfeuchte(){
  // Berechnung der Bodenfeuchtigkeit in %, der Wert wird aus der Max. Feuchtigkeit und dem kapazitiven Bodenfeuchtigkeitssensor berechnet.
  // Der Normierte Wert wird in % angegeben.
  int value = analogRead(BodenfeuchtigkeitPIN);
  Serial.print("Bodenfeuchte Messwert: ");
  Serial.println(value);
  value = (((value - feuchtemin) *100) /feuchtemax);
  //Serial.println(value);
  return value;
}

float luftfeuchtigkeit(){
  dht.begin();
  float Luftfeuchtigkeit = dht.readHumidity(); // die Luftfeuchtigkeit auslesen und unter „Luftfeutchtigkeit“ speichern
  return Luftfeuchtigkeit;  
}

float temperatur(){
  dht.begin();
  float Temperatur = dht.readTemperature(); // die Temperatur auslesen und unter „Temperatur“ speichern
  return Temperatur;  
}


//Aktoren
void pumpen(bool pumpe, int PIN = PumpePIN){
  // je nach bool pumpe wird die Pumpe an (true) oder aus (false) geschaltet, die Logik ist "negiert" da das Relai bei einem Low schaltet
  // Dynamische Bestimmung der Schaltzustände anhand des Relais_Schaltpunkts
  if (pumpe){
    digitalWrite(PIN, Relai_Schaltpunkt);
    Serial.println("ON");
  } else {
    if (Relai_Schaltpunkt == LOW){
        digitalWrite(PIN, HIGH);
    } else {
      digitalWrite(PIN, LOW);
    }
    
    Serial.println("OFF");
  }
}

void giesen(int Feuchtigkeitswert){
  int feuchteAktuell = bodenfeuchte();
  const int kurz_giesen = 3000; // Wert für kurz giesen in ms, bei geringem Wasserbedarf
  const int lange_giesen = 4000; // Wert fürs lange giesen in ms, bei hohem Wasserbedarf
  const int wartezeit = 3000; // Wartezeit, damit das Wasser ein wenig einsickern kann bevor der Sensor erneut misst.
  bool ok = false;

  if (fuellsstand() > minTanklevel){
    ok = true;
  }
  if (feuchteAktuell >= Feuchtigkeitswert && ok){
    Serial.print("Boden feucht genug. Wert: ");
    Serial.print(feuchteAktuell);
    Serial.println("%");
    return;
  } else if (feuchteAktuell <= (Feuchtigkeitswert / 2) && ok) { // Hoher Wasserbedarf
    Serial.println("Lange gießen.");
    pumpen(true);
    delay(lange_giesen);
    pumpen(false);
  } else if (feuchteAktuell < Feuchtigkeitswert && ok){
    Serial.println("Kurz gießen.");
    pumpen(true);
    delay(kurz_giesen);
    pumpen(false);
  }
}
