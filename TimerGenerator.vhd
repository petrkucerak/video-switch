-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.VGApackage.all;

entity TimerGenerator is

	generic(T:integer:=250);

	port(
		start : in std_logic;
		VS_N, HS_N : in std_logic;
		run : out std_logic;
	);

end entity;

architecture rtl of TimerGenerator is


begin
	signal runS : std_logic;
	
	timer:process(VS_N, start)
		variable countr : integer range 0 to T;
		begin
			
			if rising_edge(VS_N) then
				if start = '1' then
					countr := countr + 1;
				else countr := 0;
				end if;
				
				if countr = T then
					runS <= '1'
				else
					runS <= '0'
				end if;
			end if;
			
	end process;
	
	run <= runS;	

end rtl;
