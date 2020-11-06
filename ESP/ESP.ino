/* Name: Steuerung ESP
 * Projekt: LazyPlants
 * Erstelldatum:  01.11.2020 18:00
 * Änderungsdatum: 01.11.2020 18:00
 * Version: 0.0.1
 * History:
 */


//Include
#include <DHT.h>
//#include <Esp32Wifi.h>
#include "WiFi.h"
#include <WiFiUdp.h>
#include <WiFiClient.h>
#include <WiFiServer.h>
#include <WiFiUdp.h>
#include <NTPClient.h> //Verbindung mit Time Server

//Declarationen
  //WLAN & Connection  
  WiFiClient client; //Anpassen je nach Board
  WiFiUDP ntpUDP;
  NTPClient timeClient(ntpUDP);//TimeServer
  String WiFi_Status = "";
  const char* ssid = "TrojaNet";
  const char* password = "50023282650157230429";
  int HTTP_PORT = 222;
  char HOST_NAME[] = "178.238.227.46"; //hostname of web server
  String PATH_NAME = "";
  String APIToken = "m3bLgWtaK1q7K9Ez6FvbNuik7Wzoe5P0XqSovsPa4dNeJrJQOQa2HGk9YF1qrTYE"; //Test //Anfragen bei Autentifizierung an der API
  
  //Variablen
  bool giese = false;
  String PlantName = "";
  int counter = 0;

  //Sensoren 
  #define feuchtigkeitPin A0
  #define ultraschalltrigger 3 // Arduino Pin an HC-SR04 Trig
  #define ultraschallecho 2    // Arduino Pin an HC-SR04 Echo
  #define feuchtemax 343 //bei 100% Wasser (Bodenfeuchte)
  #define feuchtemin 664 //bei 0% Wasser (Bodenfeuchte)
  #define DHTPIN 4 // Datapin für den DHT22
  #define DHT_TYPTE DHT22 //Typ von DHT
  DHT dht(DHTPIN, DHT_TYPTE);

  //Aktore
  #define PumpePin 5 //Anschluss für das Pumpenrelai
  #define Relai_Schaltpunkt LOW //Relai schaltet bei Low/Hight durch

  //weitere Parameter
  #define Tankhoehe 30 //Angabe in cm bei denen der Sensor den Tank als leer erkennt
  #define optimalefeuchte 60 //in %

//SETUP 
void setup() {
    
  pinMode(ultraschalltrigger, OUTPUT);
  pinMode(ultraschallecho, INPUT);
  pinMode(PumpePin, OUTPUT);
  dht.begin();
  Serial.begin(9600);//Test

  Serial.print("Connection to WiFi");
  delay(100);
  WiFi.begin(ssid, password);
  while ((WiFi.status() != WL_CONNECTED) && (counter <= 30)) {
    Serial.print(".");
    delay(1000);
    counter++;
  }
  if (counter >= 31){
    Serial.println("");
    Serial.println("WiFi Connection faild!");
  } else {
    Serial.println("");
    Serial.println("WiFi Connected!");
  }
  timeClient.begin();
  timeClient.update();
  Serial.println(timeClient.getFormattedTime());
}

// Funktionen

  //Sensoren
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

  //Aktionen 

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

  bool connecten(){
    if (client.connect(HOST_NAME, HTTP_PORT)){
      Serial.println("Connectet to Server");
      return true;
    } else {
      Serial.println("Connection failed");
      return false;
    }
  }
  void senden(String MESSAGE){
    //http://178.238.227.46:3000/api/plants_data?access_token=Fm8ctl15LypUYt6ICN6kA3M2BlVrwF9KCMijBPSfqAGtHMv220PAZSHvisDZxBq6 //POST
    //HTTP header
    /* TEST
    client.println("POST" + " " + PATH_NAME * " http://178.238.227.46:3000/api/plants_data?"); // TODO: Anpassen an eigene Syntax
    client.println("Host: " + String(HOST_NAME));
    client.println("Connection: close");
    client.println(); //end HTTP requirest header
    //HTTP Body
    client.println(MESSAGE);
    */
  }

  String empfangen(){
    //http://178.238.227.46:3000/api/plants_data?access_token=Fm8ctl15LypUYt6ICN6kA3M2BlVrwF9KCMijBPSfqAGtHMv220PAZSHvisDZxBq6 //GET
  }

//Main
void loop() {
  timeClient.update(); //Time aktualisieren
  String zeit = timeClient.getFormattedTime();

  Serial.println("Luftfeuchte:");
  Serial.println(Luftfeuchtigkeit());
  delay(5000);

  
  //String Massage = '{\n "name": "Test",\n "date": "",\n "soil_moisture": 40,\n "humidity": 70,\n "temperature": 25,\n "watertank": 90 \n}'; //Test Massage
  //senden(Massage);
  
  /*  
  delay(3000);
  Serial.println("Feuchte:");
  Serial.println(Bodenfeuchtigkeit());
  Serial.println("Entfernung:");
  Serial.println(entfernung());

  //String Massage = '{\n "name": "' + PlantName + '",\n "date": "' + zeit + '",\n "soil_moisture": ' + Bodenfeuchtigkeit() +',\n "humidity": '+ Luftfeuchtigkeit() +',\n "temperature": '+ Temperatur() +',\n "watertank": '+ fuellsstand() +'\n}'
  
 */

  /* 
   *  while(client.available())
   * {
   *  // read an incoming byte from the server and print them to serial monitor:
   *  char c = client.read();
   *  Serial.print(c);
   * }
   * 
   * if(!client.connected())
   * {
   *   // if the server's disconnected, stop the client:
   *   Serial.println("disconnected");
   *   client.stop();
   * }
   */
   
  //Serial.println("disconnected");
  //client.stop(); 
}
