/* Name: Module ESP
 * Projekt: LazyPlants
 * Erstelldatum:  15.11.2020 18:00
 * Änderungsdatum: 25.11.2020 16:00
 * Version: 0.0.5
 * History:
 */

#include <WiFi.h> // Verbinden mit dem WLAN (Bibliothek: Arduino Uno WiFi Dev Ed Library)
#include "DHT.h" //DHT Bibliothek laden
#include <Arduino_JSON.h> // Erstellen von JSON Objekten (Bibliothek: Arduino_JSON )
#include <HTTPClient.h> // HTTP Requests (Bibliothek: ArduinoHttpClient )
#include <NTPClient.h> // Zeit abfrage (Bibliothek: NTPClient)
#include <WiFiUdp.h> // gehötz zur Zeitabfrage
#include <time.h> 

// PINs
#define ultraschalltrigger 34 // Pin an HC-SR04 Trig
#define ultraschallecho 35    // Pin an HC-SR04 Echo
#define BodenfeuchtigkeitPIN 12
#define PumpePIN 17
#define dhtPIN 23
#define dhtType DHT22
DHT dht(dhtPIN, dhtType);

// Umfeld
#define Relai_Schaltpunkt LOW // definition on Relai bei HIGH oder LOW schaltet

// Connection
const long utcOffsetInSeconds_winter = 3600; // Winterzeit in sek zur UTC Zeit
const long utcOffsetInSeconds_summer = 7200; // Winterzeit in sek zur UTC Zeit
String login_table = "Members"; // zum Anmelden an der API
const String ipadresse = "178.238.227.46:3000"; // IP ADresse des Servers
#define max_Retry 5


// Constanten
const int feuchtemin = 0;
const int feuchtemax = 4095; //Normierung des Analogwerts

//weitere Parameter
#define maxTankhoehe 30 //Angabe in cm bei denen der Sensor den Tank als leer erkennt
#define minTanklevel 10 //Füllgrad in % b dem die Pumpe nicht mehr gießt

/*
void setup() {
  pinMode(ultraschalltrigger, OUTPUT);
  pinMode(ultraschallecho, INPUT);
  pinMode(PumpePIN, OUTPUT);
  Serial.begin(115200);
}
*/

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

String translate(int ResponseCode){
  String f_msg ;
  switch (ResponseCode)
  {
  case 100:
    f_msg = "100: Continue";
    break;
  case 101:
    f_msg = "101: Switching Protocols";
    break;
  case 102:
    f_msg = "102: Processing ";
    break;
  case 103:
    f_msg = "103: Early Hints ";
    break;
  case 200:
    f_msg = "200: OK ";
    break;
  case 201:
    f_msg = "201: Created";
    break;
  case 202:
    f_msg = "202: Accepted";
    break;
  // Fehlend 203 bis 226 
  case 300:
    f_msg = "300: Multiple Choices";
    break;
  // Fehlend 301 bis 308
  case 400:
    f_msg = "400: Bad Request";
    break;
  case 401:
    f_msg = "401: Unauthorized";
    break;
  case 403:
    f_msg = "403: Forbidden";
    break;
  case 404:
    f_msg = "404: Not Found";
    break;
  // Fehlend ab 405
  default:
    f_msg = ResponseCode +": unknown"; 
    break;
  }
  Serial.println(f_msg);
  return f_msg;
}

JSONVar login(String email, String pw){
  JSONVar answer;
  String msg;
  String Ans;
  int ResponseCode;
  int counter = 0;

  String ServerPath_login = ("http://"+ ipadresse +"/api/"+ login_table +"/login?");
  msg = "{\"email\":\""+ email +"\",\"password\":\""+ pw +"\"}";

  HTTPClient http;
  http.begin(ServerPath_login);
  http.addHeader("Content-Type", "application/json"); // Typ des Body auf json Format festlegen

  do{
    ResponseCode = http.POST(msg);
    counter++;
    Serial.print("HTTP Response code: ");
    translate(ResponseCode);
    if (ResponseCode != 200){ // Auswertung ob Verbindung ustande kam
    Serial.print("Login failed! ");
    Serial.println(counter);
    delay(1000);
    }
  }while (ResponseCode != 200 && counter <= max_Retry); // retry bis Verbndung Zustande kommt oder 5 Versucher erreicht sind
  
  Ans = http.getString();
  answer = JSON.parse(Ans);
  http.end();
  return answer;
}

