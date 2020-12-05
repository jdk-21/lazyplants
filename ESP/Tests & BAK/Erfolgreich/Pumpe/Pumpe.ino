#define PumpePIN 17
bool pumpen = true;

void setup() {
  pinMode(PumpePIN, OUTPUT);
  Serial.begin(115200);//Test
}

void pump(int PIN, bool pumpe){
    if (pumpe){
        digitalWrite(PIN, LOW);
        Serial.println("ON");
    } else {
        digitalWrite(PIN, HIGH);
        Serial.println("OFF");
    }
}

void loop() {
    pump(PumpePIN, pumpen);
    pumpen = !pumpen;
    delay(5000);
}
