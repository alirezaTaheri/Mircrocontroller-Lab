/*******************************************************
Project : LED_Blinking_Interrupt_Based
Version : 1.0.0
Date    : 05/10/2019
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
#define FREQ_1 PIND.2
#define FREQ_2 PIND.3
#define DEFAULT_DELAY_TIME 100

    unsigned int digits[4] = {0x3f, 0x06, 0x5b, 0x4f};
//0x66, 0x6d, 0xfd, 0x07, 0xff, 0b01101111    
    interrupt [EXT_INT0] void ext_int0_isr(void){
    FREQ_1 ^=1;
    if (FREQ_1 == ON && FREQ_2 == ON)          //maximum toggle frequency
            PORTC = digits[3];
        else if (FREQ_1 == ON && FREQ_2 == OFF)    //medium toggle frequency
            PORTC = digits[2];
        else if (FREQ_1 == OFF && FREQ_2 == ON)    //minimum toggle frequency
            PORTC = digits[1]; 
        else if (FREQ_1 == OFF && FREQ_2 == OFF)   //default toggle frequency
            PORTC = digits[0];
    }

// External Interrupt 1 service routine
    interrupt [EXT_INT1] void ext_int1_isr(void){
    FREQ_2 ^= 1;
   if (FREQ_1 == ON && FREQ_2 == ON)          //maximum toggle frequency
            PORTC = digits[3];
        else if (FREQ_1 == ON && FREQ_2 == OFF)    //medium toggle frequency
            PORTC = digits[2];
        else if (FREQ_1 == OFF && FREQ_2 == ON)    //minimum toggle frequency
            PORTC = digits[1]; 
        else if (FREQ_1 == OFF && FREQ_2 == OFF)   //default toggle frequency
            PORTC = digits[0];
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
        DDRA = 0xff;      //set port A as output
        DDRD = 0x00;      //set port D as input
        DDRC = 0xff;      //set port C as output for display toggle speed      
        FREQ_1 = OFF;     //initialize lsb of frequency
        FREQ_2 = OFF;     //initialize msb of frequency
        
        //General Interrupt Control Register 
        GICR|=(1<<INT1) | (1<<INT0) | (0<<INT2);   // we want to use int0 , int1. so enabling them by set INT1, INT2 to 1 and INT2 to 0
        
        //MCU Control Register
        //ISC = Interrupt Sense Control
        //we need to sense every change in two pins, so set both ISCs to : ISCx0 = 1, ISCx1 = 0
        MCUCR=(0<<ISC11) | (1<<ISC10) | (0<<ISC01) | (1<<ISC00);
                                       
        //MCU Control Status Register
        //just disabling interrupt 2
        MCUCSR=(0<<ISC2);            
        
        //General Interrupt Flag Register
        //Set Interrupt Flag for 0 and 1 to jump to corresponding isr
        GIFR=(1<<INTF1) | (1<<INTF0) | (0<<INTF2);
            
        //enable General Interrupt        
        #asm ("sei");    
        
        while (1){
            if (WORKING){     //Check if enable button is on
                LED = ~ LED;    // Toggle the LED status
                wait();         //Wait for a moment
            }
        }
    }

