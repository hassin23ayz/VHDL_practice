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

begin
	--LED_0 <= switch_0;
	--LED_1 <= switch_1;
	LED_0 <= '0';
	LED_1 <= '1';
	
end Behavioral;

