/* Name: Module ESP
 * Projekt: LazyPlants
 * Erstelldatum:  15.11.2020 18:00
 * Änderungsdatum: 25.11.2020 16:00
 * Version: 0.0.5
 * History:
 */

#include <WiFi.h> // Verbinden mit dem WLAN (Bibliothek: Arduino Uno WiFi Dev Ed Library)
#include "DHTesp.h" //DHT Bibliothek laden
#include <Arduino_JSON.h> // Erstellen von JSON Objekten (Bibliothek: Arduino_JSON )
#include <HTTPClient.h> // HTTP Requests (Bibliothek: ArduinoHttpClient )
#include <NTPClient.h> // Zeit abfrage (Bibliothek: NTPClient)
#include <WiFiUdp.h> // gehötz zur Zeitabfrage
#include <time.h>
#include <String>

// PINs
#define ultraschalltrigger 15 // Pin an HC-SR04 Trig
#define ultraschallecho 4    // Pin an HC-SR04 Echo
#define BodenfeuchtigkeitPIN 39
#define PumpePIN 17
#define dhtPIN 23
#define dhtType DHT22
DHTesp dht;
// Umfeld
#define Relai_Schaltpunkt LOW // definition on Relai bei HIGH oder LOW schaltet

// Connection
const long utcOffsetInSeconds_winter = 3600; // Winterzeit in sek zur UTC Zeit
const long utcOffsetInSeconds_summer = 7200; // Winterzeit in sek zur UTC Zeit
String login_table = "Members"; // zum Anmelden an der API
const String domain = "api.kie.one"; // Domain des Servers
#define max_Retry 5
const char* root_ca = \
"-----BEGIN CERTIFICATE-----\n"\
"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\n"\
"-----END CERTIFICATE-----\n";



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
    bool Stop = false;
    int counter =0;
    Serial.print("Connecting to WiFi");
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

  String ServerPath_login = ("https://"+ domain +"/api/"+ login_table +"/login?");
  msg = "{\"email\":\""+ email +"\",\"password\":\""+ pw +"\"}";

  HTTPClient http;
  http.begin(ServerPath_login, root_ca);
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
    http.begin(ServerPath, root_ca);
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
    http.begin(ServerPath, root_ca);
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
    http.begin(ServerPath, root_ca);
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
  http.begin(ServerPath, root_ca);
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
  http.begin(ServerPath, root_ca); //Startet Verbindung zu Server
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

int bodenfeuchte (int BodenfeuchtePIN){
  // Berechnung der Bodenfeuchtigkeit in %, der Wert wird aus der Max. Feuchtigkeit und dem kapazitiven Bodenfeuchtigkeitssensor berechnet.
  // Der Normierte Wert wird in % angegeben.
    int value = analogRead(BodenfeuchtePIN);
    //Serial.print("fMesswert: ");
    //Serial.println(value);
    value = 100 - (((value - feuchtemin) *100) /feuchtemax);
    //Serial.print("fNormwert: ");
    //Serial.println(value);
    return value;
}

float luftfeuchtigkeit(){
  //dht.begin();
  int counter = 0;
  float Luftfeuchte;
  do{
    counter++;
    Luftfeuchte = dht.getHumidity(); // die Luftfeuchtigkeit auslesen und unter „Luftfeuchte“ speichern
    delayMicroseconds(40);
  }while((Luftfeuchte > 100) && (counter < max_Retry));
  return Luftfeuchte;  
}

float temperatur(){
  //dht.begin();  
  int counter = 0;
  float Temp;
  do{
    counter++;
    Temp = dht.getTemperature(); // die Temperatur auslesen und unter „Temp“ speichern
    delayMicroseconds(40);
  }while((Temp > 100) && (counter < max_Retry));
  return Temp;  
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
bool giesen(int soll_feuchte,int Tanklevel){
  const int giesenZeit = 5000; // Wert für kurz giesen in ms, bei geringem Wasserbedarf
  bool ok = false;
  if(Tanklevel > minTanklevel){
    Serial.println("gieße..");
    pumpen(true);
    delay(giesenZeit);
    pumpen(false);
    return true;
  }else{
    Serial.println("ZU WENIG WASSER!!!");
    return false;
  }
}
/*
void luftfeuchtigkeit_erhoehen(int FeuchtigkeitswertAir, int FeuchtigkeitswertGround){

  //Konstanten
  const int spruezeit = 2000; // Sprühzeit in ms (Wert sollte recht klein sein)
  const int wartezeit = 10000; // Wartezeit in ms (Wert sollte recht hoch sein)
  const int maxLaufzeit = 10; // Anzahl an durchläufen bis davon ausgegangen wird das etwas nicht stimmt (Sicherheit vor Überschwemmung)
  int counter = 0;

  int feuchteAktuell = luftfeuchtigkeit();
  //int feuchteAktuellBoden = bodenfeuchte();

  // Optimierung: evtl. Test ob Deckel zu ist
  while ((feuchteAktuell < FeuchtigkeitswertAir) && (counter < 10) && (feuchteAktuellBoden < FeuchtigkeitswertGround))
  {
    counter++;
    Serial.print("Feuchtigkeit erhöhen. Durchgang: ");
    Serial.println(counter);
    pumpen(true);
    delay(spruezeit);
    pumpen(false);
    delay(wartezeit);
    feuchteAktuell = luftfeuchtigkeit();
    //feuchteAktuellBoden = bodenfeuchte();
  }
  Serial.println("Luftfeuchtigkeit erreicht.");
  return;
}*/
