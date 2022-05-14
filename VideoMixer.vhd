-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.VGApackage.all;

entity VideoMixer is

	port(
		state : in std_logic_vector(2 downto 0);
		xcolumm, yrow : in vga_xy;
		VS_N, HS_N : in std_logic;
		nextState : out std_logic;
		Sel : out std_logic_vector (1 downto 0)
	);

end entity;

architecture rtl of VideoMixer is

	signal SelE1 : std_logic_vector(1 downto 0);
	signal SelE2 : std_logic_vector(1 downto 0);


begin
			-- "000"; -- proměna z nálepky 1. na 2. efektem E1;
			-- "001"; -- čekání po dobu T; -> "01"
			-- "010"; -- přepnutí nálepky 2 efektem E2 na rozměr 320x240 centrovaný do středu plochy 640x480;
			-- "011"; -- čekání po dobu T; -> "11"
			-- "100"; -- přepnutí nálepky 2 na rozměr 640x480 opačně běžícím efektem E2;
			-- "101"; -- čekání po dobu T; -> "01"
			-- "110"; -- proměna z nálepky 2. na 1. efektem opačně běžícím E1;
			-- "111"; -- čekání po dobu T; -> "00"
	e1:process(VS_N, state, xcolumm, yrow)
		variable countr : integer range 0 to (XSCREEN)*(XSCREEN);
		variable x, y : integer; -- renamed xcolumn and yrow
		variable INC : integer range 0 to XSCREEN * XSCREEN;
		begin
			
			x:=to_integer(xcolumm); y:=to_integer(yrow); -- convert to integers
			
			if state /= "000" then
				countr := 0;
				INC := 24;
			elsif rising_edge(VS_N) then
				countr := countr + INC;
				INC := INC + 24;
				
			end if;
			
			if (x-(XSCREEN/2))*(x-(XSCREEN/2)) + (y-(YSCREEN/2))*(y-(YSCREEN/2)) <= countr then
				SelE1 <= "01";
			else SelE1 <= "00";
			end if;
			
			if (XSCREEN * XSCREEN) + (YSCREEN * YSCREEN) <= 4 * countr then -- pyhagoras
				nextState <= '1';
			else nextState <= '0';
			end if;
	end process;
		
	

	Sel <= 
		SelE1 when state="000" else -- normal
		-- "001"
		SelE2 when state="010" else -- normal
		"11" when state="011" else
		SelE2 when state="100" else -- reverse
		-- "101"
		SelE1 when state="110" else -- reverse
		"00" when state="111"
		else "01";
		

end rtl;
