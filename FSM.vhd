-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;

entity FSM is

	port(
		clk		 : in	std_logic;
		input	 : in	std_logic;
		reset	 : in	std_logic;
		output	 : out	std_logic_vector(2 downto 0)
	);

end entity;

architecture rtl of FSM is

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3, s4, s5, s6, s7);

	-- Register to hold the current state
	signal state   : state_type;

begin

	-- Logic to advance to the next state
	process (clk, reset)
	begin
		if reset = '1' then
			state <= s0;
		elsif (rising_edge(clk)) then
			case state is
				when s0=>
					if input = '1' then
						state <= s1;
					else
						state <= s0;
					end if;
				when s1=>
					if input = '1' then
						state <= s2;
					else
						state <= s1;
					end if;
				when s2=>
					if input = '1' then
						state <= s3;
					else
						state <= s2;
					end if;
				when s3 =>
					if input = '1' then
						state <= s4;
					else
						state <= s3;
					end if;
				when s4 =>
					if input = '1' then
						state <= s5;
					else
						state <= s4;
					end if;
				when s5 =>
					if input = '1' then
						state <= s6;
					else
						state <= s5;
					end if;
				when s6 =>
					if input = '1' then
						state <= s7;
					else
						state <= s6;
					end if;
				when s7 =>
					if input = '1' then
						state <= s0;
					else
						state <= s7;
					end if;
			end case;
		end if;
	end process;

	-- Output depends solely on the current state
	process (state)
	begin
		case state is
			when s0 =>
				output <= "000"; -- proměna z nálepky 1. na 2. efektem E1;
			when s1 =>
				output <= "001"; -- čekání po dobu T;
			when s2 =>
				output <= "010"; -- přepnutí nálepky 2 efektem E2 na rozměr 320x240 centrovaný do středu plochy 640x480;
			when s3 =>
				output <= "011"; -- čekání po dobu T;
			when s4 =>
				output <= "100"; -- přepnutí nálepky 2 na rozměr 640x480 opačně běžícím efektem E2;
			when s5 =>
				output <= "101"; -- čekání po dobu T;
			when s6 =>
				output <= "110"; -- proměna z nálepky 2. na 1. efektem opačně běžícím E1;
			when s7 =>
				output <= "111"; -- čekání po dobu T;
		end case;
	end process;

end rtl;
