----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:41:05 03/20/2021 
-- Design Name: 
-- Module Name:    ram_memory - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram_memory is
    Port ( I_clk : in  STD_LOGIC;
           I_we : in  STD_LOGIC;
           I_addr : in  STD_LOGIC_VECTOR (15 downto 0);
           I_data : in  STD_LOGIC_VECTOR (15 downto 0);
           O_data : out  STD_LOGIC_VECTOR (15 downto 0));
end ram_memory;

architecture Behavioral of ram_memory is
    type store_t is array (0 to 31) of std_logic_vector(15 downto 0);
    signal ram_16: store_t := (others => X"0000");
begin
    process (I_clk)
    begin
        if rising_edge(I_clk) then
            if (I_we = '1') then
                ram_16(to_integer(unsigned(I_addr(5 downto 0)))) <= I_data;
            else
                O_data <= ram_16(to_integer(unsigned(I_addr(5 downto 0))));
            end if;
        end if;
    end process;
end Behavioral;
