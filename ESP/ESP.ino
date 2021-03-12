/* Name: Steuerung ESP
   Projekt: LazyPlants
   Erstelldatum:  01.11.2020 18:00
   Änderungsdatum: 19.02.2021 12:40
   Version: 0.2.0
   History:
*/


//Include
#include "Module.h"
//#include <Preferences.h> // Offline Speichern auf dem ESP //noch nicht Verwendet


// Declarationen
// Connections
const String espID = "espBlume3";
String tableLogin = "Member"; // stelle an der sich der ESP bei der API einloggen muss
String tableGet = "Plants"; // Pflanze
String tableDB = "PlantData"; // Pflanzen Datensätze
String email = "patrick@gmail.com";
String pw_API = "test";
String ServerPath = ("https://" + domain + "/api/" + tableLogin + "?");
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
#define IntervallTime 30000 // Mikrosekunden hier 30s (DeepSleep)
RTC_DATA_ATTR int bootZaeler = 0;   // Variable in RTC Speicher bleibt erhalten nach Reset

//Zeit
#define NTP_SERVER "de.pool.ntp.org"
#define TZ_INFO "WEST-1DWEST-2,M3.5.0/02:00:00,M10.5.0/03:00:00" // Western European Time
struct tm local;

// Sensoren
int soilMoisture = 0;
int C_soilMoisture = 0;
float humidity = 0.0;
float C_humidity = 0.0;
float temp = 0.0;
float C_temp = 0.0;
int level = 0;
int C_level = 0;
int Tanklevel = 0;
int C_Tanklevel = 0;
bool gegossen = false;
const int toleranz = 20; // Angabe der Toleranz in %

void setup() {
  delay(500);
  Serial.begin(115200);
  delay(500);
  gegossen = false;  
  delay(500); // Warten bis Serial gestartet ist
  Serial.println("");
  Serial.println("Start:");
  Serial.println("PINs konfigurieren");
  digitalWrite(PumpePIN, HIGH);
  pinMode(ultraschalltrigger, OUTPUT);
  pinMode(ultraschallecho, INPUT);
  pinMode(PumpePIN, OUTPUT);
  dht.setup(dhtPIN, DHTesp::dhtType);
  connect(ssid, pw); //WLAN Verbindung einrichten
  Serial.println("Zeitzone einstellen");
  setenv("TZ", TZ_INFO, 1); // Zeitzone  muss nach dem reset neu eingestellt werden
  tzset();
  Serial.println("Hole NTP Zeit");  
  configTzTime(TZ_INFO, NTP_SERVER); // ESP32 Systemzeit mit NTP Synchronisieren
  getLocalTime(&  local, 5000);        // Versuche 5 s zu Synchronisieren

  //API login
  Serial.println("Login");
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
  delay(2000);
}

