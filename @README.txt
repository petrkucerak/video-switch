List of files
Demo_LCD.bdf - schema for downloading to DE2-115
DisplayLogic2.vhd - picture 640x480
Demo0.bdf, DisplayLogic0.vhd, Demo.bdf, DisplayLogic0.vhd - picture 320x240
testbench_DisplayLogic.vhd - testbench prepared for DesplayLogic2.vhd   

CZ, see below for english 
------------------------------------------
*** Důležité upozornění ***

LCD display využívá Video dekodér na desce, takže to vyjde jednoduché.
Jeho piny mají ale dost složité názvy, takže k nim byly vytvořené aliasy,
tedy dvojí označení některého pinu.

!!! Zde je již projekt nastaven, ale do vlastního projektu si musíte vložit soubory
LCDgenerator, LCDRegDE2_115.vhd, LCDpackage, LCD_altpll.qip, lcd_display.sdc

Poté je nutné do Vašeho projektu nahrát nové pin assignments do jejich prázdného seznamu !!!

1/ Quartus menu: Assignments->Remove Assignments 
            + vybrat * Pin, Location & Routing Assignments
		               * Fitter Assignments
			    nic jiného a dát [Ok]
				 
2/ Assignments->Assignments Editor musí ukázat prázdný seznam, do plného se aliasy nenahrají!
		      
3/ Quartus menu: Assignments->Import Assignments...
   a zvolit soubor DE2_115_lcd_pin_assignments.csv,
	
	Soubor je totožný s původním DE2_115_pin_assignments.csv, pouze obsahuje na začátku aliasy.
	Objeví se chybová hláška, že část Assignment se ignorovala, kterou ignorujte.
	

+++ Nezapomeňte též přidat lcd_display.sdc v Assignments->Settings->TimeQuest Timing Analyzer

************************************************************
ENG *** Important Warning ***
************************************************************

The LCD display uses a Video Decoder chip on the board, so it comes out simple.
Its pins have quite complex names, so aliases have been created.

!!! Here, the projct has already correct configuration, but in your own project,
you must add the following files:

LCDgenerator, LCDRegDE2_115.vhd, LCDpackage, LCD_altpll.qip, lcd_display.sdc

Then, you need to import new pin assignments into empty pin list !!!

1/ Quartus menu: Assignments->Remove Assignments 
            + select * Pin, Location & Routing Assignments
		               * Fitter Assignments
			    Nothing else, and [Ok]
				 
2/ Assignments->Assignments Editor should show empty list, the requirement for importing aliases!
		      
3/ Quartus menu: Assignments->Import Assignments...
   and select DE2_115_lcd_pin_assignments.csv.
	Ignore error message that some part of the assignments has been ignored.
	
The file is identical with the original DE2_115_pin_assignments.csv, 
except for adding aliases at begining for several pins of the Video decoder.

+++ Do not also forget to add lcd_display.sdc by Assignments->Settings->TimeQuest Timing Analyzer
