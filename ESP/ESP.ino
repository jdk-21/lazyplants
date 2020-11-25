/* Name: Steuerung ESP
 * Projekt: LazyPlants
 * Erstelldatum:  01.11.2020 18:00
 * Änderungsdatum: 25.11.2020 16:00
 * Version: 0.1.1
 * History:
 */


//Include
#include "Module.h"
//#include <Preferences.h> // Offline Speichern auf dem ESP //noch nicht Verwendet


// Declarationen
// Connections
const String espID = "ESP_Blume_Test";
String table_login = "Member"; // stelle an der sich der ESP bei der API einloggen muss
String table_get = "Plants"; // Pflanze
String table_DB = "PlantData"; // Pflanzen Datensätze
String email = "patrick@gmail.com";
String pw_API = "test";
//String ServerPath = ("http://"+ipadresse+"/api/"+ table + id + "?access_token=" + token + filter); // http://178.238.227.46:3000/api/waterplants/5fb3804d76949e054eeae501?access_token=cwapZ8RI3Y8HtK09S5P8RpAaVGUwLgjrlBuKj308rZgt8K0bGkMEizTjeGhuE3eZ
String ServerPath = ("http://"+ ipadresse + "/api/" + table_login+ "?");
//String filter = "&filter[where][UserID]=1&filter[where][PlantID]=1"; //z.B. &filter[where][UserID]=1&filter[where][PlantID]=1

// WLAN
// const char* ssid = "TrojaNet";
// const char* pw = "50023282650157230429";
const char* ssid = "flottes_WLAN";
const char* pw = "70175666528540340315";

JSONVar Data;
String id;
String token;
String UserID;
String msg;
int ResponseCode;
int counter;
String  Time;
char buffer [80];
time_t rawtime;
#define IntervallTime 3E7 // Mikrosekunden hier 30s
RTC_DATA_ATTR int bootZaeler = 0;   // Variable in RTC Speicher bleibt erhalten nach Reset

String filter; //z.B. &filter[where][UserID]=1&filter[where][PlantID]=1

//Preferences preferences; // Permanentes Speichern von Variablen
//RTC_DATA_ATTR int bootZaeler = 0;   // Variable in RTC Speicher bleibt erhalten nach Reset
void firstStart(){
  Serial.begin(115200);
  delay(500); // Warten bis Serial gestartet ist
  Serial.println("");
  Serial.println("Reset Start");

  connect(ssid, pw); //WLAN Verbindung einrichten

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
  if (wakeup_cause != 3){
    firstStart(); // Wenn wakeup durch Reset
  } else{
    Serial.println("Start Nr.: " + String(bootZaeler));
  }

  setenv("TZ", TZ_INFO, 1);             // Zeitzone  muss nach dem reset neu eingestellt werden
  tzset();

  Data = login(email, pw_API); // Login bei API und Token erhalten

  token = Data["id"];
  Serial.print("Token: ");
  Serial.println(token);

  UserID = Data["userId"];
  Serial.print("UserID: ");
  Serial.println(UserID);
  if (token == "null"){
    Serial.println("Login nicht möglich!");
    ESP.restart();
  }
  //timeClient.begin(); // Verindung zum "Zeitserver"
  //Time = timeClient.getFormattedTime();
  //Serial.print("Zeitserver verbunden: "); Serial.println(Time);
  
}

void loop() {
  //timeClient.update();// Zeit aktualisieren
  //Time = timeClient.getEpochTime();

  tm local;
  getLocalTime(&local);
  //Time = (&local, "%y-%m-%dT%H:%M:%SZ");
  //rawtime = mktime(&local); //Falsches Format
  //Serial.println(rawtime);
  //Time = rawtime_year+"-"+rawtime_mon+"-"+rawtime_mday;
  strftime (buffer,80,"20%y-%m-%dT%H:%M:%S.000Z",&local);
  //Time = asctime(&local);
  Time = buffer;
  Serial.println("Time: "+ String(Time));

  // prüfen ob Plant existiert
  filter = "&filter[where][memberId]="+ UserID +"&filter[where][espId]=" + espID ;
  ServerPath = ("http://"+ipadresse+"/api/"+ table_get + "?access_token=" + token + filter);
  Data = get_json(ServerPath);
  Serial.println(Data);
  if (JSON.stringify(Data) == "[]"){
    Serial.println("GET Plant failed");
    ServerPath = ("http://"+ipadresse+"/api/"+ table_get + "?access_token=" + token);
    Serial.print("New ServerPath: "); Serial.println(ServerPath);
    msg = ("{\"plantname\":\"NEW\",\"plantdate\":\""+ Time +"\", \"espId\": \""+ espID +"\", \"room\": \"NON\", \"soil_moisture\":30, \"humidity\":30, \"memberId\":\"" + UserID + "\"}");
    Serial.print("New Plant: "); Serial.println(msg);
    Data = JSON.parse(msg);
    counter = 0;
    do{
      ResponseCode = post_json(ServerPath, Data);
      counter++;
      delay(1000);
      if (counter == max_Retry){
        Serial.println("POST new Plant failed");
      }
    }while(ResponseCode != 200 && counter <= max_Retry);
  } else{
    Serial.print("GET Plant with Name: ");
    Serial.println(Data["plantname"]);
  }
  //delay(60000);
  Serial.println("Deep Sleep");
  esp_sleep_enable_timer_wakeup(IntervallTime);    // Deep Sleep Zeit einstellen
  esp_deep_sleep_start();
}
