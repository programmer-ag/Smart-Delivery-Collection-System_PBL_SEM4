#include<Arduino.h>
#include "motor_control.h"
#include "utility.h"
// #define WAKEUP_PIN 2
#define REDLED 27
#define GREENLED 25
#define DOOR_SENSOR_PIN 14
#define WAKE_UP_PIN 2
void printWakeupReason() 
{
    esp_sleep_wakeup_cause_t wakeupReason = esp_sleep_get_wakeup_cause();
    switch (wakeupReason) {
        case ESP_SLEEP_WAKEUP_EXT0: 
            Serial.println("Wakeup caused by external signal using RTC_IO");
            break;
        case ESP_SLEEP_WAKEUP_EXT1: 
            Serial.println("Wakeup caused by external signal using RTC_CNTL");
            break;
        default:
            Serial.println("Wakeup was not caused by deep sleep");
            break;
    }
}

RTC_DATA_ATTR int bootCount = 0;
bool sleepFlag=0;
void en_setup()
{
    pinMode(DOOR_SENSOR_PIN, INPUT_PULLUP);
    pinMode(WAKE_UP_PIN, INPUT_PULLUP);
    if(DOOR_SENSOR_PIN )
    if(sleepFlag==0)
    {
        esp_sleep_enable_ext0_wakeup((gpio_num_t)WAKE_UP_PIN, 1);
        LEDOFF(REDLED);
        LEDON(GREENLED);
        Serial.println("Boot number: " + String(bootCount));
        sleepFlag = 1;
        ++bootCount;
    }

    printWakeupReason();

    if (digitalRead(DOOR_SENSOR_PIN) == HIGH || digitalRead(WAKE_UP_PIN)==HIGH) 
    {
        Serial.println("Performing Action");
        sleepFlag = 1;
        LEDOFF(REDLED);
        LEDON(GREENLED);
        //Serial.println("Door Closed - Preparing to sleep...");
        delay(200);
    }
    else
    {
        sleepFlag = 0;
        Servo_Lock();
        LEDOFF(GREENLED);
        LEDON(REDLED);
        Serial.println("Going to sleep now...");
        delay(1000);
        esp_deep_sleep_start();
    }

}
