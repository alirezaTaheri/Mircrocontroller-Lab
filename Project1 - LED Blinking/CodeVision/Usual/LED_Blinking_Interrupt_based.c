/*******************************************************
Project : LED_Blinking
Version : 1.0.0
Date    : 04/10/2019
Author  : Alireza Taheri

Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8/000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16.h>
#include <delay.h>

#define ON 1
#define OFF 0
#define LED PORTA.0
#define WORKING PIND.0
#define FREQ_1 PIND.1
#define FREQ_2 PIND.2
#define DEFAULT_DELAY_TIME 100

    interrupt [EXT_INT0] void ext_int0_isr(void){
    FREQ_1 = EXT_INT0;
    }

// External Interrupt 1 service routine
    interrupt [EXT_INT1] void ext_int1_isr(void){
    FREQ_2 = EXT_INT1;
    }
    // wait function that make delay, due to the status of frequency pins
    void wait(){
        int delay_time = 0;
        if (FREQ_1 == ON && FREQ_2 == ON)          //maximum toggle frequency
            delay_time = DEFAULT_DELAY_TIME/4;
        else if (FREQ_1 == ON && FREQ_2 == OFF)    //medium toggle frequency
            delay_time = DEFAULT_DELAY_TIME/3;
        else if (FREQ_1 == OFF && FREQ_2 == ON)    //minimum toggle frequency
            delay_time = DEFAULT_DELAY_TIME/2; 
        else if (FREQ_1 == OFF && FREQ_2 == OFF)   //default toggle frequency
            delay_time = DEFAULT_DELAY_TIME;
    
            delay_ms (delay_time);                  // Do delay
    }

    void main(void){
        LED = 0;          //initialize LED off
        PORTD = 0x00;     //initialize all pins of D by 0
        DDRA = 0x11;      //set port A as output
        DDRD = 0x00;      //set port D as input
                    
        
GICR|=(1<<INT1) | (1<<INT0) | (0<<INT2);
MCUCR=(0<<ISC11) | (1<<ISC10) | (0<<ISC01) | (1<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(1<<INTF1) | (1<<INTF0) | (0<<INTF2);
        #asm ("sei");
        while (1){
            if (WORKING){     //Check if enable button is on
                LED = ~ LED;    // Toggle the LED status
                wait();         //Wait for a moment
            }
        }
    }

