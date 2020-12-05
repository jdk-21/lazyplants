/* Name: Steuerung ESP
   Projekt: LazyPlants
   Erstelldatum:  01.11.2020 18:00
   Änderungsdatum: 26.11.2020 10:00
   Version: 0.1.3
   History:
*/


//Include
#include "Module.h"
//#include <Preferences.h> // Offline Speichern auf dem ESP //noch nicht Verwendet


// Declarationen
// Connections
const String espID = "ESP_Blume_Test";
String tableLogin = "Member"; // stelle an der sich der ESP bei der API einloggen muss
String tableGet = "Plants"; // Pflanze
String tableDB = "PlantData"; // Pflanzen Datensätze
String email = "patrick@gmail.com";
String pw_API = "test";
String ServerPath = ("http://" + ipadresse + "/api/" + tableLogin + "?");
//String ServerPath = ("http://"+ipadresse+"/api/"+ table + id + "?access_token=" + token + filter); // http://178.238.227.46:3000/api/waterplants/5fb3804d76949e054eeae501?access_token=cwapZ8RI3Y8HtK09S5P8RpAaVGUwLgjrlBuKj308rZgt8K0bGkMEizTjeGhuE3eZ
//String filter = "&filter[where][MemberID]=1&filter[where][PlantID]=1"; //z.B. &filter[where][MemberID]=1&filter[where][PlantID]=1

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
String id;
String token;
String MemberID;
String filter; //z.B. &filter[where][MemberID]=1&filter[where][PlantID]=1
String msg;
String Messages[9];
int ResponseCode;
int counter;
String  Time;
char buffer [80];
#define IntervallTime 3E7 // Mikrosekunden hier 30s (DeepSleep)
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
  if (wakeup_cause != 3) {
    firstStart(); // Wenn wakeup durch Reset
  } else {
    Serial.println("Start Nr.: " + String(bootZaeler));
  }

  setenv("TZ", TZ_INFO, 1); // Zeitzone  muss nach dem reset neu eingestellt werden
  tzset();

  Data = login(email, pw_API); // Login bei API und Token erhalten

  token = Data["id"];
  Serial.print("Token: ");
  Serial.println(token);

  MemberID = Data["userId"];
  Serial.print("MemberID: ");
  Serial.println(MemberID);
  if (token == "null") {
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

  // prüfen ob Plant existiert
  filter = "&filter[where][memberId]=" + MemberID + "&filter[where][espId]=" + espID ;
  ServerPath = ("http://" + ipadresse + "/api/" + tableGet + "?access_token=" + token + filter);
  Plant = get_json(ServerPath);
  Serial.print("Plant: ");
  Serial.println(Plant);

  // Plant existiert nicht, POST default Plant
  if (JSON.stringify(Plant) == "{}") {
    Serial.println("GET Plant failed");
    //Default Plant zusammenstellen
    ServerPath = ("http://" + ipadresse + "/api/" + tableGet + "?access_token=" + token);
    Serial.print("New ServerPath: "); Serial.println(ServerPath);
    msg = ("{\"plantdate\":\"" + Time + "\", \"espId\": \"" + espID + "\", \"soilMoisture\":30, \"humidity\":30, \"memberId\":\"" + MemberID + "\"}");
    //msg = ("{\"plantname\":\"NEW\",\"plantdate\":\"" + Time + "\", \"espId\": \"" + espID + "\", \"soilMoisture\":30, \"humidity\":30, \"memberId\":\"" + MemberID + "\"}");
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
  plantID = Plant["plantsId"];
  Serial.print("PlantID: "); Serial.println(plantID);

  // Messwerte erfassen
  temp = temperatur();
  Serial.print("Temperatur: "); Serial.print(temp); Serial.println("°C");
  int level = entfernung();
  Serial.print("Entfernung: "); Serial.print(level); Serial.println("cm");
  Tanklevel = fuellsstand();
  Serial.print("Tankfüllung: "); Serial.print(Tanklevel); Serial.println("%");
  soilMoisture = bodenfeuchte();
  Serial.print("Bodenfeuchte: "); Serial.print(soilMoisture); Serial.println("%");
  humidity = luftfeuchtigkeit();
  Serial.print("Luftfeuchte: "); Serial.print(humidity); Serial.println("%");
  Serial.println();

  // Actions - Luftfeuchteok? Bodenfeuchte ok?
  if ((humidity < (soll_humidity - (soll_humidity * toleranz / 100 ))) && Tanklevel > minTanklevel ) {
    Serial.println("Luftfeuchte erhöhen!");
    luftfeuchtigkeit_erhoehen(soll_humidity, soll_soilMoisture);
  }
  if (soilMoisture < (soll_soilMoisture-(soll_soilMoisture * toleranz / 100))) {
    Serial.println("Gießen!");
    giesen(Plant["soilMoisture"]);
    gegossen = true;
  }

  // Datensatz bauen und übertragen
  Messages[0] = "{\"espId\":\"" + espID + "\",";
  Messages[1] = "\"soilMoisture\":\"" + String(soilMoisture) + "\",";
  Messages[2] = "\"humidity\":\"" + String(humidity) + "\",";
  Messages[3] = "\"temperature\":\"" + String(temp) + "\",";
  Messages[4] = "\"watertank\":\"" + String(Tanklevel) + "\",";
  Messages[5] = "\"water\":\"" + String(gegossen) + "\",";
  Messages[6] = "\"measuring_time\":\"" + Time + "\",";
  Messages[7] = "\"plantsId\":\"" + plantID + "\",";
  Messages[8] = "\"memberId\":\"" + MemberID + "\"}"; //letzter ohne , da dass } folgt

  for(int i=0;i<= 8 ;i++){
    msg = msg + Messages[i];
    Serial.print(i);
  }
  Serial.println();
  Serial.println(msg);

  Serial.println();
  ServerPath = ("http://" + ipadresse + "/api/" + tableDB + "?access_token=" + token);
  Serial.println(ServerPath);
  Data = JSON.parse(msg);
  Serial.println(JSON.stringify(Data));
  counter = 0;
  do {
    ResponseCode = post_json_int(ServerPath, Data);
    counter++;
    if (counter > max_Retry) {
      Serial.println("ERROR: POST Messdaten nicht möglich!");
    }
  } while (ResponseCode != 200 && counter <= max_Retry);
  // Deep Sleep
  Serial.println("Deep Sleep");
  esp_sleep_enable_timer_wakeup(IntervallTime);    // Deep Sleep Zeit einstellen
  esp_deep_sleep_start();
}
