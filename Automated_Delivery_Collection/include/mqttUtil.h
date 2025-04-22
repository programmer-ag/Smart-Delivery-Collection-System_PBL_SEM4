#ifndef MQTTUTIL
#define MQTTUTIL
#include<WiFiClientSecure.h>
#include<PubSubClient.h>


extern WiFiClientSecure espClient;
extern PubSubClient mq_client;
void mqtt_setup();
void publish_ultrasonic_data(String data);
void publish_magCon_data(String data);
void subscribe_servo();
void publish_servo();

#endif