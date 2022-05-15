#include <stdio.h>
#include "LSP_Nios_Utility.h"


/* Declare volatile pointers to I/O registers
 * (The volatile keyword indicates that a value may change between different accesses,
 * even if it does not appear to be modified .
 * This keyword prevents an compiler from optimizing subsequent reads or writes
 * and incorrectly reusing values or omitting writes. [Wikipedia])
 */

volatile int * const red_LED_ptr 	= (int *) RED_LED_BASE;	// red LED address
volatile int * const green_LED_ptr	= (int *) GREEN_LED_BASE;	// green LED address
volatile int * const SW_switch_ptr	= (int *) SLIDER_SWITCH_BASE;	// SW slider switch address
volatile int * const KEY_ptr	= (int *) PUSHBUTTON_BASE;	// inverted KEY, 1 here means pressed
volatile byte * const extbus = (byte *) EXTERNAL_BUS_BASE;	// external bus

int main(void)
{

	LCD_cursor (0,0); LCD_text("*SRAM test runs");   // set LCD cursor location to top row
	LCD_cursor (0,0);
	if(TestSRAM()!=0)LCD_text("*** SRAM is OK");	else LCD_text("### SRAM error");

	LCD_cursor (0,1); LCD_text("*DRAM test runs");   // set LCD cursor location to top row
	LCD_cursor (0,1);
	if(TestDRAM()!=0) LCD_text("*** DRAM is OK"); else	LCD_text("### DRAM error");

	// write to NIOS II Console in the development environment
	printf("Demo program is running. Terminate it by pressing KEY[3] or KEY[2] or KEY[1]");

	int pushButton, degnum, ix;
	int maskR=1, maskG=1, count=0;
	char buf[40];
	char c;
	do
	{
	  TimerStart(100); // setting 100 ms to hardware timer of DE2-115 board

	  // convert count to BCD
	  sprintf(buf,"%d\n",count++); degnum=0; ix=0;
      while((c=buf[ix++])>='0') { degnum<<=4; degnum |= ((c-'0')&0xF); }
	  WriteInt2HexDisplay(degnum++,1);

	  *red_LED_ptr=maskR; maskR<<=1; if(maskR>=0x3FFFF) maskR=1;
	  *green_LED_ptr=maskG; maskG<<=1; if(maskG>=0x1FF) maskG=1;

	  TimerWait();  pushButton = *KEY_ptr;
	}
	while(pushButton==0);
	LCD_cursor (0,0); LCD_text("# Terminated");
	sprintf(buf,"  KEY==0x%x",pushButton);
	LCD_cursor (0,1); LCD_text(buf);

	// write to NIOS II Console in the development environment
	printf("\nNIOS program was terminated by pressing a KEY");
    return 0;
}








