----------------------------------------------------------------------------------
-- Create Date:    06:16:21 03/13/2021 
-- Design Name: 
-- Module Name:    reg16_8 - Behavioral 
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

-- =================
-- Entity
-- =================
entity reg16_8 is
    Port ( I_clk   :  in  STD_LOGIC; --Clock Signal
           I_en    :  in  STD_LOGIC; --Enable
           I_dataD :  in  STD_LOGIC_VECTOR (15 downto 0); --Input Data
           O_dataA :  out STD_LOGIC_VECTOR (15 downto 0); --Output A
           O_dataB :  out STD_LOGIC_VECTOR (15 downto 0); --Output B
           I_selA  :  in  STD_LOGIC_VECTOR (2 downto 0);  --Input Select source A  [2^3=8]
           I_selB  :  in  STD_LOGIC_VECTOR (2 downto 0);  --Input Select source B  [2^3=8]
           I_selD  :  in  STD_LOGIC_VECTOR (2 downto 0);  --Input Select source Destination  [2^3=8]
		   I_we    :  in  STD_LOGIC                       --Write Enable
	    );
end reg16_8;
-- =================
-- Architecture
-- regs is an array of 8 SLVs each of length 16bit  
-- =================
architecture Behavioral of reg16_8 is
   type store_t is array (0 to 7) of std_logic_vector(15 downto 0);
   signal regs: store_t := (others => X"0000");
begin

	process(I_clk, I_en)
	begin
		if rising_edge(I_clk) and I_en='1' then
			O_dataA <= regs(to_integer(unsigned(I_selA)));  --second we select which register to be shown at output
			O_dataB <= regs(to_integer(unsigned(I_selB)));  --second we select which register to be shown at output
			if (I_we = '1') then
				regs(to_integer(unsigned(I_selD))) <= I_dataD; --first select register and put the data
			end if;
		end if;
	end process;

end Behavioral;
