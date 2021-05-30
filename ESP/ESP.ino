/* Name: Steuerung ESP
   Projekt: LazyPlants
   Erstelldatum:  01.11.2020 18:00
   * Änderungsdatum: 28.05.2021 13:00
 * Version: 0.2.0
   History:
*/


//Include
#include "Module.h"
//#include <Preferences.h> // Offline Speichern auf dem ESP //noch nicht Verwendet


// Declarationen
// Connections
const String espName = "ESP_Blume_1";
String email = "johnhanley@gmail.com";
String pw_API = "password";



// WLAN
const char* ssid = "TrojaNet";
const char* pw = "50023282650157230429";
//const char* ssid = "flottes_WLAN";
//const char* pw = "70175666528540340315";

// Variablen
JSONVar Data;
JSONVar Plant;
int soll_soilMoisture;
int soll_humidity;
String plantID;
String msg;
String ServerPath;
String Messages[9];
int ResponseCode;
int counter;
String  Time;
char buffer [80];
#define IntervallTime 30 //in Sekunden
//#define IntervallTime 3E7 // Mikrosekunden hier 30s (DeepSleep)
//#define IntervallTime 30000 //Milliseconds hier 30s
RTC_DATA_ATTR int bootZaeler = 0;   // Variable in RTC Speicher bleibt erhalten nach Reset

//Zeit
#define NTP_SERVER "de.pool.ntp.org"
#define TZ_INFO "WEST-1DWEST-2,M3.5.0/02:00:00,M10.5.0/03:00:00" // Western European Time
struct tm local;

// Sensoren
int soilMoisture;
float humidity;
float temp;
int Tanklevel;
bool gegossen = false;
const int toleranz = 20; // Angabe der Toleranz in %

//Preferences preferences; // Permanentes Speichern von Variablen

void firstStart() {
  delay(500);
  Serial.begin(115200);
  delay(500); // Warten bis Serial gestartet ist
  Serial.println("");
  Serial.println("Reset Start");
  digitalWrite(PumpePIN, HIGH);  

  Serial.println("Hole NTP Zeit");
  configTzTime(TZ_INFO, NTP_SERVER); // ESP32 Systemzeit mit NTP Synchronisieren
  getLocalTime(&  local, 5000);        // Versuche 5 s zu Synchronisieren

  pinMode(ultraschalltrigger, OUTPUT);
  pinMode(ultraschallecho, INPUT);
  pinMode(PumpePIN, OUTPUT);

}

void setup() {
  esp_sleep_wakeup_cause_t wakeup_cause; // Variable für wakeup Ursache
  // Setup
  bootZaeler++;
  wakeup_cause = esp_sleep_get_wakeup_cause(); // wakeup Ursache holen
  if (wakeup_cause != 3) {
    firstStart(); // Wenn wakeup durch Reset
  } else {
    Serial.println("Start Nr.: " + String(bootZaeler));
  }
  connect(ssid, pw); //WLAN Verbindung einrichten
  
  setenv("TZ", TZ_INFO, 1); // Zeitzone  muss nach dem reset neu eingestellt werden
  tzset();

  if (token == ""){
    //new token
    login(email, pw_API); // Login bei API und Token erhalten    
  }

  if (token == "null" || token == "") {
    Serial.println("Login nicht möglich!");
    ESP.restart();
  }
  gegossen = false;
}