void loop() {
    Serial.println("Loop");
    C_temp = temp;
    temp = temperatur();
    if(isnan(temp)){
      temp = C_temp;
    }
    delay(1000);
    Serial.print("Temperatur: "); Serial.print(temp); Serial.println("°C");
    C_level = level;
    level = entfernung();
    if(isnan(level)){
      level = C_level;
    }
    delay(1000);
    Serial.print("Entfernung: "); Serial.print(level); Serial.println("cm");
    C_Tanklevel = Tanklevel;
    Tanklevel = fuellsstand();
    if(isnan(Tanklevel)){
      Tanklevel = C_Tanklevel;
    }
    delay(1000);
    Serial.print("Tankfüllung: "); Serial.print(Tanklevel); Serial.println("%");
    C_soilMoisture = soilMoisture;
    soilMoisture = bodenfeuchte(BodenfeuchtigkeitPIN);
    if(isnan(soilMoisture)){
      soilMoisture = C_soilMoisture;
    }
    delay(1000);
    Serial.print("Bodenfeuchte: "); Serial.print(soilMoisture); Serial.println("%");
    C_humidity = humidity;
    humidity = luftfeuchtigkeit();
    if(isnan(humidity)){
      humidity = C_humidity;
    }
    delay(1000);
    Serial.print("Luftfeuchte: "); Serial.print(humidity); Serial.println("%");
    Serial.println();
        
    //Zeit
    tm local;
    getLocalTime(&local); //Abrufen der Zeit
    strftime (buffer, 80, "20%y-%m-%dT%H:%M:%S.000Z", &local); //Formatieren der Zeit
    Time = buffer;
    Serial.println("Time: " + String(Time));
  
    // prüfen ob Plant existiert
    filter = "&filter[where][memberId]=" + MemberID + "&filter[where][espId]=" + espID ;
    ServerPath = ("https://" + domain + "/api/" + tableGet + "?access_token=" + token + filter);
    Plant = get_json(ServerPath);
    Serial.print("Plant: ");
    Serial.println(Plant);
  
    // Plant existiert nicht, POST default Plant
    if (JSON.stringify(Plant) == "{}") {
      Serial.println("GET Plant failed");
      //Default Plant zusammenstellen
      ServerPath = ("https://" + domain + "/api/" + tableGet + "?access_token=" + token);
      Serial.print("New ServerPath: "); Serial.println(ServerPath);
      msg = ("{\"plantdate\":\"" + Time + "\", \"espId\": \"" + espID + "\", \"soilMoisture\":30, \"humidity\":30, \"memberId\":\"" + MemberID + "\"}");
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
      
    } else {// Plant existiert
      Serial.print("GET Plant with Name: ");
      Serial.println(Plant["plantName"]);
    }
    
    soll_soilMoisture = Plant["soilMoisture"];
    Serial.print("Soll soilMoisture: "); Serial.print(soll_soilMoisture); Serial.println("%");
    soll_humidity = Plant["humidity"];
    Serial.print("Soll humidity: "); Serial.print(soll_humidity);  Serial.println("%");
    plantID = Plant["id"];
    Serial.print("PlantID: "); Serial.println(plantID);

  
    // Actions - Bodenfeuchte ok?
    gegossen = false;
    if (soilMoisture < (soll_soilMoisture - (soll_soilMoisture  * (toleranz / 100)))) {
      Serial.println("Gießen!");
      gegossen = giesen(Plant["soilMoisture"],Tanklevel );
    }
    Serial.println(Time);
    // Datensatz bauen
    Messages[0] = "{\"espId\":\"" + espID + "\",";
    Messages[1] = "\"soilMoisture\":\"" + String(soilMoisture) + "\",";
    Messages[2] = "\"humidity\":\"" + String(humidity) + "\",";
    Messages[3] = "\"temperature\":\"" + String(temp) + "\",";
    Messages[4] = "\"watertank\":\"" + String(Tanklevel) + "\",";
    Messages[5] = "\"water\":\"" + String(gegossen) + "\",";
    Messages[6] = "\"measuringTime\":\"" + Time + "\",";
    Messages[7] = "\"plantsId\":\"" + plantID + "\",";
    Messages[8] = "\"memberId\":\"" + MemberID + "\"}"; //letzter ohne , da dass } folgt

    msg = "";
    for(int i=0;i<= 8 ;i++){
      msg = msg + Messages[i];
      Serial.println(Messages[i]);
    }
    //Serial.println();
    //Serial.println(msg);

    // Datensatz übertragen
    Serial.println();
    Serial.println("Uebertragen: ");
    ServerPath = ("https://" + domain + "/api/" + tableDB + "?access_token=" + token);
    Serial.println(ServerPath);
    Data = JSON.parse(msg);
    Serial.println(JSON.stringify(Data));
    counter = 0;
    do {
      if(counter > 0){
        delay(1000);
      }
      ResponseCode = post_json_int(ServerPath, Data);
      counter ++;
      if (counter > max_Retry ) {
        Serial.println("ERROR: POST Messdaten nicht möglich!" );
      }
    } while ((ResponseCode != 200) && (counter <= max_Retry));
  
    Serial.println("Sleep");
    Serial.println();
    Serial.println();
    Serial.println();
    delay(IntervallTime-1000);    // Wartezeit einstellen
}