int patch_json(String ServerPath, JSONVar Message){
    // HTTP-PATCH
    // Überschreibt den Inhalt eines Datensatzes. 
    // Wichtig! Der Datensatz muss komplett im JSON Objekt hinterlegt sein nicht nur der zu ändernde Teil und es dürfen keine Undefinierten Inhalte enthalten sein (Errorcode: 402).
    
    HTTPClient http;
    http.begin(ServerPath);
    http.addHeader("Content-Type", "application/json"); //Typ des Body auf json Format festlegen
    String msg = JSON.stringify(Message); //konvertieren des JSON Objekts in einen String
    int httpResponseCode = http.PATCH(msg); // Übertragung
    Serial.print("HTTP Response code: ");
    translate(httpResponseCode);   
    
    http.end();
    return httpResponseCode;
  }

int put_json(String ServerPath, JSONVar Message){
    // HTTP-PUT
    // Ändern eines Datensatzes (Server Path). Der Inhalt ist im JSON Objekt enthalten.
    // Das JSON Objekt wird in einen String umgewandelt und als Body des HTTP Requests übertragen.
    // Nicht Definierte Inhalte des DAtensatzes werden neu angelegt. Sollte kein Datensatz vorhanden sein der zum ServerPAth passt wird dieser neue angelegt.

    HTTPClient http;
    http.begin(ServerPath);
    http.addHeader("Content-Type", "application/json"); //Typ des Body auf json Format festlegen
    String msg = JSON.stringify(Message); // konvertieren des JSON Objekts in einen String
    int httpResponseCode = http.PUT(msg); // Übertragung
    Serial.print("HTTP Response code: ");
    translate(httpResponseCode);     
    
    http.end();
    return httpResponseCode;
  }

int post_json_int(String ServerPath, JSONVar Message){
    // HTTP-POST
    // Anlegen eines neuen Datensatzes in der Datenbank (ServerPath). Der Inhalt ist im JSON Objekt enthalten.
    // Das JSON Objekt wird in einen String umgewandelt und als Body des HTTP Requests übertragen.

    HTTPClient http;
    http.begin(ServerPath);
    http.addHeader("Content-Type", "application/json"); // Typ des Body auf json Format festlegen

    String msg = JSON.stringify(Message); // konvertieren des JSON Objekts in einen String
    int httpResponseCode = http.POST(msg); // Übertragung

    Serial.print("HTTP Response code: ");
    translate(httpResponseCode);     
    
    http.end();
    return httpResponseCode;
}

JSONVar post_json_json(String ServerPath, JSONVar Message){
  // HTTP-POST
  // Anlegen eines neuen Datensatzes in der Datenbank (ServerPath). Der Inhalt ist im JSON Objekt enthalten.
  // Das JSON Objekt wird in einen String umgewandelt und als Body des HTTP Requests übertragen.

  JSONVar Data;
  HTTPClient http;
  http.begin(ServerPath);
  http.addHeader("Content-Type", "application/json"); // Typ des Body auf json Format festlegen

  String msg = JSON.stringify(Message); // konvertieren des JSON Objekts in einen String
  int httpResponseCode = http.POST(msg); // Übertragung

  Serial.print("HTTP Response code: ");
  translate(httpResponseCode);    

  if (httpResponseCode == 200){
    msg = http.getString();
  } else{
    msg = "{}";
  }
  
  Data = JSON.parse(msg);

  http.end();
  return Data;
}