void loop() {
  //Zeit
  tm local;
  getLocalTime(&local); //Abrufen der Zeit
  strftime (buffer, 80, "20%y-%m-%dT%H:%M:%S.000Z", &local); //Formatieren der Zeit
  Time = buffer;
  Serial.println("Time: " + String(Time));

  //Token testen
  Serial.print("Test Token: ");
  ServerPath = baseUrl +"user/me";
  Data = get_json(ServerPath);
  Serial.println(Data);
  if (JSON.stringify(Data) == "{}"){
    Serial.print("Get new token: ");
    login(email, pw_API);
  }else{
    Serial.println("Token ok");
  }
  
  // prüfen ob Plant existiert
  ServerPath = baseUrl + tablePlant + "/" + espName;
  Serial.println(ServerPath);
  Plant = get_json(ServerPath);
  Serial.print("Plant: ");
  Serial.println(Plant);

  // Plant existiert nicht, POST default Plant
  if (Plant["plantDate"] == null) {
    Serial.println("GET Plant failed");
    //Default Plant zusammenstellen
    msg = ("{\"plantDate\":\"" + Time + "\", \"espName\": \"" + espName + "\", \"soilMoisture\":20, \"humidity\":20}");
    Serial.print("New Plant: "); Serial.println(msg);
    Data = JSON.parse(msg);
    counter = 0;
    do {
      Plant = post_json_json(ServerPath, Data); // POST der default Werte
      counter++;
      delay(1000);
      if (counter > max_Retry) {
        Serial.println("ERROR: POST new Plant failed");
      }
    } while (JSON.stringify(Plant) == "{}" && counter <= max_Retry);
    Serial.print("GET Plant with Name: ");
  } else {
    Serial.print("GET Plant with Name: ");
    Serial.println(Plant["plantname"]);
  }
  Serial.println();

  
  // Pflanzen Daten ausgeben
  soll_soilMoisture = Plant["soilMoisture"];
  Serial.print("Soll soilMoisture: "); Serial.print(soll_soilMoisture); Serial.println("%");
  soll_humidity = Plant["humidity"];
  Serial.print("Soll humidity: "); Serial.print(soll_humidity);  Serial.println("%");
  plantID = Plant["plantId"];
  Serial.print("PlantID: "); Serial.println(plantID);
  Serial.println();
  
  // Messwerte erfassen
  Serial.println("Sensorwerte: ");
  temp = temperatur();
  Serial.print("Temperatur: "); Serial.print(temp); Serial.println("°C");
  delay(1000);
  int level = entfernung();
  Serial.print("Entfernung: "); Serial.print(level); Serial.println("cm");
  delay(1000);
  Tanklevel = fuellsstand();
  Serial.print("Tankfüllung: "); Serial.print(Tanklevel); Serial.println("%");
  delay(1000);
  soilMoisture = bodenfeuchte();
  Serial.print("Bodenfeuchte: "); Serial.print(soilMoisture); Serial.println("%");
  delay(1000);
  humidity = luftfeuchtigkeit();
  Serial.print("Luftfeuchte: "); Serial.print(humidity); Serial.println("%");
  Serial.println();

  // Actions - Bodenfeuchte ok?
  if (soilMoisture < (soll_soilMoisture-(soll_soilMoisture * toleranz / 100))) {
    Serial.println("Gießen!");
    giesen(Plant["soilMoisture"]);
    gegossen = true;
  }

  // Datensatz bauen und übertragen inkl. Ergebnis prüfen
  Messages[0] = "{\"plantId\":\"" + plantID + "\", ";
  if(soilMoisture >= 0){
    Messages[1] = "\"soilMoisture\":" + String(soilMoisture) + ", ";
  }else{
    Messages[1] = "\"soilMoisture\":\"\", "; // if nan
  }
  if(String(humidity) != "nan"){
    Messages[2] = "\"humidity\":" + String(humidity) + ", ";
  }else{
    Messages[2] = ""; // if nan
  }
  if(String(temp) != "nan"){
    Messages[3] = "\"temperature\":" + String(temp) + ", ";
  }else{
     Messages[3] = "";// if nan
  }
  if(Tanklevel >= 0){
    Messages[4] = "\"watertank\":" + String(Tanklevel) + ", "; 
  }else{
    Messages[4] = ""; 
  }
  Messages[5] = "\"measuringTime\":\"" + Time + "\", ";
  
  if (gegossen){
    Messages[6] = "\"water\": true }";
  }else{
    Messages[6] = "\"water\": false }";
  }

  msg = "";
  for(int i=0; i <= 6 ;i++){
    msg = msg + Messages[i];
  }

  Serial.println();
  ServerPath = (baseUrl + tableDB);
  Serial.println(ServerPath);
  Serial.println(msg);
  Data = JSON.parse(msg);
  
  counter = 0;
  do {
    ResponseCode = post_json_int(ServerPath, Data);
    counter++;
    if (counter > max_Retry) {
      Serial.println("ERROR: POST Messdaten nicht möglich!");
    }
  } while (ResponseCode != 200 && counter <= max_Retry);
  
  // Deep Sleep
  Serial.println("Sleep");
  Serial.println();
  delay(IntervallTime * 1000);
  //esp_sleep_enable_timer_wakeup(IntervallTime *1000000);    // Deep Sleep Zeit einstellen
  //esp_deep_sleep_start();
}
