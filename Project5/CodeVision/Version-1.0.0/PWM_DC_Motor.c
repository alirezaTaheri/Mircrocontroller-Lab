/*
 * PWM_DC_Motor.c
 *
 * Created: 31/10/2019 02:35:49 È.Ù
 */

#include <io.h>
#include <delay.h>
#include <stdbool.h>
#include <alcd.h> 
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#define DEBOUNCE_TIME 2 
int increasePressedCount;
int decreasePressedCount;
int bothPressedCount = 0;
bool increasePressed;
bool decreasePressed;

void enterConfigureMode();
void exitConfigureMode();
void clearNCharOnXY(int n, int x, int y);
void showStringOnXY(int x, int y, char *string);
char* toString(unsigned long x);
bool reversed = false;
bool configureMode = false;
int stepSize = 60;
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
   if (increasePressed)
       increasePressedCount++;
   
   if (decreasePressed)
       decreasePressedCount++;
   
   if (increasePressed && decreasePressed)
       bothPressedCount++;
   else bothPressedCount = 0;
       
   if (increasePressed && decreasePressed && bothPressedCount == DEBOUNCE_TIME && configureMode){
       configureMode = false;
       exitConfigureMode();
       bothPressedCount++;
       
       }
       
   if (increasePressed && decreasePressed && bothPressedCount == DEBOUNCE_TIME && !configureMode){
       configureMode = true;
       enterConfigureMode();
       }
          
   if (!configureMode && increasePressed && increasePressedCount >= DEBOUNCE_TIME){
   if (!reversed){ 
      if (OCR1A + stepSize <= 511){
         OCR1A += stepSize;
      }else {
         OCR1A  = 511;
      }
   }else{
     if (OCR1B - stepSize <= OCR1B)
         OCR1B -= stepSize;
      else {
         OCR1B  = 0;
         reversed = false;
      }
   }
   clearNCharOnXY(0,0,0);
   showStringOnXY(0,0,toString(OCR1A));
   delay_ms(10);
   clearNCharOnXY(0,0,1);
   showStringOnXY(0,1,toString(OCR1B));
   }
    if (!configureMode && decreasePressed && decreasePressedCount >= DEBOUNCE_TIME){
        if (!reversed){
      if (OCR1A - stepSize <= OCR1A)
         OCR1A -= stepSize;
      else {
         OCR1A  = 0;
         reversed = true;
      }
   }else{
     if (OCR1B + stepSize <= 511)
         OCR1B += stepSize;
      else {
         OCR1B  = 511;
      }
   }
   clearNCharOnXY(0,0,0);
   showStringOnXY(0,0,toString(OCR1A));  
   delay_ms(10);
   clearNCharOnXY(0,0,1);
   showStringOnXY(0,1,toString(OCR1B));
    } 
    
    if (configureMode && increasePressed && increasePressedCount >= DEBOUNCE_TIME){
        stepSize++;
        clearNCharOnXY(0,0,1);
        showStringOnXY(0,1,toString(stepSize));
    }
       
    if (configureMode && decreasePressed && decreasePressedCount >= DEBOUNCE_TIME){
        stepSize--;
        clearNCharOnXY(0,0,1);
        showStringOnXY(0,1,toString(stepSize));
    }
    /*   
   if (increasePressed && increasePressedCount >= DEBOUNCE_TIME){
    if (increasePressedCount % DEBOUNCE_TIME == DEBOUNCE_TIME -1){
       if (OCR1AL + 10 <= 254){
       OCR1AL+=10;
       clearNCharOnXY(6,0, 1); 
       showStringOnXY(0, 1, toString(OCR1AL));
       }
       else {OCR1AL = 254;
       clearNCharOnXY(6,0, 1); 
       showStringOnXY(0, 1, toString(OCR1AL));
       OCR1AL = 0;
       }
       
       }
       else if (increasePressedCount == DEBOUNCE_TIME){
       if (OCR1AL + 10 <= 254){
       OCR1AL+=10;
       clearNCharOnXY(6,0, 1); 
       showStringOnXY(0, 1, toString(OCR1AL));
       }
       else {OCR1AL = 254;
       clearNCharOnXY(6,0, 1); 
       showStringOnXY(0, 1, toString(OCR1AL));
       OCR1AL = 0;
       }                  
       clearNCharOnXY(16,0,0);
       showStringOnXY(0, 0, "Increasing...");
       clearNCharOnXY(16,0, 1); 
       showStringOnXY(0, 1, toString(OCR1AL));
       }
       }
   if (decreasePressed && decreasePressedCount > DEBOUNCE_TIME){
       OCR2--;       
       clearNCharOnXY(16,0,0);
       showStringOnXY(0, 0, "Decreasing...");
       clearNCharOnXY(16,0, 1); 
       showStringOnXY(0, 1, toString(OCR2));
       } 
       */
}
	//unsigned char duty;
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    if (PIND.2 == 0){
        increasePressed = true;
    }else{
        increasePressedCount = 0;
        increasePressed = false;
    }
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
     if (PIND.3 == 0){
        decreasePressed = true;     
     }else{
        decreasePressed = false;
        decreasePressedCount = 0;
     }
}

void main(void)
{
lcd_init(16); 
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7/813 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// Timer Period: 14/976 ms
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x8B;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 125/000 kHz
// Mode: Ph. correct PWM top=0x01FF
// OC1A output: Non-Inverted PWM
// OC1B output: Non-Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 8/176 ms
// Output Pulse(s):
// OC1A Period: 8/176 ms Width: 0 us
// OC1B Period: 8/176 ms Width: 0 us
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
/*
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
*/
//OCR1A = 65000;
OCR1A = 0;
OCR1B = 0;
// Port D initialization
// Function: Bit7=Out Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(1<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
PORTD.2 = 1;
PORTD.3 = 1;
 
// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Any change
// INT1: On
// INT1 Mode: Any change
// INT2: Off
GICR|=(1<<INT1) | (1<<INT0) | (0<<INT2);
MCUCR=(0<<ISC11) | (1<<ISC10) | (0<<ISC01) | (1<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(1<<INTF1) | (1<<INTF0) | (0<<INTF2);


// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);

// Global enable interrupts
#asm("sei")
 
   clearNCharOnXY(0,1,0);
   showStringOnXY(0,1,toString(OCR1B));
   clearNCharOnXY(0,0,0);
   showStringOnXY(0,0,toString(OCR1A));
while (1)
    {
    
    }
}
void clearNCharOnXY(int n, int x, int y){
        /*char *blank = "";
        int a;
        lcd_gotoxy(x, y);
        for (a = 0; a< n;a++)
            strcat(blank, " ");
            */
            lcd_gotoxy(0, y);
        lcd_puts("                ");
}

void showStringOnXY(int x, int y, char *string){
        lcd_gotoxy(x, y);
        lcd_puts(string);    
    }

char* toString(unsigned long x){
    char string[55];
    ltoa(x,string);
    return string;
}

void enterConfigureMode(){    
   clearNCharOnXY(0,1,0);
   showStringOnXY(0,1,toString(stepSize));
   clearNCharOnXY(0,0,0);
   showStringOnXY(0,0,"Step Size:");
}

void exitConfigureMode(){
   clearNCharOnXY(0,1,0);
   showStringOnXY(0,1,toString(OCR1B));
   clearNCharOnXY(0,0,0);
   showStringOnXY(0,0,toString(OCR1A));
}