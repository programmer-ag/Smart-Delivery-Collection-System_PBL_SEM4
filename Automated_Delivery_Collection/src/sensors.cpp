#include"utility.h"
#include<Arduino.h>
#include<NewPing.h>
#define MAGNETIC_SENSOR_PIN 14
#define ULTRASONIC_SENSOR_TRIGGER_PIN 5
#define ULTRASONIC_SENSOR_ECHO_PIN 18
#define ULTRASONIC_MAX_DISTANCE 400

// for Ultrasound
NewPing sonar(ULTRASONIC_SENSOR_TRIGGER_PIN,ULTRASONIC_SENSOR_ECHO_PIN,ULTRASONIC_MAX_DISTANCE);

//Setup Programs

void MagneticContactSensor_setup()
{
    pinMode(MAGNETIC_SENSOR_PIN, INPUT_PULLUP); 
}

// void UltrasonicSensor_setup()
// {
//     pinMode(ULTRASONIC_SENSOR_PIN,INPUT);
// }


//Working Programs

int MagneticContactSensor()
{
    int sensorState = digitalRead(MAGNETIC_SENSOR_PIN);
    bool data;
    if (sensorState == LOW) 
    {
           data=1;
    } 
    else 
    {
         data=0;
    }

    delay(200);  // Delay to avoid rapid state changes
    return data;
}

unsigned int UltrasonicSensor()
{
    delay(50);  
    unsigned int distance = sonar.ping_cm();  
    Serial.print("Distance: ");
    Serial.print(distance);
    Serial.println(" cm");
    delay(50);
    return distance;
}

