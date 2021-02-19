
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
