-- Quartus II VHDL Template Basic

library ieee;use ieee.std_logic_1164.all;use ieee.numeric_std.all;
use work.VGApackage.all;
-- To shorten code length, we do not temporary utilize
-- generic and ACLRN inputs, and MAX constant
entity VideoSwitch is
    generic(MAX:integer:=640; INC:integer:=4);
	port 
	(  xcolumn, yrow : in vga_xy;
	    VS_N : in std_logic;
	   Sel : out std_logic); -- vertikalni synchronizace
begin
    assert MAX>0 and INC> 0 report "Requied MAX > 0 and INC > 0" severity failure;
end entity;
 
architecture rtl2 of VideoSwitch is begin
icntr_fsm: process(VS_N)
  variable cntr : integer range 0 to MAX+INC-1:=XSCREEN+INC-1;
  type state_t is (stateUp, stateDown); --enumerated types are reserved only for FSMs
  variable state: state_t:=stateUp;
  variable cdown : boolean:=FALSE; 
  begin
     if rising_edge(VS_N) then    
       case state is  -- delta function of FSM
             when stateUp => if cntr>=MAX then state:=stateDown; end if;
             when stateDown => if cntr<INC then state:=stateUp; cntr:= 0; end if;
       end case;
       case state is -- omega function of FSM
            when stateUp => cdown:=FALSE; 
            when stateDown => cdown:=TRUE; 
       end case; 
        --------------------------------------------------------
        if cdown then cntr:=cntr-INC; else cntr:= cntr+INC;  end if;
     end if;
     if xcolumn <cntr then Sel <= '0';
     else Sel <= '1';
     end if;
     
   end process; 
end architecture;