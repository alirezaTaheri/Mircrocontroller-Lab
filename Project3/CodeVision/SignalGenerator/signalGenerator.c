/*
 * signalGenerator.c
 *
 * Created: 24/10/2019 06:21:21 È.Ù
 * Author: Alireza
 */

#include <io.h>
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0xB2;
// Place your code here
  PORTA.0 = ~PORTA.0;
}

void main(void)
{
DDRA = 0xff;
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7/813 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// Timer Period: 9/984 ms
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0xB2;
OCR0=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
#asm("sei");
while (1)
    {
    // Please write your application code here

    }
}
