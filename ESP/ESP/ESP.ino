/* Name: Steuerung ESP
 * Projekt: LazyPlants
 * Erstelldatum:  01.11.2020 18:00
 * Änderungsdatum: 01.11.2020 18:00
 * Version: 0.0.1
 * History:
 */

//Declarationen
#define feuchtigkeitPin A0
#define ultraschalltrigger 3 // Arduino Pin an HC-SR04 Trig
#define ultraschallecho 2    // Arduino Pin an HC-SR04 Echo
#define feuchtemax 343 //bei 100% Wasser
#define feuchtemin 664 //bei 0% Wasser


void setup() {
  Serial.begin(9600);//Test
}

// Funktionen
int feuchtigkeit() {
  int sensorValue=0;
  sensorValue = analogRead(feuchtigkeitPin);
  sensorValue = -((sensorValue - feuchtemin)/feuchtemax * 100);  //für 3,3V am Feuchtigkeitssensor (nicht kapazentiv)
  //sensorValue = sensorValue * 100 / 1023; // Umrechnung in %
  return(sensorValue);
}

int entfernung(){
  long entfernung=0;
  long zeit=0;

  digitalWrite(ultraschalltrigger, LOW);
  delayMicroseconds(3);
  noInterrupts();
  digitalWrite(ultraschalltrigger, HIGH); //Trigger Impuls 10 us
  delayMicroseconds(10);
  digitalWrite(ultraschalltrigger, LOW);
  zeit = pulseIn(ultraschallecho, HIGH); // Echo-Zeit messen
  interrupts();
  zeit = (zeit/2); // Zeit halbieren
  entfernung = zeit / 29.1; // Zeit in Zentimeter umrechnen
  return(entfernung);
}

//Main
void loop() {
  delay(3000);
  Serial.println("Feuchte:");
  Serial.println(feuchtigkeit());
  Serial.println("Entfernung:");
  Serial.println(entfernung());
}
