#include <Esp.h>
#include <Arduino.h>

#define BodenfeuchtigkeitPIN 14
#define feuchtemin 0
#define feuchtemax 4095 // Erfahrungswert Arduino Reference sagt max. 4095  //TODO: kallibrieren
int value = 0;

void setup() {
    Serial.begin(115200);//Test    
}

int bodenfeuchte(int PIN){
    value = analogRead(PIN);
    Serial.print("Messwert: ");
    Serial.println(value);
    value = 100 - (((value - feuchtemin) *100) /feuchtemax);
    Serial.print("Normwert: ");
    Serial.println(value);
    return value;
}

void loop() {
    bodenfeuchte(BodenfeuchtigkeitPIN);
    delay(5000);
}
