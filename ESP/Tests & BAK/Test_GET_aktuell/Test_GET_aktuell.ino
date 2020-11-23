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

JSONVar login(){
  HTTPClient http;
  http.begin(ServerPath);
  //http.addHeader("Content-Type", "application/json "); // Typ des Body auf json Format festlegen

  JSONVar answer;
  String msg;
  String A;
  for(int i=1;i<=4;i++){
    Serial.print(i);
    Serial.print(": ");
    if ((i%2) == 0){
      Serial.print("H2 ");
      http.addHeader("Content-Type", "application/json","charset=utf-8","Content-Length=160"); // Typ des Body auf json Format festlegen
    } else{
      Serial.print("H1 ");
      http.addHeader("Content-Type", "application/json"); // Typ des Body auf json Format festlegen
    }
    table = "Members";
    ServerPath = ("http://"+ipadresse+"/api/"+ table+"/login?");
    if(i>(i/2)){
      ServerPath.remove(ServerPath.length()-1);
    }
    Serial.println(ServerPath);
    JSONVar body = JSON.parse("{\"email\":\"test@gmail.com\",\"password\":\"test\"}");
    msg = JSON.stringify(body);
    A = http.POST(msg);
    Serial.print(A);
    A = http.getString();
    Serial.print(A);
    answer = JSON.parse(A);
    Serial.print("\t \t");
    translate(answer);
    if(answer["id"] != null && answer["userId"] != null){
      break;
    }
  }
  Serial.println();
  Serial.println(msg);
  if (answer["id"] != null || answer["userId"] != null){
    Serial.print("token: ");
    Serial.println(answer["id"]);
    Serial.print("UserID: ");
    Serial.println(answer["userId"]);
  }
  return answer;
}

void setup() {
  Serial.begin(115200);
  connect(ssid, password);
  login();
}



void loop() {
  /*
  JSONVar J = get_json(ServerPath);
  delay(1000);
  Serial.println("---------------------");
  J["water"] = !(J["water"]);
  patch_json(ServerPath, J);
  delay(10000);
  Serial.println();
  Serial.println();
  */
}
