----------------------------------------------------------------------------------
-- Create Date:    14:25:40 03/20/2021 
-- Design Name: 
-- Module Name:    decode - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

-- =================
--      Entity
-- =================

entity decode is
    Port ( I_clk : in  STD_LOGIC;  -- Clock signal
           I_en : in  STD_LOGIC;   -- Enable signal

           I_dataInst : in  STD_LOGIC_VECTOR (15 downto 0);  -- 16-bit Instruction
           O_selA : out  STD_LOGIC_VECTOR (2 downto 0);      -- Selects Register A from instruction
           O_selB : out  STD_LOGIC_VECTOR (2 downto 0);      -- Selects Register B from instruction
           O_selD : out  STD_LOGIC_VECTOR (2 downto 0);      -- Selects Register destination from instruction
           O_dataIMM : out  STD_LOGIC_VECTOR (15 downto 0);  -- Outputs Immediate value from instruction
           O_regDwe : out  STD_LOGIC;                        -- Makes Register Write enable 
           O_aluop : out  STD_LOGIC_VECTOR (4 downto 0));    -- Outputs ALU operation to perform
end decode;

-- =================
--   Architecture
-- =================

-- 15   14  13  12  11   10    9    8    7    6   5   4   3    2   1   0
-- [    ALU op   ]  [sel Reg-D ]  [ALU]  [sel Reg-A]  [sel Reg-B]
--                                       [       Immediate value       ]


architecture arch_decode of decode is
    -- Internal Objects
    -- None
begin
    -- Processes
    DecodeInstr: process(I_clk) -- I_clk added to the sensitivity list of the process
    begin
        if rising_edge(I_clk) and I_en='1' then  -- If new cycle and enable
            O_selA <= I_dataInst(7 downto 5);    -- Decode RA from instruction
            O_selB <= I_dataInst(4 downto 2);    -- Decode RB from instruction
            O_selD <= I_dataInst(11 downto 9);   -- Decode RD from instruction
            O_dataImm <= I_dataInst(7 downto 0) & I_dataInst(7 downto 0); -- Immediate value concatenated with itself to form a 16-bit output
            O_aluop <= I_dataInst(15 downto 12) & I_dataInst(8);          -- Decode alu operation: 4-bits OPCODE and flag (concatenated)

            -- Switch the instruction to set the write enable to NO in case of
            -- the following operations
            case I_dataInst(15 downto 12) is
                when "0111" => -- WRITE
                  O_regDwe <= '0';
                when "1100" => -- JUMP
                  O_regDwe <= '0';
                when "1101" => -- JUMPEQ
                  O_regDwe <= '0';
                when others =>
                  O_regDwe <= '1';
            end case;
        end if;
    end process;
end arch_decode;

