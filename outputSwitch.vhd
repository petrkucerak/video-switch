-------------------------------------------------------------
-- CTU-FFE Prague, Dept. of Control Eng. [Richard Susta]
-- Published under GNU General Public License
-------------------------------------------------------------

library ieee, work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;       -- type integer and unsigned
use work.VGApackage.all;

entity OutputSwitch is 
port(	 
sw : in std_logic_vector(2 downto 0);
	    CH1, CH2, CH3: in std_logic_vector(23 downto 0);
		 VGA_R, VGA_G, VGA_B: out vga_byte --  color information
	 ); 
end;

architecture behavioral of OutputSwitch is

	signal Q : std_logic_vector(23 downto 0);

begin -- architecture
	
	Q <= 
		CH2 when sw="000" else
		CH2 when sw="001" else
		CH3 when sw="010" else
		CH3 when sw="011" else
		CH2 when sw="100" else
		CH2 when sw="101" else
		CH1 when sw="110"
		else CH1;

	VGA_R <= Q(23 downto 16);
	VGA_G <= Q(15 downto 8);
	VGA_B <= Q(7 downto 0);

    
end architecture behavioral;