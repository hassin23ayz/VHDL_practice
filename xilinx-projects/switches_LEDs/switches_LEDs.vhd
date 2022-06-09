library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity switches_LEDs is
    Port ( 
	        --switch_0 : in  STD_LOGIC;
           --switch_1 : in  STD_LOGIC;
           LED_0 : out  STD_LOGIC;
           LED_1 : out  STD_LOGIC);
end switches_LEDs;

architecture Behavioral of switches_LEDs is

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

begin
	--LED_0 <= switch_0;
	--LED_1 <= switch_1;
	LED_0 <= '1';
	LED_1 <= '0';
	
end Behavioral;

