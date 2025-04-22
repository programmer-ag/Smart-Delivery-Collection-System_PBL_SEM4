#include<Arduino.h>
// Program for LED Blinking

//LED Blink Patterns

void mainBlink()
{
    delay(500);
    digitalWrite(LED_BUILTIN,HIGH);
    delay(500);
    digitalWrite(LED_BUILTIN,LOW);
}

void LEDON(unsigned int a)
{
    pinMode(a,OUTPUT);
    digitalWrite(a,HIGH);
}

void LEDOFF(unsigned int a)
{
    pinMode(a,OUTPUT);
    digitalWrite(a,LOW);
}

void customLEDBlink(unsigned int a, int del)
{
    pinMode(a,OUTPUT);
    delay(del);
    digitalWrite(a,HIGH);
    delay(del);
    digitalWrite(a,LOW);
}

