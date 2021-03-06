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
sw : in std_logic_vector(1 downto 0);
	    CH1, CH2, CH3: in std_logic_vector(23 downto 0);
		 VGA_R, VGA_G, VGA_B: out vga_byte --  color information
	 ); 
end;

architecture behavioral of OutputSwitch is

	signal Q : std_logic_vector(23 downto 0);

begin -- architecture
	
	Q <= 
		CH1 when sw="00" else
		CH2 when sw="01" else
			CH3;

	VGA_R <= Q(23 downto 16);
	VGA_G <= Q(15 downto 8);
	VGA_B <= Q(7 downto 0);

    
end architecture behavioral;