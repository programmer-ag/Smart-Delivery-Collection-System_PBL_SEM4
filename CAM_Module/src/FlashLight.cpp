#include<Arduino.h>
#define FLASH_LED_PIN 4  // Flashlight LED is connected to GPIO4

void flash_setup() {
  pinMode(FLASH_LED_PIN, OUTPUT);  // Set GPIO4 as an output
}

void Flash_ON() {
    
  digitalWrite(FLASH_LED_PIN, HIGH);  // Turn on flash LED
}

void Flash_OFF() 
{    
    digitalWrite(FLASH_LED_PIN, LOW);  // Turn off flash LED
}