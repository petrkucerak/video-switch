
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LSP_Nios is

-------------------------------------------------------------------------------
--							 Port Declarations							 --
-------------------------------------------------------------------------------
port (
	-- Inputs
	CLOCK_50			: in std_logic;
	KEY				  	: in std_logic_vector (3 downto 0);
	SW				   	: in std_logic_vector (17 downto 0);

	--  Communication
	UART_RXD			: in std_logic;

	--  Memory (SRAM)
	SRAM_DQ				: inout std_logic_vector (15 downto 0);
	
	--  Memory (SRAM)
	SRAM_ADDR			: out std_logic_vector (19 downto 0);
	SRAM_CE_N			: out std_logic;
	SRAM_WE_N			: out std_logic;
	SRAM_OE_N			: out std_logic;
	SRAM_UB_N			: out std_logic;
	SRAM_LB_N			: out std_logic;


	-- Memory (SDRAM)
	DRAM_ADDR			: out std_logic_vector (12 downto 0);
	DRAM_BA				: out std_logic_vector (1 downto 0);
	DRAM_CAS_N			: out std_logic;
	DRAM_RAS_N			: out std_logic;
	DRAM_CLK			: out std_logic;
	DRAM_CKE			: out std_logic;
	DRAM_CS_N			: out std_logic;
	DRAM_WE_N			: out std_logic;
	DRAM_DQM			: out std_logic_vector (3 downto 0);
	
	-- Memory (SDRAM)
	DRAM_DQ				: inout std_logic_vector (31 downto 0);
	
	
   --  Communication
    UART_TXD            : out std_logic;
	
    --  Char LCD 16x2
    LCD_DATA            : inout std_logic_vector (7 downto 0);
    LCD_ON              : out std_logic;
    LCD_BLON            : out std_logic;
    LCD_EN              : out std_logic;
    LCD_RS              : out std_logic;
    LCD_RW              : out std_logic;
 
 	--  Simple
	HEX0				: out std_logic_vector (6 downto 0);
	HEX1				: out std_logic_vector (6 downto 0);
	HEX2				: out std_logic_vector (6 downto 0);
	HEX3				: out std_logic_vector (6 downto 0);
	HEX4				: out std_logic_vector (6 downto 0);
	HEX5				: out std_logic_vector (6 downto 0);
	HEX6				: out std_logic_vector (6 downto 0);
	HEX7				: out std_logic_vector (6 downto 0);
	LEDG				: out std_logic_vector (8 downto 0);
	LEDR				: out std_logic_vector (17 downto 0);
   
    -- External bus
    EBUS_ACK            : in    std_logic                     := '0';             -- to_external_bus_bridge_0_external_interface.acknowledge
    EBUS_address        : out   std_logic_vector(11 downto 0);                    --                                            .address
    EBUS_RW             : out   std_logic;                                        --                                            .rw
    EBUS_WR_data        : out   std_logic_vector(7 downto 0);                     --                                            .write_data
    EBUS_RD_data        : in    std_logic_vector(7 downto 0)  := (others => '0');  --                                            .read_data
    EBUS_byte_enable    : out   std_logic;                                        --                                            .byte_enable
    EBUS_enable         : out   std_logic                                        --                                            .bus_enable

	
	);
end LSP_Nios;


architecture LSP_Nios_rtl of LSP_Nios is

