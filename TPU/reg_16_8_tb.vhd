--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:13:32 03/13/2021
-- Design Name:   
-- Module Name:   /home/ise/ise_projects/TPU/reg_16_8_tb.vhd
-- Project Name:  TPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: reg16_8
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY reg_16_8_tb IS
END reg_16_8_tb;
 
ARCHITECTURE behavior OF reg_16_8_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT reg16_8
    PORT(
         I_clk : IN  std_logic;
         I_en : IN  std_logic;
         I_dataD : IN  std_logic_vector(15 downto 0);
         O_dataA : OUT  std_logic_vector(15 downto 0);
         O_dataB : OUT  std_logic_vector(15 downto 0);
         I_selA : IN  std_logic_vector(2 downto 0);
         I_selB : IN  std_logic_vector(2 downto 0);
         I_selD : IN  std_logic_vector(2 downto 0);
         I_we : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal I_clk : std_logic := '0';
   signal I_en : std_logic := '0';
   signal I_dataD : std_logic_vector(15 downto 0) := (others => '0');
   signal I_selA : std_logic_vector(2 downto 0) := (others => '0');
   signal I_selB : std_logic_vector(2 downto 0) := (others => '0');
   signal I_selD : std_logic_vector(2 downto 0) := (others => '0');
   signal I_we : std_logic := '0';

 	--Outputs
   signal O_dataA : std_logic_vector(15 downto 0);
   signal O_dataB : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant I_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: reg16_8 PORT MAP (
          I_clk => I_clk,
          I_en => I_en,
          I_dataD => I_dataD,
          O_dataA => O_dataA,
          O_dataB => O_dataB,
          I_selA => I_selA,
          I_selB => I_selB,
          I_selD => I_selD,
          I_we => I_we
        );

   -- Clock process definitions
   I_clk_process :process
   begin
		I_clk <= '0';
		wait for I_clk_period/2;
		I_clk <= '1';
		wait for I_clk_period/2;
   end process;
	
	
	   -- Stimulus process
   StimulusProcess: process
   begin
      wait until reset = '1';
      wait until enable  = '1';
      wait_cycles(1);
      report "REGISTER: Running testbench";

      -- Test Write 1: Write 0xfab5 to R0
      I_selA <= "000";    -- Read R0
      I_selB <= "001";    -- Read R1
      I_selD <= "000";    -- Destination: R0
      I_dataD <= X"FAB5"; -- Data to write: 0xfab5
      I_we <= '1';        -- Write data on output
      wait_cycles(1);
      I_selA <= "000";    -- Read R0 -> Write to O_dataA
      wait_cycles(2);
      if (O_dataA=X"FAB5") then report "Test Write 1: Passed" severity NOTE;
        else report "Test Write 1: Failed" severity FAILURE;
      end if;

      -- Test Write 2: Write 0x2222 to R2
      I_selA <= "000";    -- Read R0
      I_selB <= "001";    -- Read R1
      I_selD <= "010";    -- Destination: R2
      I_dataD <= X"2222"; -- Data to write: 0x2222
      I_we <= '1';        -- Write data on output
      wait_cycles(1);
      I_selA <= "010";    -- Read R0 -> Write to O_dataA
      wait_cycles(2);
      if (O_dataA=X"2222") then report "Test Write 2: Passed" severity NOTE;
        else report "Test Write 2: Failed" severity FAILURE;
      end if;

      -- Test Write 3: Write 0x3333 to R2
      I_selA <= "000";    -- Read R0
      I_selB <= "001";    -- Read R1
      I_selD <= "010";    -- Destination: R2
      I_dataD <= X"3333"; -- Data to write: 0x3333
      I_we <= '1';        -- Write data on output
      wait_cycles(1);
      I_selA <= "010";    -- Read R2 -> Write to O_dataA
      I_selB <= "000";
      wait_cycles(2);
      if (O_dataA=X"3333") then report "Test Write 3: Passed" severity NOTE;
        else report "Test Write 3: Failed" severity FAILURE;
      end if;

      -- Test No Write: Prepare data for write but no write since no we
      I_selA <= "000";    -- Read R0
      I_selB <= "001";    -- Read R1
      I_selD <= "010";    -- Destination: R2
      I_dataD <= X"FEED"; -- Data to write: 0xFEED
      I_we <= '0';        -- DO NOT write the data on output
      wait_cycles(1);
      I_selA <= "010";    -- Read R2 -> Write to O_dataA
      wait_cycles(2);
      if (O_dataA=X"FEED") then report "Test No Write: Failed" severity FAILURE;
        else report "Test No Write: Passed" severity NOTE;
      end if;


      -- Test Combined Read: Write 0x4444 to R4 and read it on both inputs
      I_selA <= "000";
      I_selB <= "001";
      I_selD <= "100";
      I_dataD <= X"4444";
      I_we <= '1';
      wait_cycles(1);

      -- Wait for several cycles
      I_we <= '0';
      wait_cycles(1);

      -- No operations
      wait_cycles(1);

      I_selA <= "100";
      I_selB <= "100";
      wait_cycles(2);
      if (O_dataA=X"4444" and O_dataB=X"4444") then report "Test Combined Read: Passed" severity NOTE;
        else report "Test Combined Read: Failed" severity FAILURE;
      end if;

      running <= false;
      report "REGISTER: Testbench Complete";
   end process;

END;
