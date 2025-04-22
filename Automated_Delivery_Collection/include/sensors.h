#ifndef SENSORS
#define SENSORS
#include<NewPing.h>
extern NewPing sonar;

void MagneticContactSensor_setup();
bool MagneticContactSensor();
unsigned int UltrasonicSensor();
#endif