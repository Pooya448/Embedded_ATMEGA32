/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
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
#include <delay.h>
#include <stdbool.h>

#define _BV(bit)( 1<<(bit))

// Declare your global variables here
int second = 0;
int minute = 49;
int hour = 5;
int day = 21;
int month = 9;
int year = 99;

bool is_setting = false;
int setting_pos = 0;
unsigned char segments[10] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F};

int blink = 0;
int blink_cycle = 10;
void update_time();
void get_next_setting();
void increase();
void decrease();
void write();
void write_setting_mode();
// External Interrupt 0 service routine -> Setting Button
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    is_setting = !is_setting;
    setting_pos = 0;
    PORTD = 0x00;
}

// External Interrupt 1 service routine -> Change Setting Pos Button
interrupt [EXT_INT1] void ext_int1_isr(void)
{
    if (is_setting) {
        get_next_setting();
        blink = 1;
    }

}

// External Interrupt 2 service routine -> Increase and Decrease
interrupt [EXT_INT2] void ext_int2_isr(void)
{
    if (is_setting) {
        if (PINB & _BV(7)) {
            decrease();
        } else {
            increase();
        }
    }
}

// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{

    if (!is_setting) {
        PORTD ^= 0x01;
        update_time();
    }
}
void increase(){
    switch (setting_pos) {
        case 0:
            hour++;
            if (hour >= 24) {
                hour = 0;
            }
            break;
        case 1:
            minute++;
            if (minute >= 60) {
                minute = 0;
            }
            break;
        case 2:
            year++;
            if (year >= 100) {
                year = 0;
            }
            break;
        case 3:
            month++;
            if (month >= 13) {
                month = 1;
            }
            break;
        case 4:
            day++;
            if (day >= 31) {
                day = 1;
            }
            break;
    }

}
void decrease(){
    switch (setting_pos) {
        case 0:
            hour--;
            if (hour < 0) {
                hour = 23;
            }
            break;
        case 1:
            minute--;
            if (minute < 0) {
                minute = 59;
            }
            break;
        case 2:
            year--;
            if (year < 0) {
                year = 99;
            }
            break;
        case 3:
            month--;
            if (month < 0) {
                month = 12;
            }
            break;
        case 4:
            day--;
            if (day < 0) {
                day = 30;
            }
            break;
    }

}
void get_next_setting(){
    setting_pos++;
    if (setting_pos >= 5) {
        setting_pos = 0;
    }
}
void update_time(){
    second++;
    if (second >= 60) {
        minute++;
        second = 0;
    }
    if (minute >= 60) {
        hour++;
        minute = 0;
    }
    if (hour >= 24) {
        day++;
        hour = 0;
    }
    if (day >= 31) {
        month++;
        day = 1;
    }
    if (month >= 13) {
        year++;
        month = 1;
    }
}
void write(){
    int year_l = year / 10;
    int year_r = year % 10;
    int month_l = month / 10;
    int month_r = month % 10;
    int day_l = day / 10;
    int day_r = day % 10;
    int hour_l = hour / 10;
    int hour_r = hour % 10;
    int minute_l = minute / 10;
    int minute_r = minute % 10;

    //Minute Right
    PORTC = 0b11110111;
    PORTA = segments[minute_r];
    delay_ms(2);

    // Minute Left
    PORTC = 0b11111011;
    PORTA = segments[minute_l];
    delay_ms(2);

    // Hour Right
    PORTC = 0b11111101;
    PORTA = segments[hour_r];
    delay_ms(2);

    // Hour Left
    PORTC = 0b11111110;
    PORTA = segments[hour_l];
    delay_ms(2);

    PORTC = 0b01111111;

    // Day Right
    PORTB = 0b10111111;
    PORTA = segments[day_r];
    delay_ms(2);

    // Day Left
    PORTB = 0b11011111;
    PORTA = segments[day_l];
    delay_ms(2);

    // Month Right
    PORTB = 0b11101111;
    PORTA = segments[month_r];
    delay_ms(2);
    // Month Left
    PORTB = 0b11110111;
    PORTA = segments[month_l];
    delay_ms(2);

    // Year Right
    PORTB = 0b11111101;
    PORTA = segments[year_r];
    delay_ms(2);

    // Year Left
    PORTB = 0b11111110;
    PORTA = segments[year_l];
    delay_ms(2);

    PORTB = 0b01111111;
}
void write_setting_mode(){
    int year_l = year / 10;
    int year_r = year % 10;
    int month_l = month / 10;
    int month_r = month % 10;
    int day_l = day / 10;
    int day_r = day % 10;
    int hour_l = hour / 10;
    int hour_r = hour % 10;
    int minute_l = minute / 10;
    int minute_r = minute % 10;

    // Minute
    if (setting_pos == 1) {
        if (blink > 0) {
            //Minute Right
            PORTC = 0b11110111;
            PORTA = 0x00;
            delay_ms(2);

            // Minute Left
            PORTC = 0b11111011;
            PORTA = 0x00;
            delay_ms(2);
            blink++;
            if (blink >= blink_cycle) {
                blink = -1;
            }
        } else {
            //Minute Right
            PORTC = 0b11110111;
            PORTA = segments[minute_r];
            delay_ms(2);

            // Minute Left
            PORTC = 0b11111011;
            PORTA = segments[minute_l];
            delay_ms(2);
            blink--;
            if (blink <= -blink_cycle) {
                blink = 1;
            }
        }
    } else {
        //Minute Right
        PORTC = 0b11110111;
        PORTA = segments[minute_r];
        delay_ms(2);

        // Minute Left
        PORTC = 0b11111011;
        PORTA = segments[minute_l];
        delay_ms(2);
    }

    // Hour
    if (setting_pos == 0) {
        if (blink > 0) {
            // Hour Right
            PORTC = 0b11111101;
            PORTA = 0x00;
            delay_ms(2);

            // Hour Left
            PORTC = 0b11111110;
            PORTA = 0x00;
            delay_ms(2);

            PORTC = 0b01111111;

            blink++;
            if (blink >= blink_cycle) {
                blink = -1;
            }
        } else {
            // Hour Right
            PORTC = 0b11111101;
            PORTA = segments[hour_r];
            delay_ms(2);

            // Hour Left
            PORTC = 0b11111110;
            PORTA = segments[hour_l];
            delay_ms(2);

            PORTC = 0b01111111;

            blink--;
            if (blink <= -blink_cycle) {
                blink = 1;
            }
        }
    } else {
        // Hour Right
        PORTC = 0b11111101;
        PORTA = segments[hour_r];
        delay_ms(2);

        // Hour Left
        PORTC = 0b11111110;
        PORTA = segments[hour_l];
        delay_ms(2);

        PORTC = 0b01111111;
    }
    //
    // Day
    if (setting_pos == 4) {
        if (blink > 0) {
            // Day Right
            PORTB = 0b10111111;
            PORTA = 0x00;
            delay_ms(2);

            // Day Left
            PORTB = 0b11011111;
            PORTA = 0x00;
            delay_ms(2);

            blink++;
            if (blink >= blink_cycle) {
                blink = -1;
            }
        } else {
            // Day Right
            PORTB = 0b10111111;
            PORTA = segments[day_r];
            delay_ms(2);

            // Day Left
            PORTB = 0b11011111;
            PORTA = segments[day_l];
            delay_ms(2);

            blink--;
            if (blink <= -blink_cycle) {
                blink = 1;
            }
        }
    } else {
        // Day Right
        PORTB = 0b10111111;
        PORTA = segments[day_r];
        delay_ms(2);

        // Day Left
        PORTB = 0b11011111;
        PORTA = segments[day_l];
        delay_ms(2);
    }
    //Month
    if (setting_pos == 3) {
        if (blink > 0) {
            // Month Right
            PORTB = 0b11101111;
            PORTA = 0x00;
            delay_ms(2);
            // Month Left
            PORTB = 0b11110111;
            PORTA = 0x00;
            delay_ms(2);

            blink++;
            if (blink >= blink_cycle) {
                blink = -1;
            }
        } else {
            // Month Right
            PORTB = 0b11101111;
            PORTA = segments[month_r];
            delay_ms(2);
            // Month Left
            PORTB = 0b11110111;
            PORTA = segments[month_l];
            delay_ms(2);

            blink--;
            if (blink <= -blink_cycle) {
                blink = 1;
            }
        }
    } else {
        // Month Right
        PORTB = 0b11101111;
        PORTA = segments[month_r];
        delay_ms(2);
        // Month Left
        PORTB = 0b11110111;
        PORTA = segments[month_l];
        delay_ms(2);
    }

    //Year
    if (setting_pos == 2) {
        if (blink > 0) {
            // Year Right
            PORTB = 0b11111101;
            PORTA = 0x00;
            delay_ms(2);

            // Year Left
            PORTB = 0b11111110;
            PORTA = 0x00;
            delay_ms(2);

            PORTB = 0b01111111;

            blink++;
            if (blink >= blink_cycle) {
                blink = -1;
            }
        } else {
            // Year Right
            PORTB = 0b11111101;
            PORTA = segments[year_r];
            delay_ms(2);

            // Year Left
            PORTB = 0b11111110;
            PORTA = segments[year_l];
            delay_ms(2);

            PORTB = 0b01111111;

            blink--;
            if (blink <= -blink_cycle) {
                blink = 1;
            }
        }
    } else {
        // Year Right
        PORTB = 0b11111101;
        PORTA = segments[year_r];
        delay_ms(2);

        // Year Left
        PORTB = 0b11111110;
        PORTA = segments[year_l];
        delay_ms(2);

        PORTB = 0b01111111;
    }
}
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
// Function: Bit7=In Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=Out Bit0=Out
DDRB=(0<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=0 Bit0=0
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
DDRC=(1<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=0 Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (1<<DDD0);
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
// Clock value: 31.250 kHz
// Mode: CTC top=OCR1A
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 1 s
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x7A;
OCR1AL=0x12;
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
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// INT2: On
// INT2 Mode: Falling Edge
GICR|=(1<<INT1) | (1<<INT0) | (1<<INT2);
MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(1<<INTF1) | (1<<INTF0) | (1<<INTF2);

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
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Global enable interrupts
#asm("sei")

while (1){
    if (is_setting) {
        write_setting_mode();
    } else {
        write();
    }

}
}
