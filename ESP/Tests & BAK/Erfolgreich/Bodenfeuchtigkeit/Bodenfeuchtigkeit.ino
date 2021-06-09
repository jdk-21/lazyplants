#include <Esp.h>
#include <Arduino.h>

#define BodenfeuchtigkeitPIN 26
#define feuchtemin 0
#define feuchtemax 4095 // Erfahrungswert Arduino Reference sagt max. 4095  //TODO: kallibrieren

void setup() {
    Serial.begin(115200);//Test
}

int bodenfeuchte(int PIN){
    int value = analogRead(PIN);
    Serial.print("Messwert: ");
    Serial.println(value);
    int prozent = map(value, feuchtemax, feuchtemin, 0, 100);
    value = 100-(((value - feuchtemin) *100) /feuchtemax);    
    Serial.print("Normwert: ");
    Serial.println(value);
    Serial.println(prozent);
    return value;
}

void loop() {
    bodenfeuchte(BodenfeuchtigkeitPIN);
    delay(5000);
}
