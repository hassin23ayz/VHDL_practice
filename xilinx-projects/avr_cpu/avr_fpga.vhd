-- ********** General Structure of VHDL files *************
-- Module Name: avr_fpga - Behavioral
-- Description: top level of a CPU : structure style of modeling 
-- in structure style of modeling the entity body maps all the components i/o together 
-- In structural style of modeling , An entity is modeled as a set of components connected by signals / as a netlist

-- ********** Header and Library Declaration **************
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- ********** Entity Declaration **************************
-- this is a top level Entity 
-- In Top Level Entity the input and output pins are the FPGA pins 

entity avr_fpga is
	port (
		-- Inputs start with I_
		I_CLK_100 : in std_logic;                       -- 100MHz clock from Board
		I_SWITCH  : in std_logic_vector(9 downto 0);    -- 8 bit DIP switch and 2 single Push Button
		I_RX      : in std_logic;                       -- Serial input of UART
        
        -- Outputs start with Q_
        Q_7_SEGMENT : out std_logic_vector(6 downto 0); -- 7 segment display 
        Q_LEDS      : out std_logic_vector(3 downto 0); -- 4 Leds
        Q_TX        : out std_logic);                   -- Serial output of UART 
end avr_fpga;
-- ********** Entity Architecture ************************* 

architecture Behavioral of avr_fpga is 
-- ****** Header starts ****** 
-- This Top level Entity avr_fpga has 3 components cpu, io & seg , in header components are declared 

component cpu_core
	port (
		I_CLK     : in std_logic;
		I_CLR     : in std_logic;
		I_INTVEC  : in std_logic_vector ( 5 downto 0);
		I_DIN     : in std_logic_vector ( 7 downto 0);

		Q_OPC     : out std_logic_vector( 15 downto 0);
		Q_PC      : out std_logic_vector( 15 downto 0);
		Q_DOUT    : out std_logic_vector(  7 downto 0);
		Q_ADR_IO  : out std_logic_vector(  7 downto 0);
		Q_RD_IO   : out std_logic;
		Q_WE_IO   : out std_logic
	);
end component;
-- signals declaration of cpu_core component
signal C_PC       : std_logic_vector( 15 downto 0);
signal C_OPC      : std_logic_vector( 15 downto 0);
signal C_ADR_IO   : std_logic_vector(  7 downto 0);
signal C_DOUT     : std_logic_vector(  7 downto 0);
signal C_RD_IO    : std_logic;
signal C_WE_IO    : std_logic;

component io
	port (
		I_CLK    : in std_logic;
		I_CLR    : in std_logic;
		I_ADR_IO : in std_logic_vector( 7 downto 0);
		I_DIN    : in std_logic_vector( 7 downto 0);
		I_RD_IO  : in std_logic;
		I_WE_IO  : in std_logic;
		I_SWITCH : in std_logic_vector( 7 downto 0);
		I_RX     : in std_logic;

		Q_7_SEGMENT : out std_logic_vector( 6 downto 0);
		Q_DOUT      : out std_logic_vector( 7 downto 0);
		Q_INTVEC    : out std_logic_vector( 5 downto 0);
		Q_LEDS      : out std_logic_vector( 1 downto 0);
		Q_TX        : out std_logic
	);
end component;
-- signals declaration of io component
signal N_INTVEC     : std_logic_vector(5 downto 0);
signal N_DOUT       : std_logic_vector(7 downto 0);
signal N_TX         : std_logic;
signal N_7_SEGMENT  : std_logic_vector(6 downto 0);

component segment7
	port (
		I_CLK    : in std_logic;
		I_CLR    : in std_logic;
		I_OPC    : in std_logic_vector( 15 downto 0);
		I_PC     : in std_logic_vector( 15 downto 0);

		Q_7_SEGMENT : out std_logic_vector( 6 downto 0)
	);
end component;
-- signals declaration of segment7 component
signal S_7_SEGMENT : std_logic_vector( 6 downto 0);

-- local signals are not driven by any component but by local processes and inputs of the entity 
signal L_CLK     : std_logic := '0';
signal L_CLK_CNT : std_logic_vector(2 downto 0) := "000";
signal L_CLR     : std_logic;          -- reset, active low
signal L_CLR_N   : std_logic := '0';   -- reset, active low 
signal L_C1_N    : std_logic := '0';   -- switch debounce , active low 
signal L_C2_N    : std_logic := '0';   -- switch debounce , active low 

-- ****** Header ends ******

-- ****** Body Starts ******
begin
	-- components instantiation : connects the ports of the component to the signals in the architecture
	-- the symbol => is used for mapping

	cpu : cpu_core
	port map(
		I_CLK    => L_CLK, 
		I_CLR    => L_CLR,
		I_DIN    => N_DOUT,
		I_INTVEC => N_INTVEC, 

		 --a component outputs drive local signals that are part of the instantiated (this) component 
		 --here the component output drives the signals that are part of the cpu component and starts with C_
		 
		Q_ADR_IO => C_ADR_IO,
		Q_DOUT   => C_DOUT,
		Q_OPC    => C_OPC,
		Q_PC     => C_PC,
		Q_RD_IO  => C_RD_IO,
		Q_WE_IO  => C_WE_IO
	);

	ino : io
	port map(
		I_CLK    		=> L_CLK,     
		I_CLR           => L_CLR,
		I_ADR_IO        => C_ADR_IO,
		I_DIN           => C_DOUT,
		I_RD_IO         => C_RD_IO,
		I_RX            => I_RX,
		I_SWITCH        => I_SWITCH(7 downto 0),
		I_WE_IO         => C_WE_IO, 
		

		Q_7_SEGMENT     => N_7_SEGMENT,
		Q_DOUT          => N_DOUT,
		Q_INTVEC        => N_INTVEC,
		Q_LEDS          => Q_LEDS(1 downto 0),
		Q_TX            => N_TX
	);

	seg : segment7

	port map(
		I_CLK           => L_CLK,
		I_CLR           => L_CLR,
		I_OPC           => C_OPC,
		I_PC            => C_PC,

		Q_7_SEGMENT     => S_7_SEGMENT
	);

end Behavioral;
-- ****** Body Ends ******
