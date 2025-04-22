#ifndef EN_SLEEP
#define EN_SLEEP
#include<ESP32Servo.h>
extern bool sleepFlag;
extern RTC_DATA_ATTR int bootCount;
void en_setup();
#endif