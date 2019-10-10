/*
 * simpler.c
 *
 * Created: 10/10/2019 03:20:42 È.Ù
 * Author: Alireza
 */

#include <io.h>

#include <mega16.h>
#include <delay.h>

#define ON 1
#define OFF 0
#define LED PORTA.0
#define WORKING PIND.0
#define FREQ PIND.1
#define DEFAULT_DELAY_TIME 100

    // wait function that make delay, due to the status of frequency pins
    void wait(){
        int delay_time = 0;
        if (FREQ == ON)          //maximum toggle frequency
            delay_time = DEFAULT_DELAY_TIME/4;
        else 
            delay_time = DEFAULT_DELAY_TIME;
    
            delay_ms (delay_time);                  // Do delay
    }

    void main(void){
        LED = 0;          //initialize LED off
        DDRA = 0x11;      //set port A as output
        DDRD = 0x00;      //set port D as input

        while (1){
            if (WORKING){     //Check if enable button is on
                LED = ~ LED;    // Toggle the LED status
                wait();         //Wait for a moment
            }
        }
    }

