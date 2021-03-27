----------------------------------------------------------------------------------
-- Create Date:    16:28:39 03/26/2021 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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

library work;
use work.constant_codes.all;

entity alu is
    Port ( I_clk : in  STD_LOGIC;
           I_en : in  STD_LOGIC;
           I_dataA : in  STD_LOGIC_VECTOR (15 downto 0);
           I_dataB : in  STD_LOGIC_VECTOR (15 downto 0);
           I_dataDwe : in  STD_LOGIC;
           I_aluop : in  STD_LOGIC_VECTOR (4 downto 0);
           I_PC : in  STD_LOGIC_VECTOR (15 downto 0);
           I_dataIMM : in  STD_LOGIC_VECTOR (15 downto 0);
           O_dataResult : out  STD_LOGIC_VECTOR (15 downto 0);
           O_dataWriteReg : out  STD_LOGIC;
           O_shouldBranch : out  STD_LOGIC);
end alu;

--As input takes opcode given by the decoder 
architecture Behavioral of alu is
  --The internal register for results of operations
  --16 bit + carry/overflow 
  signal s_result: STD_LOGIC_VECTOR(17 downto 0) := (others => '0');
  signal s_shouldBranch: STD_LOGIC := '0';
begin
  process (I_clk, I_en)
  begin
    if rising_edge(I_clk) and I_en = '1' then
      O_dataWriteReg <= I_dataDwe;
      case I_aluop(4 downto 1) is
        -- ADD operation
        -- & is a concatenation operator
        -- =============
        when OPCODE_ADD =>
          if I_aluop(0) = '0' then -- Unsigned variation
            s_result(16 downto 0) <= std_logic_vector(unsigned('0' & I_dataA) + unsigned('0' & I_dataB));
          else                     -- Signed variation
            s_result(16 downto 0) <= std_logic_vector(signed(I_dataA(15) & I_dataA) + signed(I_dataB(15) & I_dataB));
          end if;
          s_shouldBranch <= '0';   -- Operation does not need branching 


          -- SUB operation
          -- =============
          when OPCODE_SUB =>
            if I_aluop(0) = '0' then -- Unsigned variation
              s_result(16 downto 0) <= std_logic_vector(unsigned('0' & I_dataA) - unsigned('0' & I_dataB));
            else                     -- Signed variation
              s_result(16 downto 0) <= std_logic_vector(signed(I_dataA(15) & I_dataA) - signed(I_dataB(15) & I_dataB));
            end if;
            s_shouldBranch <= '0';   -- Operation does not need branching


          -- OR operation
          -- ============
          when OPCODE_OR =>
            s_result(16-1 downto 0) <= I_dataA or I_dataB;
            s_shouldBranch <= '0';  -- Operation does not need branching

          -- XOR operation
          -- =============
          when OPCODE_XOR =>
            s_result(16-1 downto 0) <= I_dataA xor I_dataB;
            s_shouldBranch <= '0';  -- Operation does not need branching

          -- AND operation
          -- =============
          when OPCODE_AND =>
            s_result(16-1 downto 0) <= I_dataA and I_dataB;
            s_shouldBranch <= '0';  -- Operation does not need branching

          -- NOT operation
          -- =============
          when OPCODE_NOT =>
            s_result(16-1 downto 0) <= not I_dataA;
            s_shouldBranch <= '0';  -- Operation does not need branching


          -- LOAD operation
          -- ==============
          when OPCODE_LOAD =>
            if I_aluop(0) = '0' then -- High half variation of the register
              s_result(16-1 downto 0) <= I_dataImm(7 downto 0) & X"00";
            else -- Low half variation of the register
              s_result(16-1 downto 0) <= X"00" & I_dataImm(7 downto 0);
            end if;
            s_shouldBranch <= '0';


          -- CMP operation
          -- =============
          when OPCODE_CMP =>
            -- Compare A and B (EQUALITY)
            if I_dataA = I_dataB then
              s_result(CMP_BIT_EQ) <= '1';
            else
              s_result(CMP_BIT_EQ) <= '0';
            end if;

            -- Compare A to 0
            if I_dataA = X"0000" then
              s_result(CMP_BIT_AZ) <= '1';
            else
              s_result(CMP_BIT_AZ) <= '0';
            end if;

            -- Compare B to 0
            if I_dataB = X"0000" then
              s_result(CMP_BIT_BZ) <= '1';
            else
              s_result(CMP_BIT_BZ) <= '0';
            end if;

            -- Compare A and B (GREATER THAN)
            if I_aluop(0) = '0' then -- Unsigned version
              -- Unsigned A > B ?
              if unsigned(I_dataA) > unsigned(I_dataB) then
                s_result(CMP_BIT_AGB) <= '1';
              else
                s_result(CMP_BIT_AGB) <= '0';
              end if;
              -- Unsigned A < B ?
              if unsigned(I_dataA) < unsigned(I_dataB) then
                s_result(CMP_BIT_ALB) <= '1';
              else
                s_result(CMP_BIT_ALB) <= '0';
              end if;
            else -- Signed version
              -- Signed A > B ?
              if signed(I_dataA) > signed(I_dataB) then
                s_result(CMP_BIT_AGB) <= '1';
              else
                s_result(CMP_BIT_AGB) <= '0';
              end if;
              -- Signed A < B ?
              if signed(I_dataA) < signed(I_dataB) then
                s_result(CMP_BIT_ALB) <= '1';
              else
                s_result(CMP_BIT_ALB) <= '0';
              end if;
            end if;
            -- Zero unused bits and shouldBranch
            s_result(15) <= '0';
            s_result(9 downto 0) <= "0000000000";
            s_shouldBranch <= '0';

            -- SHL operation
            -- =============
            when OPCODE_SHL =>
                cmp_shl <= I_dataB(3 downto 0);
                case cmp_shl is
                  when "0001" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 1));
                  when "0010" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 2));
                  when "0011" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 3));
                  when "0100" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 4));
                  when "0101" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 5));
                  when "0110" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 6));
                  when "0111" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 7));
                  when "1000" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 8));
                  when "1001" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 9));
                  when "1010" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 10));
                  when "1011" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 11));
                  when "1100" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 12));
                  when "1101" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 13));
                  when "1110" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 14));
                  when "1111" =>
                    s_result(16-1 downto 0) <= std_logic_vector(shift_left(unsigned(I_dataA), 15));
                  when others =>
                    s_result(16-1 downto 0) <= I_dataA;
                end case;
                s_shouldBranch <= '0';

          -- JUMPEQ operation
          -- ================
          when OPCODE_JUMPEQ =>
            -- Set the branch target regardless of the results
            s_result(16-1 downto 0) <= I_dataB;

            -- The condition to jump is based on the flag and immediate value
            cmp_jumpeq <= (I_aluop(0) & I_dataImm(1 downto 0));
            case cmp_jumpeq is
              when CJF_EQ => -- Equality
                s_shouldBranch <= I_dataA(CMP_BIT_EQ);
              when CJF_AZ => -- A = 0
                s_shouldBranch <= I_dataA(CMP_BIT_AZ);
              when CJF_BZ => -- B = 0
                s_shouldBranch <= I_dataA(CMP_BIT_BZ);
              when CJF_ANZ => -- A != 0
                s_shouldBranch <= not I_dataA(CMP_BIT_AZ);
              when CJF_BNZ => -- B != 0
                s_shouldBranch <= not I_dataA(CMP_BIT_BZ);
              when CJF_AGB => -- A > B
                s_shouldBranch <= I_dataA(CMP_BIT_AGB);
              when CJF_ALB => -- B < 0
                s_shouldBranch <= I_dataA(CMP_BIT_ALB);
              when others =>
                s_shouldBranch <= '0';
            end case;
        -- ...Other codes...
        when others =>
          s_result <= "00" & X"FEFE"; -- Default Result Code
      end case;
    end if;
  end process;

  -- Propagate to outputs
  O_dataResult <= s_result(15 downto 0);
  O_shouldBranch <= s_shouldBranch;

end Behavioral;

