#include <Esp.h>
#include <Arduino.h>

#define BodenfeuchtigkeitPIN 36
#define BodenfeuchtigkeitPIN2 35
#define feuchtemin 0
#define feuchtemax 4095 // Erfahrungswert Arduino Reference sagt max. 4095  //TODO: kallibrieren

void setup() {
    Serial.begin(115200);//Test
}

int bodenfeuchte(int PIN){
    int value = analogRead(PIN);
    Serial.print("Messwert: ");
    Serial.println(value);
    value = (((value - feuchtemin) *100) /feuchtemax);
    //Serial.print("Normwert: ");
    //Serial.println(value);
    return value;
}

void loop() {
    Serial.print("1 ");
    bodenfeuchte(BodenfeuchtigkeitPIN);
    //Serial.print("2 ");
    //bodenfeuchte(BodenfeuchtigkeitPIN2);
    delay(1000);
}