-------------------------------------------------------------------------------
--						   Subentity Declarations						  --
-------------------------------------------------------------------------------
	component nios_system is
    port (
        zs_addr_from_the_SDRAM                                  : out   std_logic_vector(12 downto 0);                    --                                  SDRAM_wire.addr
        zs_ba_from_the_SDRAM                                    : out   std_logic_vector(1 downto 0);                     --                                            .ba
        zs_cas_n_from_the_SDRAM                                 : out   std_logic;                                        --                                            .cas_n
        zs_cke_from_the_SDRAM                                   : out   std_logic;                                        --                                            .cke
        zs_cs_n_from_the_SDRAM                                  : out   std_logic;                                        --                                            .cs_n
        zs_dq_to_and_from_the_SDRAM                             : inout std_logic_vector(31 downto 0) := (others => '0'); --                                            .dq
        zs_dqm_from_the_SDRAM                                   : out   std_logic_vector(3 downto 0);                     --                                            .dqm
        zs_ras_n_from_the_SDRAM                                 : out   std_logic;                                        --                                            .ras_n
        zs_we_n_from_the_SDRAM                                  : out   std_logic;                                        --                                            .we_n
        HEX4_from_the_HEX7_HEX4                                 : out   std_logic_vector(6 downto 0);                     --                HEX7_HEX4_external_interface.HEX4
        HEX5_from_the_HEX7_HEX4                                 : out   std_logic_vector(6 downto 0);                     --                                            .HEX5
        HEX6_from_the_HEX7_HEX4                                 : out   std_logic_vector(6 downto 0);                     --                                            .HEX6
        HEX7_from_the_HEX7_HEX4                                 : out   std_logic_vector(6 downto 0);                     --                                            .HEX7
        SRAM_DQ_to_and_from_the_SRAM                            : inout std_logic_vector(15 downto 0) := (others => '0'); --                     SRAM_external_interface.DQ
        SRAM_ADDR_from_the_SRAM                                 : out   std_logic_vector(19 downto 0);                    --                                            .ADDR
        SRAM_LB_N_from_the_SRAM                                 : out   std_logic;                                        --                                            .LB_N
        SRAM_UB_N_from_the_SRAM                                 : out   std_logic;                                        --                                            .UB_N
        SRAM_CE_N_from_the_SRAM                                 : out   std_logic;                                        --                                            .CE_N
        SRAM_OE_N_from_the_SRAM                                 : out   std_logic;                                        --                                            .OE_N
        SRAM_WE_N_from_the_SRAM                                 : out   std_logic;                                        --                                            .WE_N
        reset_n                                                 : in    std_logic                     := '0';             --                            clk_clk_in_reset.reset_n
        LEDG_from_the_Green_LEDs                                : out   std_logic_vector(8 downto 0);                     --               Green_LEDs_external_interface.export
        SW_to_the_Slider_Switches                               : in    std_logic_vector(17 downto 0) := (others => '0'); --          Slider_Switches_external_interface.export
        UART_RXD_to_the_Serial_Port                             : in    std_logic                     := '0';             --              Serial_Port_external_interface.RXD
        UART_TXD_from_the_Serial_Port                           : out   std_logic;                                        --                                            .TXD
        clk                                                     : in    std_logic                     := '0';             --                                  clk_clk_in.clk
        KEY_to_the_Pushbuttons                                  : in    std_logic_vector(3 downto 0)  := (others => '0'); --              Pushbuttons_external_interface.export
        LEDR_from_the_Red_LEDs                                  : out   std_logic_vector(17 downto 0);                    --                 Red_LEDs_external_interface.export
        HEX0_from_the_HEX3_HEX0                                 : out   std_logic_vector(6 downto 0);                     --                HEX3_HEX0_external_interface.HEX0
        HEX1_from_the_HEX3_HEX0                                 : out   std_logic_vector(6 downto 0);                     --                                            .HEX1
        HEX2_from_the_HEX3_HEX0                                 : out   std_logic_vector(6 downto 0);                     --                                            .HEX2
        HEX3_from_the_HEX3_HEX0                                 : out   std_logic_vector(6 downto 0);                     --                                            .HEX3
        character_lcd_16x2_external_interface_DATA              : inout std_logic_vector(7 downto 0)  := (others => '0'); --       character_lcd_16x2_external_interface.DATA
        character_lcd_16x2_external_interface_ON                : out   std_logic;                                        --                                            .ON
        character_lcd_16x2_external_interface_BLON              : out   std_logic;                                        --                                            .BLON
        character_lcd_16x2_external_interface_EN                : out   std_logic;                                        --                                            .EN
        character_lcd_16x2_external_interface_RS                : out   std_logic;                                        --                                            .RS
        character_lcd_16x2_external_interface_RW                : out   std_logic;                                        --                                            .RW
        
        to_external_bus_bridge_0_external_interface_acknowledge : in    std_logic                     := '0';             -- to_external_bus_bridge_0_external_interface.acknowledge
        to_external_bus_bridge_0_external_interface_irq         : in    std_logic                     := '0';             --                                            .irq
        to_external_bus_bridge_0_external_interface_address     : out   std_logic_vector(11 downto 0);                    --                                            .address
        to_external_bus_bridge_0_external_interface_bus_enable  : out   std_logic;                                        --                                            .bus_enable
        to_external_bus_bridge_0_external_interface_byte_enable : out   std_logic;                                        --                                            .byte_enable
        to_external_bus_bridge_0_external_interface_rw          : out   std_logic;                                        --                                            .rw
        to_external_bus_bridge_0_external_interface_write_data  : out   std_logic_vector(7 downto 0);                     --                                            .write_data
        to_external_bus_bridge_0_external_interface_read_data   : in    std_logic_vector(7 downto 0)  := (others => '0')  --                                            .read_data
    );
end component;
	
	component sdram_pll IS
    PORT
    (
        inclk0  : IN STD_LOGIC  := '0';
        c0      : OUT STD_LOGIC;
        c1      : OUT STD_LOGIC 
    );
	end component;
	
