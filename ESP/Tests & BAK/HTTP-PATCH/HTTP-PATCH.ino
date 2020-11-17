#include "WiFi.h"
#include <HTTPClient.h>
#include "Module.h"

String ipadresse = "178.238.227.46:3000";
String token = "cwapZ8RI3Y8HtK09S5P8RpAaVGUwLgjrlBuKj308rZgt8K0bGkMEizTjeGhuE3eZ";
String table = "waterplants";
String id = "/5fb3804d76949e054eeae501";
String filter = ""; //z.B. &filter[where][UserID]=1&filter[where][PlantID]=1
String ServerPath = ("http://"+ipadresse+"/api/"+ table + id + "?access_token=" + token + filter + " Htttp/1.1");
//http://178.238.227.46:3000/api/waterplants/5fb3804d76949e054eeae501?access_token=cwapZ8RI3Y8HtK09S5P8RpAaVGUwLgjrlBuKj308rZgt8K0bGkMEizTjeGhuE3eZ Htttp/1.1
const char* ssid = "TrojaNet";
const char* password = "50023282650157230429";

int patch(){
    // http://178.238.227.46:3000/api/plants_data?access_token=Fm8ctl15LypUYt6ICN6kA3M2BlVrwF9KCMijBPSfqAGtHMv220PAZSHvisDZxBq6 //POST
    // HTTP header
    // TEST
    HTTPClient http;
    //http.begin(ServerPath + "&filter[where][UserID]=1&filter[where][PlantID]=1");
    http.begin(ServerPath);
    http.addHeader("Content-Type", "application/json"); //Typ des Body auf json Format festlegen
    //int httpResponseCode = http.POST("{\"UserID\":\"1\",\"PlantID\":\"1\",\"water\":\"false\",\"date\":\"2020-11-16T10:54:25.035Z\"}");
    int httpResponseCode = http.PATCH("{\"water\":\"false\"\"}");
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);    
    
    http.end();
    return httpResponseCode;
  }

void setup() {
  
  Serial.begin(115200);
  delay(500);
  bool Stop = false;
  int counter = 0;
  bool status = connect(ssid,password);
  while (!status && !Stop){
    counter++;
    status = connect(ssid,password);
    if (counter > 5){
      Stop = true;
    }
  }
  counter = 0;
  Stop = false;
  int ResponseCode = patch();
  while ((ResponseCode != 200) && !(Stop)){
    counter ++;
    ResponseCode = patch();
    delay(1000);
    if (counter >= 13){
      Stop = true;
      Serial.println("ERROR max. Versuche erreicht");
    }
  }
}
 
void loop() {}
