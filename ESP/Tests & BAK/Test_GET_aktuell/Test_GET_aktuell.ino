/* Name: Steuerung Test
 * Projekt: LazyPlants
 * Erstelldatum:  10.11.2020 18:00
 * Änderungsdatum: 16.11.2020 16:30
 * Version: 0.0.3
 * History:
 */


#include "Module.h"
#include <WiFi.h>
#include <HTTPClient.h>
#include <Arduino_JSON.h>
#include <String>

#define max_n_Value 4

String ipadresse = "178.238.227.46:3000";
String token = "SNpOnjeteBHV9fRGyaYQUrQx6VFp9qWxnOqmQ5WBj3Ty99iqoFYzSZVWy9z3RHms";
String table = "Members";
String id = "";
//String filter = "&filter[where][UserID]=1&filter[where][PlantID]=1"; //z.B. &filter[where][UserID]=1&filter[where][PlantID]=1
String filter = "";
//String ServerPath = ("http://"+ipadresse+"/api/"+ table + id + "?access_token=" + token + filter);
String ServerPath = ("http://"+ipadresse+"/api/"+ table+"/login?");
const char* ssid = "TrojaNet";
const char* password = "50023282650157230429";

/*{
"email":"test@gmail.com",
"password":"test"
}*/
JSONVar login(String email, String pw){
  table = "Members";
  JSONVar answer;
  String msg;
  String Ans;
  int ResponseCode;

  HTTPClient http;
  http.begin(ServerPath);
  
  http.addHeader("Content-Type", "application/json"); // Typ des Body auf json Format festlegen
  ServerPath = ("http://"+ ipadresse +"/api/"+ table +"/login?");
  msg = "{\"email\":\""+ email +"\",\"password\":\""+ pw +"\"}";

  ResponseCode = http.POST(msg);
  Ans = http.getString();
  answer = JSON.parse(Ans);
  translate(ResponseCode);
  http.end();
  return answer;
}

void setup() {
  JSONVar test;
  Serial.begin(115200);
  connect(ssid, password);
  test = login("test@gmail.com","test");
  Serial.print("Token: ");
  Serial.println(test["id"]);
}



void loop() {
}
