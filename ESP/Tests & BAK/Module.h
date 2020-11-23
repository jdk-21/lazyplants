#include <arduino>
#include <Time>
#include <vector>
#include <WiFi.h>
#include "DHT.h" //DHT Bibliothek laden
#include <Arduino_JSON.h>
#include <HTTPClient.h>

// PINs
#define ultraschalltrigger 34 // Pin an HC-SR04 Trig
#define ultraschallecho 35    // Pin an HC-SR04 Echo
#define BodenfeuchtigkeitPIN 12
#define PumpePIN 17
#define dhtPIN 23
#define dhtType "DHT22"

// Umfeld
#define Relai_Schaltpunkt LOW // definition on Relai bei HIGH oder LOW schaltet
// Constanten
const int feuchtemin = 0;
const int feuchtemax = 3571; // Erfahrungswert, Arduino Reference sagt max. Wert bei 4095  //TODO: kallibrieren

//weitere Parameter
#define max_Tankhoehe 30 //Angabe in cm bei denen der Sensor den Tank als leer erkennt


void setup() {
  pinMode(ultraschalltrigger, OUTPUT);
  pinMode(ultraschallecho, INPUT);
  pinMode(PumpePIN, OUTPUT);
  Serial.begin(115200);
}

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
    // HTTP-PATCH
    // Überschreibt den Inhalt eines Datensatzes. 
    // Wichtig! Der Datensatz muss komplett im JSON Objekt hinterlegt sein nicht nur der zu ändernde Teil und es dürfen keine Undefinierten Inhalte enthalten sein (Errorcode: 402).
    
    HTTPClient http;
    http.begin(ServerPath);
    http.addHeader("Content-Type", "application/json"); //Typ des Body auf json Format festlegen
    String msg = JSON.stringify(Message); //konvertieren des JSON Objekts in einen String
    int httpResponseCode = http.PATCH(msg); // Übertragung
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);    
    
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
    Serial.println(httpResponseCode);    
    
    http.end();
    return httpResponseCode;
  }

int post_json(String ServerPath, JSONVar Message){
    // HTTP-POST
    // Anlegen eines neuen Datensatzes in der Datenbank (ServerPath). Der Inhalt ist im JSON Objekt enthalten.
    // Das JSON Objekt wird in einen String umgewandelt und als Body des HTTP Requests übertragen.

    HTTPClient http;
    http.begin(ServerPath);
    http.addHeader("Content-Type", "application/json"); // Typ des Body auf json Format festlegen

    String msg = JSON.stringify(Message); // konvertieren des JSON Objekts in einen String
    int httpResponseCode = http.POST(msg); // Übertragung

    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);    
    
    http.end();
    return httpResponseCode;
}

JSONVar get_json(String ServerPath){
  // HTTP GET
  // Abrufen eines Datensatzes (id muss in URL hinterlegt sein) im JSON Format
  // zum Debugging wird der Datensatz und das JSON objekt auf dne Seriellen Monitor übertragen
  // Return das den Datensatz als JSON Objekt

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
    zeit = (zeit/2); // Zeit halbieren, da der SChall den Weg hin und zurück überwindet
    entfernung = zeit / 29.1; // Zeit in Zentimeter umrechnen
    return(entfernung);
  }
  
int fuellsstand(int Tankhoehe = max_Tankhoehe){
  // Berechnung des Füllstandes des Tanks Aufgrund der Tankhöhe und der Entfernung zwischen Sensor und Wasseroberfläche. Angabe in %.
  int Value = entfernung();
  return (Value/Tankhoehe *100);
}

int bodenfeuchte(int PIN = BodenfeuchtigkeitPIN){
  // Berechnung der Bodenfeuchtigkeit in %, der Wert wird aus der Max. Feuchtigkeit und dem kapazitiven Bodenfeuchtigkeitssensor berechnet.
  // Der Normierte Wert wird in % angegeben.
  int value = analogRead(PIN);
  Serial.print("Messwert: ");
  Serial.println(value);
  value = (((value - feuchtemin) *100) /feuchtemax);
  Serial.print("Normwert: ");
  Serial.println(value);
  return value;
}

float luftfeuchtigkeit(int PIN, String dht_type){
  DHT dht(PIN, dht_type); //Der Sensor wird ab jetzt mit „dht“ angesprochen
  dht.begin();
  float Luftfeuchtigkeit = dht.readHumidity(); // die Luftfeuchtigkeit auslesen und unter „Luftfeutchtigkeit“ speichern
  dht.end();
  return Luftfeuchtigkeit;  
}

float temperatur(int PIN, String dht_type){
  DHT dht(PIN, dht_type); //Der Sensor wird ab jetzt mit „dht“ angesprochen
  dht.begin();
  float Temperatur = dht.readTemperature(); // die Temperatur auslesen und unter „Temperatur“ speichern
  dht.end();
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
    if (Reali_Schaltpunkt == LOW){
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

  int feuchte_aktuell = bodenfeuchte(BodenfeuchtigkeitPIN)
  const int lange_giesen = 5000; // Wert fürs lange giesen in ms, bei hohem Wasserbedarf
  const int kurz_giesen = 3000; // Wert für kurz giesen in ms, bei geringem Wasserbedarf
  const int wartezeit = 3000; // Wartezeit, damit das Wasser ein wenig einsickern kann bevor der Sensor erneut misst.

  if (feuchte_aktuell >= Feuchtigkeitswert){
    Serial.println("Boden feucht genug.");
    return;
  } else if (feuchte_aktuell <= (Feuchtigkeitswert / 2)) { // Hoher Wasserbedarf
    Serial.println("Lange gießen.");
    pumpen(true);
    delay(lange_giesen);
    pumpen(false);
    delay(wartezeit);
    giesen(Feuchtigkeitswert);
  } else if (feuchte_aktuell < Feuchtigkeitswert){
    Serial.println("Kurz gießen.");
    pumpen(true);
    delay(kurz_giesen);
    pumpen(false);
    delay(wartezeit);
    giesen(Feuchtigkeitswert);
  }
}

void luftfeuchtigkeit_erhoehen(int Feuchtigkeitswert){

  //Konstanten
  const int spruezeit = 2000; // Sprühzeit in ms (Wert sollte recht klein sein)
  const int wartezeit = 10000; // Wartezeit in ms (Wert sollte recht hoch sein)
  const int maxLaufzeit = 10; // Anzahl an durchläufen bis davon ausgegangen wird das etwas nicht stimmt (Sicherheit vor Überschwemmung)
  int counter = 0;

  int feuchte_aktuell = luftfeuchtigkeit(dhtPIN, dhtType); // TODO: Luftfeuchtigkeits mess Funktion einbinden

  // Optimierung: evtl. Test ob Deckel zu ist
  while ((feuchte_aktuell < Feuchtigkeitswert) && (counter < 10))
  {
    counter++;
    Serial.print("Feuchtigkeit erhöhen. Durchgang: ");
    Serial.println(counter);
    pumpen(true);
    delay(spruezeit);
    pumpen(false)
    delay(wartezeit);
    feuchte_aktuell = luftfeuchtigkeit(dhtPIN, dhtType); // TODO: Luftfeuchtigkeits mess Funktion einbinden
  }
  Serial.println("Luftfeuchtigkeit erreicht.")
  return;
}





