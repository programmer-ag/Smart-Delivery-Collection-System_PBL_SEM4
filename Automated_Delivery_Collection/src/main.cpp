#include "sensors.h"
#include "WifiSet.h"
#include "dataprocess.h"
#include "mqttUtil.h"
#include "enable_sleep.h"
#include "motor_control.h"

void setup() {
  Serial.begin(921600);
  Serial.print("chk3");
  setupWifi(); //setup wifi enter credentials.src : WifiSet.h
  Serial.print("chk4");
  mqtt_setup();// setup mqtt client and connect to mqtt broker.src : mqttUtil.h
  Serial.print("chk6");
  MagneticContactSensor_setup();// configure reed switch pin. src : sensors.h
  Servo_setup();// Attach Servo motor to pwm pin. src : motor_control.h
  Serial.print("chk5");
}

void loop() {
  //en_setup();
  delay(300); //Delay added after every sensor call, for avoiding rapid current changes in microcontroller.
  checkWifi_Recon();//Every iteration, check for wifi connection. Connect if disconnected. src : WifiSet.h
  delay(300);
 // Serial.print("chk1");
  auxMagCon(); // get data from magnetic contact sensor, send to respective topic on mqtt, src : dataprocessing.h
  delay(300);
  auxUltrasonicSensor();// get data from Ultrasonic sensor, send to respective topic on mqtt, src : dataprocessing.h
  delay(300);
  subscribe_servo();//listen to data on mqtt broker about closing, src:mqttUtil.h
  delay(300);
 // Serial.print("chek2");
}

