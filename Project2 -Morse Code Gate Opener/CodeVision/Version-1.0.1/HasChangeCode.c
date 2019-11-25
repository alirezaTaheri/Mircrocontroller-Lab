/*
 * HasChangeCode.c
 *
 * Created: 13/10/2019 08:37:14 È.Ù
 * Author: Alireza
 */


#include <io.h>
#include <stdbool.h>
#include <stdio.h>
    int validationCode[] = {1, 1, 1, 1};
    int validationCodeLength = 4 ;
    //,1,1, 0,0,0};
    bool opened = false;
    bool inputPressed = false;
    bool resetPressed = false;
    bool oneAdded = false;
    int oneAddedCount = 0;
    int inputPressedCount = 0;
    int resetPressedCount = 0;
    bool changeCodeMode = false;
    int inputLength = 0; 
    unsigned int digits[4] = {0x3f, 0x06, 0b01000000};
    int input[validationCodeLength] = {-1, -1, -1, -1};
    
    
    void checkCode(){
    bool correct = true;
    int a = 0;   
    //if (inputLength == validationCodeLength)
    for (a = 0; a<validationCodeLength ; a++){
        if (validationCode[a] != input[a])
            correct = false; 
    }// else correct = false; 
        if (correct){
          PORTC = digits[3];
          PORTA.0 = 1;
          opened = true; 
        }
    } 
    
    void changeCode(){
    int a =0;
        for (a = 0; a<validationCodeLength;a++)
            validationCode[a] = input[a];
            inputPressedCount = 0;
        inputLength = 0;
        a = 0;
        for (a = 0; a<validationCodeLength; a++)
        input[a] = -1;
        PORTA.0 = 0;
        opened = false;
        changeCodeMode = false;    
    }

    interrupt [TIM0_OVF] void timer0_ovf_isr(void){
        TCNT0=0xB2;
        if (inputPressed)
            inputPressedCount++;
        if (resetPressed)
            resetPressedCount++;
            if (!changeCodeMode && inputPressed && inputPressedCount == 13){
              PORTC = digits[0];
              input[inputLength] = 0;
              inputLength++;
              PORTB.0 = 1;
              oneAdded = true;
              oneAddedCount = 1;
              checkCode();
              }
              if (!changeCodeMode && inputPressed && inputPressedCount == 22){
              PORTC = digits[1];              
              input[inputLength-1] = 1;
              PORTB.0 = 1;
              oneAdded = true;
              oneAddedCount = 1;
              checkCode();            
              } 
              
            if (changeCodeMode && inputPressed && inputPressedCount == 13){
              PORTC = digits[0];
              input[inputLength] = 0;
              inputLength++;
              PORTB.0 = 1;
              oneAdded = true;
              oneAddedCount = 1;
              
              }
              if (changeCodeMode && inputPressed && inputPressedCount == 22){
              PORTC = digits[1];              
              input[inputLength-1] = 1;
              PORTB.0 = 1;
              oneAdded = true;
              oneAddedCount = 1;
              if (inputLength == validationCodeLength)
                changeCode();            
              }
              if (resetPressed && resetPressedCount == 15 && !changeCodeMode){
                 changeCodeMode = true;
              }  
              else if (resetPressed && resetPressedCount == 15 && changeCodeMode){
                 changeCodeMode = false;
                 resetPressedCount = 0;
                 PORTA.0 = 0; 
              } 
              if (changeCodeMode)
                PORTA.0 = ~PORTA.0;
                if (oneAdded && oneAddedCount > 0){
                PORTB.0 = 0;
                oneAddedCount--;                       
                }
    }     
    
    interrupt [EXT_INT0] void ext_int0_isr(void){
    if (PIND.2 == 1){
        if (!changeCodeMode){
        inputPressed = true;
        }else if (changeCodeMode) inputPressed = true;}
        else {
        if (!changeCodeMode){
        inputPressed = false;
        inputPressedCount = 0;
        PORTC = digits[2];
        }else if (changeCodeMode){
        if (inputPressedCount > 13)
            if (inputLength == validationCodeLength)
                changeCode();
            inputPressed = false;
            inputPressedCount = 0;
            PORTC = digits[2];
        }
            } 

    }  
    
    interrupt [EXT_INT1] void ext_int1_isr(void){
    int b = 0;
        if (PIND.3 == 1){
        if (!changeCodeMode){
        resetPressed = true;
        inputPressedCount = 0;
        inputLength = 0;
        for (b = 0; b<validationCodeLength; b++)
        input[b] = -1;
        PORTA.0 = 0;
        opened = false;
        }
        else if (changeCodeMode){
        resetPressed = true;
        resetPressedCount = 0;
        inputLength = 0;
        for (b = 0; b<validationCodeLength; b++)
        input[b] = -1;   
        }        
        }else if (PIND.3 == 0) {resetPressed = false;
        resetPressedCount = 0;
        } 
    }
    
void main(void){
    DDRA = 0b00000001;
    DDRB = 0b00000001;
    DDRD = 0b00000000;
    DDRC = 0xff;
    PORTC = 0b00000000;
    PORTC = digits[2];
    PORTA.0 = 0;
    PORTB.0 = 0;
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

