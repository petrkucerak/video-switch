-------------------------------------------------------------
-- CTU-FFE Prague, Dept. of Control Eng. [Richard Susta]
-- Published under GNU General Public License
-------------------------------------------------------------

library ieee, work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;       -- type integer and unsigned
use work.VGApackage.all;

entity DisplayLogic02 is 
port(	 
       xcolumn, yrow : in vga_xy; -- row and  column indexes of VGA video
		 VGA_CLK : in std_logic;
	    VGA_R, VGA_G, VGA_B: out vga_byte --  color information
	 ); 
end;

architecture behavioral of DisplayLogic02 is

---------------------------------------------------------------------------------
-- Used colors 	
constant RED : RGB_type := ToRGB(196,0,0);  
constant GREEN : RGB_type := ToRGB(0,128,0);  
constant BLUE : RGB_type := ToRGB(31,31,196); 
constant GRAY : RGB_type := ToRGB(31,31,31); 
constant YELLOW : RGB_type := ToRGB(X"FFFF00"); -- or ToRGB(191,191,0); 
constant BLACK : RGB_type := ToRGB(X"000000");  -- or ToRGB(0,0,0);
---------------------------------------------------------------------------

begin -- architecture

   -- the sensitive list defines that process outputs can change 
	-- only when any of xcolumn or yrow has changed its value
    LSPflag : process(xcolumn, yrow) 
    variable RGB : RGB_type; -- output colors
    variable x, y : integer; -- xcolumn and yrow converted to integers
    begin
	 
		x:=to_integer(xcolumn); y:=to_integer(yrow); -- convert to integers
	  
      
		if(x<0) or (x>=XSCREEN) or (y<0) or (y>=YSCREEN) then
		   RGB:=BLACK; --black outside of visible frame 
		elsif x*x+(y-YSCREEN)*(y-YSCREEN) < YSCREEN*YSCREEN/16 then
		   RGB:=YELLOW;
		elsif 5*y < 5*YSCREEN - 6*x then  -- line equation  y = 240-(6/5)*x
		   RGB:=GREEN;
		elsif 8*y < 8*YSCREEN- 3*x then     -- line equation  y = 240-(3/8)*x
		   RGB:=YELLOW;
		else 
		   RGB:=BLUE; -- else is necessary, the complete definition prevents forbidden latches  
		end if;

	-- Copy results in RGB to outputs of entity
		VGA_R<=RGB.R; VGA_G<=RGB.G; VGA_B<=RGB.B;
-----------------------------------------------------------------------------
	end process;

    
end architecture behavioral;