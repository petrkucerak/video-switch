/*
 * LSP_Nios_Utility.h *
 *  Created on: 14.4.2022    Author: susta
 */

#ifndef LSP_NIOS_UTILITY_H_
#define LSP_NIOS_UTILITY_H_

#define EXTERNAL_BUS_BASE 0x10004000

#define RED_LED_BASE 0x10000000
#define GREEN_LED_BASE 0x10000010
#define HEX3_HEX0_BASE 0x10000020
#define HEX7_HEX4_BASE 0x10000030
#define SLIDER_SWITCH_BASE 0x10000040
#define PUSHBUTTON_BASE 0x10000050
#define LCD_16x2_BASE 0x10003050

#define SRAM_BASE 0x8000000
#define SRAM_END 0x81FFFFF
#define DRAM_BASE 0x0000000
#define DRAM_END 0x07FFFFFF

#define INTERVAL_TIMER_BASE 0x10002000

typedef unsigned char byte;

// Convert 4-lower bits (the rightmost nibble) to the hex display digit code.
byte Nibble2HexDisplay(int nibble);


// Write int as unsigned int to hex display. If noLeadingZeros!=0 then left zeros are switched off;
void WriteInt2HexDisplay(int buffer, int noLeadingZeros);

// Move cursor na 16x2 LCD display, x=0..15, y=0,1;
void LCD_cursor(int x, int y);
// Subroutine to send a string of text to the LCD from current cursor, clear end of line

void LCD_text(const char * text_ptr);

// Subroutine to turn off the LCD cursor
void LCD_cursor_off(void);

// Load timer by time defined in milliseconds and start its timing
void TimerStart(int time_ms);

// Wait until started timer elapsed
void TimerWait(void);

// return 1, if Static RAM is OK, otherwise 0
int TestSRAM();
// return 1, if Dynamic RAM is OK, otherwise 0
int TestDRAM();

#endif /* LSP_NIOS_UTILITY_H_ */
