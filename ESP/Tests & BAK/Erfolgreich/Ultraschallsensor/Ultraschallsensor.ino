/* Name: Steuerung ESP
 * Projekt: LazyPlants
 * Erstelldatum:  01.11.2020 18:00
 * Änderungsdatum: 11.11.2020 09:30
 * Version: 0.0.1
 * History:
 */
 
//Declarationen

  //Sensoren 
  #define ultraschalltrigger 34 // Arduino Pin an HC-SR04 Trig
  #define ultraschallecho 35    // Arduino Pin an HC-SR04 Echo

  //weitere Parameter
  #define Tankhoehe 30 //Angabe in cm bei denen der Sensor den Tank als leer erkennt

  #include <Esp.h>

void setup() {
  pinMode(ultraschalltrigger, OUTPUT);
  pinMode(ultraschallecho, INPUT);
  Serial.begin(115200);//Test
}

// Funktionen
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
  
  int fuellsstand(){
    int Value = entfernung();
    return (Value/Tankhoehe *100);
  }


//Main
void loop() {
  Serial.print("Entfernung: ");
  Serial.println(entfernung());
  Serial.println();
  delay(2500);  
}
  
