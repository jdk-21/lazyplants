#include <NewPing.h>  // include NewPing library

int trigPin = 4;      // trigger pin
int echoPin = 0;      // echo pin

NewPing sonar(trigPin, echoPin);

void setup() {
  Serial.begin(115200);
  delay(500);
  Serial.println("Setup");
}

void loop() {
  float distance = sonar.ping_median(5);

  if (distance > 400 || distance < 2) Serial.println("Out of range");
  else
  {
    Serial.print("Distance: ");
    Serial.print(distance, 1); Serial.println(" cm");
  }

  delay(50);
}
