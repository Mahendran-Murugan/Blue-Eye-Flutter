#include <SoftwareSerial.h>
SoftwareSerial ArduinoUno(3, 2);

int relayPin = 8;
int status = 1;

void setup()
{
    pinMode(relayPin, OUTPUT);
    Serial.begin(9600);
    ArduinoUno.begin(4800);
}

void loop()
{
    digitalWrite(relayPin, status);
    while (ArduinoUno.available() > 0)
    {
        float val = ArduinoUno.parseFloat();
        if (ArduinoUno.read() == '\n')
        {
            status = 0;
            digitalWrite(relayPin, status);
            Serial.println(val);
        }
    }
    delay(30);
}