-------------------------------------------------------------
-- CTU-FFE Prague, Dept. of Control Eng. [Richard Susta]
-- Published under GNU General Public License
-------------------------------------------------------------

library ieee, work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;       -- type integer and unsigned
use work.VGApackage.all;

entity DisplayLogic2 is 
port(	 
       xcolumn, yrow : in vga_xy; -- row and  column indexes of VGA video
		 VGA_CLK : in std_logic;
	    VGA_R, VGA_G, VGA_B: out vga_byte --  color information
	 ); 
end;

architecture behavioral of DisplayLogic2 is

---------------------------------------------------------------------------------
-- Used colors 	
constant VIOLET : RGB_type := ToRGB(40,22,111);
constant SKY : RGB_type := ToRGB(0,136,204);
constant BLUE_DARK : RGB_type := ToRGB(0,72,112); -- image
constant BLUE_LIGHT : RGB_type := ToRGB(119, 191, 223); -- image	
constant BACKGROUND : RGB_type := ToRGB(182,221,199); -- BACKGROUND
constant BLACK : RGB_type := ToRGB(X"000000");  -- or ToRGB(0,0,0);
---------------------------------------------------------------------------
constant MEMROWSIZE : integer := 256; -- memory organization
constant MEMROWCOUNT : integer := 256;
constant EMBORGX1 : integer := 64; -- positions of picture in the flag
constant EMBORGY1 : integer := 64;
constant EMBORGX2 : integer := XSCREEN-MEMROWSIZE-32; -- positions of picture in the flag
constant EMBORGY2 : integer := YSCREEN-MEMROWCOUNT-32;
constant MEM_END_ADDRESS : integer := 65535;

component romPicture256x256 IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component romPicture256x256;

signal picture_address_s : std_logic_vector(15 DOWNTO 0); -- ROM mem address
signal picture_q_s : std_logic_vector(7 downto 0); -- data from ROM memory
signal VGA_CLK_n:std_logic;
begin -- architecture

	VGA_CLK_n <= not VGA_CLK;
	
	rom_inst : romPicture256x256 -- the name of ROM instance and its connections
	port map(clock => VGA_CLK_n, address => picture_address_s, q => picture_q_s);
  
   -- the sensitive list defines that process outputs can change 
	-- only when any of xcolumn or yrow or picture_q_s has changed its value
    LSPflag : process(xcolumn, yrow, picture_q_s) 
    variable RGB : RGB_type; -- output colors
    variable x, y : integer; -- renamed xcolumn and yrow
	 variable romID:integer range 0 to 2;
    begin
		x:=to_integer(xcolumn); y:=to_integer(yrow); -- convert to integers
      
		--romID:=0;
		--if(x>=EMBORGX1 and x<EMBORGX1+MEMROWSIZE 
		  -- and y>=EMBORGY1 and y<EMBORGY1+MEMROWCOUNT) then romID:=1;
		--end if;
		
		--if(x>=EMBORGX2 and x<EMBORGX2+MEMROWSIZE 
		  -- and y>=EMBORGY2 and y<EMBORGY2+MEMROWCOUNT) then romID:=2;
		--end if;
		
		--if picture_q_s /= "00000000" then
		  -- RGB:=BACKGROUND;
		--end if;
					
		if(x<0) or (x>=XSCREEN) or (y<0) or (y>=YSCREEN) then
		   RGB:=BLACK; --black outside of visible frame
		
		--elsif romID>0 and picture_q_s /= "000000000" then -- no picture background
		  -- if romID=1 then
			 -- if picture_q_s = "00001010" then RGB:= BLUE_DARK;
			 -- elsif picture_q_s = "10011011" then RGB:= BLUE_LIGHT;
			  --end if;
			--end if;
		
		elsif (x-(XSCREEN/2))*(x-(XSCREEN/2)) + (y-(YSCREEN/2))*(y-(YSCREEN/2)) <= 10000 then
			if (6*y + 8*x < 250 + 3*YSCREEN + 4*XSCREEN AND 6*y + 250 + 8*x > 3*YSCREEN + 4*XSCREEN) then RGB:=BLUE_DARK;
				else RGB:=SKY;
			end if;
		elsif (4*y < 3*x + 250 AND 4*y + 250 > 3*x)
			then RGB:=VIOLET;
		else 
		   RGB:=BACKGROUND; -- else is necessary, the complete definition prevents forbidden latches
		end if;

		case romID is
		   when 1 =>
			   picture_address_s <= std_logic_vector(to_unsigned((y-EMBORGY1)*MEMROWSIZE + (x-EMBORGX1),
		                                                         picture_address_s'LENGTH));
         when 2 =>
			   -- we rotate rom coordinates by 90 degrees clockwise by matrix [0 1; -1 0]*[x y], i.e, xrom=-y, yrom=x
			   picture_address_s <= std_logic_vector(to_unsigned((EMBORGX2+MEMROWCOUNT-1-x)*MEMROWSIZE + (y-EMBORGY2),
		                                                         picture_address_s'LENGTH));
			when others => 
		      picture_address_s <=(others=>'0'); 
		end case; 

	-- Copy results in RGB to outputs of entity
		VGA_R<=RGB.R; VGA_G<=RGB.G; VGA_B<=RGB.B;
-----------------------------------------------------------------------------
	end process;

    
end architecture behavioral;