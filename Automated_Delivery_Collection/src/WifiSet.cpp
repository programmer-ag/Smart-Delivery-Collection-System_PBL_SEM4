#ifndef WIFISET_H
#define WIFISET_H
#include<WiFi.h>
#include "utility.h"
#define WIFI_SSID "myWifi"
#define WIFI_PASSWORD "abcd1234"

//Wifi Setup in setup()
void setupWifi()
{
    delay(100);
    mainBlink();
    WiFi.begin(WIFI_SSID,WIFI_PASSWORD);

    while(WiFi.status()!=WL_CONNECTED)
    {
        mainBlink();
    }
   LEDON(LED_BUILTIN);
}

//Check WifiConnection in loop()
void checkWifi_Recon()
{
    if(WiFi.status()!=WL_CONNECTED)
    {
        //mainBlink();
    }
    else
    {
        LEDON(LED_BUILTIN);
    }
}

#endif