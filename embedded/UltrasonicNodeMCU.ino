#include <ESP8266WiFi.h>
#include <SoftwareSerial.h>
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

SoftwareSerial NodeMCU(D2, D3);

#define WIFI_SSID "MMR "
#define WIFI_PASSWORD "12345678"
#define API_KEY "AIzaSyAUAsjd0SwXlMm8IlDTP5nQWVh5mBH1ccw"
#define DATABASE_URL "https://nodemcutest-ae41d-default-rtdb.firebaseio.com/"

double ultra_data;
double capacity;
double percentage;
bool motor_status;
bool isreached;

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
bool signUpOK = false;

const int buzzer = D4;
const int trigPin = D0;
const int echoPin = D1;

void setup()
{
  Serial.begin(9600);
  NodeMCU.begin(4800);
  pinMode(D2, INPUT);
  pinMode(D3, OUTPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(buzzer, OUTPUT);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wifi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected With IP:");
  Serial.println(WiFi.localIP());
  Serial.println();
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  if (Firebase.signUp(&config, &auth, "", ""))
  {
    Serial.println("Signup OK");
    signUpOK = true;
  }
  else
  {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }
  config.token_status_callback = tokenStatusCallback;
  Firebase.begin(&config, &auth);
  ultra_data = 0;
  motor_status = false;
  isreached = false;
  capacity = 0;
}

void loop()
{

  if (Firebase.ready() && signUpOK && (millis() - sendDataPrevMillis > 5000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();
  }
  long duration;
  digitalWrite(trigPin, LOW);
  delay(500);
  digitalWrite(trigPin, HIGH);
  delay(250);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  ultra_data = microsecondsToCentimeters(duration);
  if (Firebase.RTDB.setDouble(&fbdo, "Sensor/ultra_data", ultra_data))
  {
    Serial.println();
    Serial.println("Successfully Saved to:" + fbdo.dataPath());
    Serial.println(fbdo.dataType());
  }
  else
  {
    Serial.println("Failed:" + fbdo.errorReason());
  }
  if (Firebase.RTDB.getDouble(&fbdo, "Sensor/max_val"))
  {
    capacity = fbdo.doubleData();
  }
  else
  {
    Serial.println("Failed:" + fbdo.errorReason());
  }
  if (Firebase.RTDB.getDouble(&fbdo, "Sensor/motor_status"))
  {
    motor_status = fbdo.boolData();
  }
  else
  {
    Serial.println("Failed:" + fbdo.errorReason());
  }
  percentage = (100 - ((ultra_data / capacity) * 100));
  Serial.printf("Motor Status: %d\nCapacity: %lf\nPercentage: %lf", motor_status, capacity, percentage);
  if (motor_status && capacity != 0 && percentage >= 90)
  {
    isreached = true;
  }
  if (isreached)
  {
    NodeMCU.print("10");
    NodeMCU.print("\n");
    Serial.print("Reached Limit..");
    tone(buzzer, 1000);
    delay(1000);
    noTone(buzzer);
    if (Firebase.RTDB.setBool(&fbdo, "Sensor/motor_status", false))
    {
      Serial.println();
      Serial.println("Successfully Saved to:" + fbdo.dataPath());
    }
    else
    {
      Serial.println("Failed:" + fbdo.errorReason());
    }
    motor_status = false;
    isreached = false;
  }
  delay(1000);
}

double microsecondsToCentimeters(long microseconds)
{
  return microseconds / 29 / 2;
}