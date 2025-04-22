#include"sensors.h"
#include"mqttUtil.h"
#include<Arduino.h>
String us_data = "ini";
void auxUltrasonicSensor()
{
    unsigned int distance = UltrasonicSensor();
    String data;
    if(distance<=15)
    {
        data = "placed";
    }
    else
    {
        data= "unplaced";
    }
    Serial.print(data);
    if(!us_data.equals(data))
    {
        publish_ultrasonic_data(data);
        us_data = data;
    }
    delay(100);
}
String mc_data = "ini";
void auxMagCon()
{
    bool status = MagneticContactSensor();
    String data;
    if(status==1)
    {
        data = "close";
    }
    else
    {
        data = "open";
    }
    if(!mc_data.equals(data))
    {
        publish_magCon_data(data);
        mc_data = data;
    }
    Serial.print(data);
}
