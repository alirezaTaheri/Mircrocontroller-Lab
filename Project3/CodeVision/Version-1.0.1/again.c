/*
 * again.c
 *
 * Created: 24/10/2019 05:41:35 È.Ù
 * Author: Alireza
 */
#include <mega16.h> 
#include <alcd.h>
#include <stdlib.h>
char str[255];
/*define Port C as output for pulse width*/ #define period_out PORTC
unsigned char ov_counter;   /*counter for timer 1 overflow*/ unsigned int starting_edge, ending_edge;  /*storage for times*/ unsigned int clocks;   /*storage for actual clock counts in the pulse*/
/*Timer 1 overflow ISR*/ interrupt [TIM1_OVF] void timer1_ovf_isr(void) { ++ov_counter;   /*increment counter when overflow occurs*/ }
/*Timer 1 input capture ISR*/ interrupt [TIM1_CAPT] void timer1_capt_isr(void) {
/*combine the two 8-bit capture registers into the 16-bit count*/ ending_edge = 256*ICR1H + ICR1L; /*get end time for period*/ clocks = (unsigned long)ending_edge + ((unsigned long)ov_counter * 65536) - (unsigned long)starting_edge; period_out = ~(clocks / 750);  /*output milliseconds to Port C*/ /*clear overflow counter for this measurement*/ ov_counter = 0;  /*save end time to use as starting edge*/ starting_edge = ending_edge;
ltoa(~(clocks / 750), str);
lcd_gotoxy(0,0);
lcd_puts("Hello");
}
void main(void) { DDRC=0xFF;  /*set Port C for output*/ TCCR1A = 0;  /*disable all waveform functions*/ TCCR1B = 0xC2;/*Timer 1 input to clock/8, enable input capture*/ TIMSK = 0x24; /*unmask timer 1 overflow and capture interrupts*/
lcd_init(16);
#asm("sei") /*enable global interrupt bit*/
while (1) { ; /*do nothing here*/      }
} 
