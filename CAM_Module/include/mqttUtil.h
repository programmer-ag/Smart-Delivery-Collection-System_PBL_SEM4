#ifndef MQTTU
#define MQTTU
#include<PubSubClient.h>
#include<WiFiClientSecure.h>
extern WiFiClientSecure espClient;
extern PubSubClient mq_client;
void mqtt_setup();
void subscribe_flash();
#endif