JSONVar get_json(String ServerPath){
  // HTTP GET
  // Abrufen eines Datensatzes (id muss in URL hinterlegt sein) im JSON Format
  // zum Debugging wird der Datensatz und das JSON objekt auf dne Seriellen Monitor übertragen
  // Return das den Datensatz als JSON Objekt

  HTTPClient http;
  http.begin(ServerPath); //Startet Verbindung zu Server
  int httpResponseCode = http.GET();
  Serial.println();
  Serial.println("GET:");
  String payload = "{empty}"; 
  
  if (httpResponseCode > 0) {
    Serial.print("HTTP Response code: ");
    translate(httpResponseCode);
    if (httpResponseCode == 200){
      payload = http.getString();
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
  int Value = entfernung();
  Value = Value*100/Tankhoehe;
  if (value <= minTanklevel){
    value = 0; // Sicherheitsspielraum für die Pumpe
  }
  return (Value);
}

int bodenfeuchte(){
  // Berechnung der Bodenfeuchtigkeit in %, der Wert wird aus der Max. Feuchtigkeit und dem kapazitiven Bodenfeuchtigkeitssensor berechnet.
  // Der Normierte Wert wird in % angegeben.
  int value = analogRead(BodenfeuchtigkeitPIN);
  Serial.print("Bodenfeuchte Messwert: ");
  Serial.println(value);
  value = (((value - feuchtemin) *100) /feuchtemax);
  //Serial.print("Bodenfeuchte Normwert: ");
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
  // es wird gegossen bis der Feuchtigkeitswert erreicht wird, bei einem hohen Wasserbedarf sind die Gießintervalle länger als bei einem geringen
  // Optimierung: Gießintervalle an Luchtfeuchtigkeits soll anpassen

  int feuchteAktuell = bodenfeuchte();
  const int kurz_giesen = 3000; // Wert für kurz giesen in ms, bei geringem Wasserbedarf
  const int lange_giesen = kurz_giesen * 1,5; // Wert fürs lange giesen in ms, bei hohem Wasserbedarf
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
    delay(wartezeit);
    feuchteAktuell = bodenfeuchte();
    giesen(Feuchtigkeitswert);
  } else if (feuchteAktuell < Feuchtigkeitswert && ok){
    Serial.println("Kurz gießen.");
    pumpen(true);
    delay(kurz_giesen);
    pumpen(false);
    delay(wartezeit);
    feuchteAktuell = bodenfeuchte();
    giesen(Feuchtigkeitswert);
  }
}

void luftfeuchtigkeit_erhoehen(int FeuchtigkeitswertAir, int FeuchtigkeitswertGround){

  //Konstanten
  const int spruezeit = 2000; // Sprühzeit in ms (Wert sollte recht klein sein)
  const int wartezeit = 10000; // Wartezeit in ms (Wert sollte recht hoch sein)
  const int maxLaufzeit = 10; // Anzahl an durchläufen bis davon ausgegangen wird das etwas nicht stimmt (Sicherheit vor Überschwemmung)
  int counter = 0;

  int feuchteAktuell = luftfeuchtigkeit();
  int feuchteAktuellBoden = bodenfeuchte();

  // Optimierung: evtl. Test ob Deckel zu ist
  while ((feuchteAktuell < Feuchtigkeitswert) && (counter < 10) && (feuchteAktuellBoden < FeuchtigkeitswertGround))
  {
    counter++;
    Serial.print("Feuchtigkeit erhöhen. Durchgang: ");
    Serial.println(counter);
    pumpen(true);
    delay(spruezeit);
    pumpen(false);
    delay(wartezeit);
    feuchteAktuell = luftfeuchtigkeit();
    feuchteAktuellBoden = bodenfeuchte();
  }
  Serial.println("Luftfeuchtigkeit erreicht.");
  return;
}
