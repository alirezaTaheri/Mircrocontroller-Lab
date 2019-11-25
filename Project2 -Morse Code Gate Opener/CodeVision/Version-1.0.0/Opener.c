/*
 * Opener.c
 *
 * Created: 13/10/2019 12:55:10 È.Ù
 * Author: Alireza
 */
#include <io.h>
#include <stdbool.h>
#include <stdio.h>
    int validationCode[] = {1, 1, 1, 1};
    int validationCodeLength = 4 ;
    //,1,1, 0,0,0};
    bool opened = false;
    bool pressed = false;
    int counter = 0;
    int codeLength = 0; 
    unsigned int digits[4] = {0x3f, 0x06, 0b01000000};
    int code[validationCodeLength] = {-1, -1, -1, -1};
    void checkCode(){
    bool correct = true;
    int a = 0;   
    //if (codeLength == validationCodeLength)
    for (a = 0; a<validationCodeLength ; a++){
        if (validationCode[a] != code[a])
            correct = false; 
    }// else correct = false; 
        if (correct){
          PORTC = digits[3];
          PORTA.0 = 1; 
        }
    }

    interrupt [TIM0_OVF] void timer0_ovf_isr(void){
        TCNT0=0xB2;
        if (pressed)
            counter++;
            if (pressed && counter == 7){
              PORTC = digits[0];
              code[codeLength] = 0;
              codeLength++;
              checkCode();
              }
              if (pressed && counter == 15){
              PORTC = digits[1];              
              code[codeLength-1] = 1;
              checkCode();            
              }
              
        //if (opened)
          //  PORTA.0 = 1;
          //  else PORTA.0 = 0;
    }     
    
    interrupt [EXT_INT0] void ext_int0_isr(void){
    if (PIND.2 == 1)
        pressed = true;
        else {pressed = false;
        counter = 0;
        PORTC = digits[2];
        } 

    }  
    
    interrupt [EXT_INT1] void ext_int1_isr(void){
    int b = 0;
        if (PIND.3 == 1){
        counter = 0;
        codeLength = 0;
        for (b = 0; b<validationCodeLength; b++)
        code[b] = -1;
        PORTA.0 = 0;        
        }                     
    }
    
void main(void){
    DDRA = 0b00000001;
    DDRD = 0b00000000;
    DDRC = 0xff;
    PORTC = 0b00000000;
    PORTC = digits[2];
    PORTA.0 = 0;
    TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
    TCNT0=0x06;
    OCR0=0x00;
    TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
    GICR|=(1<<INT1) | (1<<INT0) | (0<<INT2);
    MCUCR=(0<<ISC11) | (1<<ISC10) | (0<<ISC01) | (1<<ISC00);
    MCUCSR=(0<<ISC2);
    GIFR=(1<<INTF1) | (1<<INTF0) | (0<<INTF2);

    #asm("sei");
while (1){
        
    }
}
