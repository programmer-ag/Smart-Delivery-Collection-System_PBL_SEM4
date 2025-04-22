#include<ESP32Servo.h>
#include "mqttUtil.h"
#define SERVO_PIN 13 
//bool dirFlag = 0;
Servo myServo;
bool motStatus = 0;
void Servo_setup()
{
    myServo.attach(SERVO_PIN);
    myServo.write(0);
}

void Servo_Con() //Control the servo motor, called from callback in mqttUtil.cpp,
{
    Serial.print("yes");
    if(motStatus==0)
    {
        for (int angle = 0; angle <= 90; angle++) {
        myServo.write(angle);  
        delay(15);             
        }
        Serial.print("rot1");
    }
    else
    {
        for (int angle = 90; angle >= 0; angle--) {
        myServo.write(angle);
        delay(15);
        }
        Serial.print("rot2");
    }
    motStatus=!motStatus;  
    delay(100);
}

void Servo_Lock()
{
    if(motStatus==0)
    {
        for (int angle = 0; angle <= 90; angle++) {
        myServo.write(angle);  
        delay(15);             
        }
        Serial.print("rot1");
        motStatus = 1;
        publish_servo();
    }
}

