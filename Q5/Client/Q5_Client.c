/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 12/11/2020
Author  :
Company :
Comments:


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>

// Alphanumeric LCD functions
#include <alcd.h>

// SPI functions
#include <spi.h>

#include <delay.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#define KEYPAD_R1 PORTC.0
#define KEYPAD_R2 PORTC.1
#define KEYPAD_R3 PORTC.2
#define KEYPAD_R4 PORTC.3
#define KEYPAD_C1 PINC.4
#define KEYPAD_C2 PINC.5
#define KEYPAD_C3 PINC.6

#define KEYPAD_NUM0 0
#define KEYPAD_NUM1 1
#define KEYPAD_NUM2 2
#define KEYPAD_NUM3 3
#define KEYPAD_NUM4 4
#define KEYPAD_NUM5 5
#define KEYPAD_NUM6 6
#define KEYPAD_NUM7 7
#define KEYPAD_NUM8 8
#define KEYPAD_NUM9 9
#define KEYPAD_STAR  10
#define KEYPAD_HASH  11

// Declare your global variables here
char data[20] = "";

unsigned char key;
unsigned char index;

bool calced = false;
bool first_num = true;


unsigned char keypad_input();
char read();
void calculate();
void send_data(char* d);

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=Out Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
DDRB=(1<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=0 Bit6=T Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 2000.000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
SPSR=(0<<SPI2X);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTA Bit 0
// RD - PORTA Bit 1
// EN - PORTA Bit 2
// D4 - PORTA Bit 4
// D5 - PORTA Bit 5
// D6 - PORTA Bit 6
// D7 - PORTA Bit 7
// Characters/line: 16
lcd_init(16);

while (1)
      {

          key = keypad_input();
          if (key != 255) {
              if (calced) {
                  lcd_clear();
                  data[0] = 0;
                  calced = false;
              }
              while(keypad_input() != 255);
              delay_ms(20);

              if (key >= 5 && key <= 9) {
                  first_num = true;
                  switch (key) {
                      case 5:
                      strcat(data, "5");
                      first_num = false;
                      break;
                      case 6:
                      strcat(data, "6");
                      first_num = false;
                      break;
                      case 7:
                      strcat(data, "7");
                      first_num = false;
                      break;
                      case 8:
                      strcat(data, "8");
                      first_num = false;
                      break;
                      case 9:
                      strcat(data, "9");
                      first_num = false;
                      break;

                  }
              }
              else if (key == 0) {
                      first_num = false;
                      strcat(data, "0");
              }
              else if ( (key <= 4 && key >= 1) || (key == KEYPAD_HASH || key == KEYPAD_STAR)){
                  switch (key) {
                      case 1:
                      lcd_clear();
                      lcd_puts("0:1, 1:+");

                      while(keypad_input() == 255);
                      index = keypad_input();

                      if (index == 0) {
                          strcat(data, "1");
                          first_num = false;
                      } else if (index == 1) {
                          if (!first_num) {
                              strcat(data, "+");
                              first_num = true;
                          }
                      }

                      delay_ms(200);
                      break;

                      case 2:
                      lcd_clear();
                      lcd_puts("0:2, 1:-");

                      while(keypad_input() == 255);
                      index = keypad_input();

                      if (index == 0) {
                          strcat(data, "2");
                          first_num = false;

                      } else if (index == 1) {
                          if (!first_num) {
                              strcat(data, "-");
                              first_num = true;
                          }
                      }

                      delay_ms(200);
                      break;

                      case 3:
                      lcd_clear();
                      lcd_puts("0:3, 1:x");

                      while(keypad_input() == 255);
                      index = keypad_input();

                      if (index == 0) {
                          strcat(data, "3");
                          first_num = false;

                      } else if (index == 1) {
                          if (!first_num) {
                              strcat(data, "x");
                              first_num = true;
                          }
                      }

                      delay_ms(200);
                      break;

                      case 4:
                      lcd_clear();
                      lcd_puts("0:4, 1:/");

                      while(keypad_input() == 255);
                      index = keypad_input();

                      if (index == 0) {
                          strcat(data, "4");
                          first_num = false;

                      } else if (index == 1) {
                          if (!first_num) {
                              strcat(data, "/");
                              first_num = true;
                          }
                      }

                      delay_ms(200);
                      break;

                      case KEYPAD_HASH:
                      lcd_clear();
                      lcd_puts("0:=, 1:.");

                      while(keypad_input() == 255);
                      index = keypad_input();

                      if (index == 0) {

                          calculate();

                          calced = true;

                      } else if (index == 1) {
                          if (!first_num) {
                              strcat(data, ".");
                              first_num = true;
                          }
                      }

                      delay_ms(200);
                      break;

                      case KEYPAD_STAR:

                      data[0] = 0;
                      first_num = true;
                      calced = false;

                      delay_ms(200);
                      break;
                  }
              }
              lcd_clear();
              lcd_puts(data);
          }
      }
}

unsigned char keypad_input(){

    unsigned char result = 255;
        ////////////////////////  ROW1 ////////////////////////
        KEYPAD_R1 = 1; KEYPAD_R2 = 0;  KEYPAD_R3 = 0;  KEYPAD_R4 = 0;
        delay_ms(5);
        if (KEYPAD_C1)
        result = KEYPAD_NUM1;
        else if (KEYPAD_C2)
        result = KEYPAD_NUM2;
        else if (KEYPAD_C3)
        result = KEYPAD_NUM3;


        ////////////////////////  ROW2 ////////////////////////
        KEYPAD_R1 = 0; KEYPAD_R2 = 1;  KEYPAD_R3 = 0;  KEYPAD_R4 = 0;
        delay_ms(5);
        if (KEYPAD_C1)
        result = KEYPAD_NUM4;
        else if (KEYPAD_C2)
        result = KEYPAD_NUM5;
        else if (KEYPAD_C3)
        result = KEYPAD_NUM6;


        ////////////////////////  ROW3 ////////////////////////
        KEYPAD_R1 = 0; KEYPAD_R2 = 0;  KEYPAD_R3 = 1;  KEYPAD_R4 = 0;
        delay_ms(5);
        if (KEYPAD_C1)
        result = KEYPAD_NUM7;
        else if (KEYPAD_C2)
        result = KEYPAD_NUM8;
        else if (KEYPAD_C3)
        result = KEYPAD_NUM9;


        ////////////////////////  ROW4 ////////////////////////
        KEYPAD_R1 = 0; KEYPAD_R2 = 0;  KEYPAD_R3 = 0;  KEYPAD_R4 = 1;
        delay_ms(5);
        if (KEYPAD_C1)
        result = KEYPAD_STAR;
        else if (KEYPAD_C2)
        result = KEYPAD_NUM0;
        else if (KEYPAD_C3)
        result = KEYPAD_HASH;
    return result;
}
void calculate(){

    char* ch;
    bool flag = true;
    send_data(data);
    strcat(data, "=");
    do {
        send_data("");
        *ch = read();

        if (*ch != '#') {
            strcat(data, ch);
        } else {
            flag = false;
        }
    } while(flag);
}
void send_data(char* d)
{
    int len = strlen(d);
    int i = 0;
	for(; i < len; i++)
	{
        SPDR = d[i];
        while((SPSR&(1<<SPIF))==0);
        delay_ms(2);
    }
    SPDR = '#';
    while((SPSR&(1<<SPIF))==0);
    delay_ms(2);
}
char read()
{
    while((SPSR&(1<<SPIF))==0);
    return SPDR;
}
