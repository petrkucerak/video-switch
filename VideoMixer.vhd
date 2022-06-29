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
		xcolumn, yrow : in vga_xy;
		VS_N, HS_N : in std_logic;
		nextState : out std_logic;
		vector_T : in std_logic_vector(8 downto 0);
		Sel : out std_logic_vector (1 downto 0)
	);

end entity;

architecture rtl of VideoMixer is

	signal SelE1 : std_logic_vector(1 downto 0);
	signal SelE2 : std_logic_vector(1 downto 0);
	signal SelE1R : std_logic_vector(1 downto 0);
	signal SelE2R : std_logic_vector(1 downto 0);
	signal nextState0 : std_logic;
	signal nextState1 : std_logic;
	signal nextState2 : std_logic;
	signal nextState3 : std_logic;
	signal nextState4 : std_logic;


begin
			-- "000"; -- proměna z nálepky 1. na 2. efektem E1;
			-- "001"; -- čekání po dobu T; -> "01"
			-- "010"; -- přepnutí nálepky 2 efektem E2 na rozměr 320x240 centrovaný do středu plochy 640x480;
			-- "011"; -- čekání po dobu T; -> "11"
			-- "100"; -- přepnutí nálepky 2 na rozměr 640x480 opačně běžícím efektem E2;
			-- "101"; -- čekání po dobu T; -> "01"
			-- "110"; -- proměna z nálepky 2. na 1. efektem opačně běžícím E1;
			-- "111"; -- čekání po dobu T; -> "00"
	tSet:process(VS_N)
		variable T : integer range 0 to 25500;
		variable countr : integer range 0 to 25500;
		begin
			T:= to_integer(unsigned(vector_T));
			T:= T * 100;
			if T = 0 then
				T:= 250;
			end if;
			
			if state /= "001" AND state /= "011" AND state /= "101" AND state /= "111" then
				countr := 0;
			elsif rising_edge(VS_N) then
				countr := countr + 1;
			end if;
			
			if countr >= T then
				nextState0<='1';
			else nextState0<='0';
			end if;
			
	end process;
	
	e1:process(VS_N, state, xcolumn, yrow)
		variable countr : integer range 0 to (XSCREEN)*(XSCREEN);
		variable x, y : integer; -- renamed xcolumn and yrow
		variable INC : integer range 0 to XSCREEN * XSCREEN;
		begin
			
			x:=to_integer(xcolumn); y:=to_integer(yrow); -- convert to integers
			
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
				nextState1 <= '1';
			else nextState1 <= '0';
			end if;
			
	end process;
	
	e2:process(VS_N, state, xcolumn, yrow)
		variable countr : integer range 0 to 4000;
		variable x, y : integer;
		variable INC : integer range 0 to XSCREEN;
		
		begin
			x:=to_integer(xcolumn); y:=to_integer(yrow); -- convert to integers
			
			if state /= "010" then
				countr := 0;
				INC := 25;
			elsif rising_edge(VS_N) then
				countr := countr + INC;
			end if;
			
			if (6*y + 8*x < countr + 3*YSCREEN + 4*XSCREEN AND 6*y + countr + 8*x > 3*YSCREEN + 4*XSCREEN) then
				SelE2 <= "10";
			else SelE2 <= "01";
			end if;
			
			if  4000 <= countr then
				nextState2 <= '1';
			else nextState2 <= '0';
			end if;
	
	end process;
	
	e2Reverse:process(VS_N, state, xcolumn, yrow)
		variable countr : integer range 0 to 4000;
		variable x, y : integer;
		variable INC : integer range 0 to XSCREEN;
		
		begin
			x:=to_integer(xcolumn); y:=to_integer(yrow); -- convert to integers
			
			if state /= "100" then
				countr := 4000;
				INC := 25;
			elsif rising_edge(VS_N) then
				countr := countr - INC;
			end if;
			
			if (6*y + 8*x < countr + 3*YSCREEN + 4*XSCREEN AND 6*y + countr + 8*x > 3*YSCREEN + 4*XSCREEN) then
				SelE2R <= "10";
			else SelE2R <= "01";
			end if;
			
			if  0 >= countr then
				nextState3 <= '1';
			else nextState3 <= '0';
			end if;
	
	end process;
	
	e1Reverse:process(VS_N, state, xcolumn, yrow)
		variable countr : integer range -300 to 160081;
		variable x, y : integer; -- renamed xcolumn and yrow
		variable INC : integer range 0 to 2785;
		begin
			
			x:=to_integer(xcolumn); y:=to_integer(yrow); -- convert to integers
			
			if state /= "110" then
				countr := 160080;
				INC := 2784;
			elsif rising_edge(VS_N) then
				countr := countr - INC;
				INC := INC - 24;
				
			end if;
			
			if (x-(XSCREEN/2))*(x-(XSCREEN/2)) + (y-(YSCREEN/2))*(y-(YSCREEN/2)) <= countr then
				SelE1R <= "01";
			else SelE1R <= "00";
			end if;
			
			if 0 >= countr then -- pyhagoras
				nextState4 <= '1';
			else nextState4 <= '0';
			end if;
	end process;
		
	

	Sel <= 
		SelE1 when state="000" else -- normal
		-- "001"
		SelE2 when state="010" else -- normal
		"11" when state="011" else
		SelE2R when state="100" else -- reverse
		-- "101"
		SelE1R when state="110" else -- reverse
		"00" when state="111"
		else "01";
		
	nextState <= nextState0 OR nextState1 OR nextState2 OR nextState3 OR nextState4;
		

end rtl;
