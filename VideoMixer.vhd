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
		Sel : out std_logic_vector (1 downto 0)
	);

end entity;

architecture rtl of VideoMixer is


begin
			-- "000"; -- proměna z nálepky 1. na 2. efektem E1;
			-- "001"; -- čekání po dobu T; -> "01"
			-- "010"; -- přepnutí nálepky 2 efektem E2 na rozměr 320x240 centrovaný do středu plochy 640x480;
			-- "011"; -- čekání po dobu T; -> "11"
			-- "100"; -- přepnutí nálepky 2 na rozměr 640x480 opačně běžícím efektem E2;
			-- "101"; -- čekání po dobu T; -> "01"
			-- "110"; -- proměna z nálepky 2. na 1. efektem opačně běžícím E1;
			-- "111"; -- čekání po dobu T; -> "00"

	Sel <= 
		"11" when state="011" else
		"00" when state="111"
		else "01";
		

end rtl;
