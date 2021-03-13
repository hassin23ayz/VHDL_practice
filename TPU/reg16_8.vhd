----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:16:21 03/13/2021 
-- Design Name: 
-- Module Name:    reg16_8 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg16_8 is
    Port ( I_clk : in  STD_LOGIC;
           I_en : in  STD_LOGIC;
           I_dataD : in  STD_LOGIC_VECTOR (15 downto 0);
           O_dataA : out  STD_LOGIC_VECTOR (15 downto 0);
           O_dataB : out  STD_LOGIC_VECTOR (15 downto 0);
           I_selA : in  STD_LOGIC_VECTOR (2 downto 0);
           I_selB : in  STD_LOGIC_VECTOR (2 downto 0);
           I_selD : in  STD_LOGIC_VECTOR (2 downto 0);
			  I_we : in STD_LOGIC
			);
end reg16_8;

architecture Behavioral of reg16_8 is

begin



end Behavioral;

