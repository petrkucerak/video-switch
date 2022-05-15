#include "LSP_Nios_Utility.h"


/*******************************************************************************
// * Convert 4-lower bits (the rightmost nibble) to the hex display digit code.
 *******************************************************************************/
byte Nibble2HexDisplay(int nibble)
{
	// hex display drive uses opposite polarity than direct access to HEXi[6 downto 0]
	// '1' here switch segment on.  HEXi[6 downto 0] segment is switched on when '0'.
	const byte	seven_seg_decode_table[] = { 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07,
			  								 0xFF, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71 };
   return seven_seg_decode_table[nibble & 0xF];
}

/*******************************************************************************
 * Write int as unsigned int to 8 digit-hex display.
 * If noLeadingZeros!=0 then left zeros are switched off;
********************************************************************************/
void WriteInt2HexDisplay(int n, int noLeadingZeros)
{
	byte	hex_segments[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
	volatile int * HEX3_HEX0_ptr = (int *) HEX3_HEX0_BASE;
	volatile int * HEX7_HEX4_ptr = (int *) HEX7_HEX4_BASE;
	unsigned int shift_buffer = (unsigned int) n;
	int i;

	for ( i = 0; i < 8; ++i )
	{
		// character is in rightmost nibble
		hex_segments[i] = Nibble2HexDisplay(shift_buffer);
		shift_buffer = shift_buffer >> 4;
	}
	if(noLeadingZeros!=0)
	{
	  for(i=7; i>1; i--)
	  { if(hex_segments[i]==0x3F) hex_segments[i]=0x0;
	    else break;
	  }
	}
	*(HEX3_HEX0_ptr) = *(int *) hex_segments; 		// drive the hex displays
	*(HEX7_HEX4_ptr) = *(int *) (hex_segments+4);	// drive the hex displays

	return;
}

/****************************************************************************************
 * Subroutine to move the LCD cursor, x in <0,15> character, y in <0,1> line
****************************************************************************************/

void LCD_cursor(int x, int y)
{
	volatile char * const LCD_display_ptr = (char *) LCD_16x2_BASE;	// 16x2 character display
	char instruction;

	instruction = x &0xF;
	if (y != 0) instruction |= 0x40;	// set bit 6 for bottom row
	instruction |= 0x80;		// need to set bit 7 to set the cursor location
	*(LCD_display_ptr) = instruction;	// write to the LCD instruction register
}

/****************************************************************************************
 * Subroutine to send a string of text to the LCD from current cursor, clear end of line
****************************************************************************************/
void LCD_text(const char * text_ptr)
{
	volatile char * const LCD_display_ptr = (char *) LCD_16x2_BASE;	// 16x2 character display
	int i=16; // max line length
	while (--i>0)
	{
		char c = *text_ptr;
		if(c!=0)
		{
		  *(LCD_display_ptr + 1) = c;	// write to the LCD data register
		  text_ptr++;
		}
		else *(LCD_display_ptr + 1) = ' '; // clear end of line
	}
}


/****************************************************************************************
 * Subroutine to turn off the LCD cursor
****************************************************************************************/
void LCD_cursor_off(void)
{
	volatile char * const LCD_display_ptr = (char *) LCD_16x2_BASE;	// 16x2 character display
	*(LCD_display_ptr) = 0x0C;	// turn off the LCD cursor
}

/**************************************************************************************
 Load timer by time defined in milliseconds and start its timing
***************************************************************************************/
void TimerStart(int time_ms)
{
	volatile unsigned int  * const interval_timer = (unsigned int *) INTERVAL_TIMER_BASE;  // interval timer base
    const unsigned int MS = 50000; // 50 MHz/1000
    const unsigned int STOP_TIMER_COMMAND=8;
    const unsigned int START_TIMER_COMMAND=4; // start timer command without enabling interrupt!
    if(time_ms<1) time_ms=1;

    unsigned int time = MS * (unsigned int)time_ms;
    interval_timer[1] =  STOP_TIMER_COMMAND; // stop timer command
    interval_timer[0] =  0;   // reset Time Out bit
    interval_timer[2] =  (time & 0xFFFF);  // lower 16 bits
    interval_timer[3] =  (time>>16) & 0xFFFF;   // upper 16 bits
    interval_timer[1] =  START_TIMER_COMMAND;
}
/**************************************************************************************
 Wait until started timer elapsed
***************************************************************************************/
void TimerWait(void)
{
	volatile unsigned int  * const interval_timer = (unsigned int *) INTERVAL_TIMER_BASE;  // interval timer base
   const unsigned int TIMEOUT_BIT_MASK = 1;
    const unsigned int RUNNING_BIT_MASK = 2;
    unsigned int status;
    do
    {
	  status = interval_timer[0];
    }
    while(      (status & RUNNING_BIT_MASK)!=0 // timer is still running
              && (status & TIMEOUT_BIT_MASK)==0 // timer has not reached 0 yet
            );
}

/*********************************************************************************
 * Test memory
 */
static int TestOfMemory(int startAddress, int endAddress)
{
	int * RAM_ptr;
	const int RAM_write = 0x55555555;
	int RAM_read;
	int memory_OK = 1;
	while ( !memory_OK )
	{
		RAM_ptr = (int *) startAddress;
		while( (RAM_ptr <= (int *) endAddress) && (memory_OK!=0) )
		{
			// test SRAM
			RAM_read = * RAM_ptr;
			* RAM_ptr=RAM_write;
			if (*RAM_ptr != RAM_write)	{	memory_OK = 0;	}
			* RAM_ptr = ~RAM_write;
			if (*RAM_ptr != ~RAM_write)	{	memory_OK = 0;	}
			* RAM_ptr = RAM_read;
			if(* RAM_ptr != RAM_read)   {	memory_OK = 0;	}
			RAM_ptr += 1;
		};
	};
	return memory_OK;
}

// return 1, if Static RAM is OK, otherwise 0
int TestSRAM()
{
	return TestOfMemory(SRAM_BASE, SRAM_END);
}
// return 1, if Dynamic RAM is OK, otherwise 0
int TestDRAM()
{
	return TestOfMemory(DRAM_BASE, DRAM_END);
}