-------------------------------------------------------------------------------
--						   Parameter Declarations						  --
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--				 Internal Wires and Registers Declarations				 --
-------------------------------------------------------------------------------
-- Internal Wires
-- Used to connect the Nios 2 system clock to the non-shifted output of the PLL
signal			 system_clock : STD_LOGIC;

-- Internal Registers

-- State Machine Registers

begin

-------------------------------------------------------------------------------
--						 Finite State Machine(s)						   --
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--							 Sequential Logic							  --
-------------------------------------------------------------------------------
	
-------------------------------------------------------------------------------
--							Combinational Logic							--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--							  Internal Modules							 --
-------------------------------------------------------------------------------



NiosII : nios_system
	port map(
		-- 1) global signals:
		clk	   									=> CLOCK_50,
		reset_n									=> KEY(0),
	
		-- the_Pushbuttons
		KEY_to_the_Pushbuttons					=> (KEY(3 downto 1) & "1"),

		-- the_Slider_switches
		SW_to_the_Slider_Switches				=> SW,

		-- the_Red_LEDs
		LEDR_from_the_Red_LEDs 					=> LEDR,
		
		-- the_Green_LEDs
		LEDG_from_the_Green_LEDs 				=> LEDG,
		
		-- the_HEX3_HEX0
		HEX0_from_the_HEX3_HEX0 				=> HEX0,
		HEX1_from_the_HEX3_HEX0 				=> HEX1,
		HEX2_from_the_HEX3_HEX0 				=> HEX2,
		HEX3_from_the_HEX3_HEX0 				=> HEX3,
		
		-- the_HEX7_HEX4
		HEX4_from_the_HEX7_HEX4 				=> HEX4,
		HEX5_from_the_HEX7_HEX4					=> HEX5,
		HEX6_from_the_HEX7_HEX4					=> HEX6,
		HEX7_from_the_HEX7_HEX4					=> HEX7,
		
        -- the_Char_LCD_16x2
        character_lcd_16x2_external_interface_DATA  => LCD_DATA,
        character_lcd_16x2_external_interface_ON           => LCD_ON,
        character_lcd_16x2_external_interface_BLON         => LCD_BLON,
        character_lcd_16x2_external_interface_EN           => LCD_EN,
        character_lcd_16x2_external_interface_RS           => LCD_RS,
        character_lcd_16x2_external_interface_RW           => LCD_RW,

		
		-- the_SDRAM
		zs_addr_from_the_SDRAM					=> DRAM_ADDR,
		zs_ba_from_the_SDRAM					=> DRAM_BA,
		zs_cas_n_from_the_SDRAM					=> DRAM_CAS_N,
		zs_cke_from_the_SDRAM					=> DRAM_CKE,
		zs_cs_n_from_the_SDRAM					=> DRAM_CS_N,
		zs_dq_to_and_from_the_SDRAM				=> DRAM_DQ,
		zs_dqm_from_the_SDRAM					=> DRAM_DQM,
		zs_ras_n_from_the_SDRAM					=> DRAM_RAS_N,
		zs_we_n_from_the_SDRAM					=> DRAM_WE_N,
		
		-- the_SRAM
		SRAM_ADDR_from_the_SRAM					=> SRAM_ADDR,
		SRAM_CE_N_from_the_SRAM					=> SRAM_CE_N,
		SRAM_DQ_to_and_from_the_SRAM			=> SRAM_DQ,
		SRAM_LB_N_from_the_SRAM					=> SRAM_LB_N,
		SRAM_OE_N_from_the_SRAM					=> SRAM_OE_N,
		SRAM_UB_N_from_the_SRAM 				=> SRAM_UB_N,
		SRAM_WE_N_from_the_SRAM 				=> SRAM_WE_N,
		
		-- the_Serial_port
		UART_RXD_to_the_Serial_Port				=> UART_RXD,
		UART_TXD_from_the_Serial_Port			=> UART_TXD,
		
 
        to_external_bus_bridge_0_external_interface_acknowledge=>EBUS_ACK,
        to_external_bus_bridge_0_external_interface_irq=>'0',
        to_external_bus_bridge_0_external_interface_address=>EBUS_address,                 
        to_external_bus_bridge_0_external_interface_bus_enable=>EBUS_enable,
        to_external_bus_bridge_0_external_interface_byte_enable=>EBUS_byte_enable,
        to_external_bus_bridge_0_external_interface_rw=>EBUS_RW,         
        to_external_bus_bridge_0_external_interface_write_data=>EBUS_WR_data, 
        to_external_bus_bridge_0_external_interface_read_data=>EBUS_RD_data  
   	);
	
neg_3ns : sdram_pll
	port map (
		inclk0									=> CLOCK_50,
		c0										=> DRAM_CLK,
		c1										=> system_clock
	);

end LSP_Nios_rtl;

