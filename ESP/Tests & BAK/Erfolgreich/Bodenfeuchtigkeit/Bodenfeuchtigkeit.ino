#include <Esp.h>
#include <Arduino.h>

#define BodenfeuchtigkeitPIN 12
#define feuchtemin 0
#define feuchtemax 3571 // Erfahrungswert Arduino Reference sagt max. 4095  //TODO: kallibrieren

void setup() {
    Serial.begin(115200);//Test
}

int bodenfeuchte(int PIN){
    int value = analogRead(PIN);
    Serial.print("Messwert: ");
    Serial.println(value);
    value = (((value - feuchtemin) *100) /feuchtemax);
    Serial.print("Normwert: ");
    Serial.println(value);
    return value;
}

void loop() {
    bodenfeuchte(BodenfeuchtigkeitPIN);
    delay(5000);
}
