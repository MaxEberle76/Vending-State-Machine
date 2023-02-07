

----------------------------------------------------------------------------------
-- Company: University of Alberta, Edmonton
-- Engineer: Shyama Gandhi
-- 
-- Create Date: 10/02/2022 09:24:27 PM
-- Design Name: 
-- Module Name: vending_tb - Behavioral
-- Project Name: lab2 part2 testbench
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vending_tb is
--  Port ( );
end vending_tb;

architecture Behavioral of vending_tb is

component vending_m is
  Port ( clk            : in std_logic;
         reset          : in std_logic;
         item_sel       : in std_logic;                           -- sel=0 for phone case (10 $), sel=1 for earbuds (15 $)
         coins_in       : in std_logic_vector(2 downto 0);        -- "000" - 0$, "001" - 5$, "010" - 10$, "011" - 20$ and "100" - 50$ (Use three push buttons on the board)
         change_out     : out std_logic_vector(2 downto 0);       -- changeout is displayed on three leds - "000" - 0$, "001" - 5$, "010" - 10$, "011" - 20$ and "100" - 50$
         display_sum    : out std_logic_vector(6 downto 0);       -- display the current sum of inserted money on the seven segment
         select_segment : out std_logic;                          -- select the left or right segment
         phone_case     : out std_logic;                          -- turn on the LED to dispense phone case
         earbuds        : out std_logic); 
end component vending_m;


signal clk_tb: std_logic;
signal rst_tb: std_logic;
signal item_select_tb: std_logic; -- 0 for phone case, 1 for earbuds
signal coins_in_tb: std_logic_vector(2 downto 0); -- "000" for 0, "001" for 5$, "010" for 10$, "011" for 20$, "100" for 50$.
signal change_out_tb: std_logic_vector(2 downto 0); -- "000" for 0, "001" for 5$, "010" for 10$, "011" for 20$, "100" for 50$.
signal sevenseg_tb: std_logic_vector(6 downto 0);
signal phonecase_tb: std_logic;
signal earbuds_tb: std_logic;

constant clock_period: time := 40ns;

begin

vend: vending_m port map (
    clk => clk_tb,
    reset => rst_tb,
    item_sel => item_select_tb,
    coins_in => coins_in_tb,
    change_out => change_out_tb,
    display_sum => sevenseg_tb, -- Also ignored in tests, must be validated manually as it deals with constraints file.
    select_segment => open, --Ignore
    phone_case => phonecase_tb,
    earbuds => earbuds_tb
);

-- Clock turning on and off with 50% duty cycle
clock: process 
    begin
    clk_tb <= '0';
    wait for clock_period/2;
    clk_tb <= '1';
    wait for clock_period/2;
end process clock;

tb: process
    begin   
    
    rst_tb <= '1';
    item_select_tb <= '0';
    coins_in_tb <= "000";
    wait until rising_edge(clk_tb);
    rst_tb <= '0';
    
    wait until rising_edge(clk_tb);
    
    -------******************************------
    -- Write your test cases here.......
    
    -- Case 1: Buying phone case with $25
    item_select_tb <= '0';
    coins_in_tb <= "001";
    wait for 80ns;
    coins_in_tb <= "000";
    wait for 120ns; -- Wait for 3 clock periods to ensure nothing happens until sufficient funds are added
    coins_in_tb <= "011";
    wait for 80ns;
    coins_in_tb <= "000";
    wait until falling_edge(phonecase_tb);
    wait for 80ns;
    
    
    -- Case 2: Buying phone case with $10
    coins_in_tb <= "010";
    wait for 80ns;
    coins_in_tb <= "000";
    wait until falling_edge(phonecase_tb);
    wait for 80ns;
    
    
    -- Case 3: Buying phone case with $50
    coins_in_tb <= "100";
    wait for 80ns;
    coins_in_tb <= "000";
    wait until falling_edge(phonecase_tb);
    wait for 80ns;
    
    
    -- Case 4: Buying phone case with $55
    coins_in_tb <= "001";
    wait for 80ns;
    coins_in_tb <= "100";
    wait for 80ns;
    coins_in_tb <= "000";
    wait until falling_edge(phonecase_tb);
    wait for 80ns;
    
    
    -- Case 5: Buying earbuds with $15
    item_select_tb <= '1';
    coins_in_tb <= "010";
    wait for 80ns;
    coins_in_tb <= "000";
    wait for 120ns; -- Wait for 3 clock periods to ensure nothing happens until sufficient funds are added
    coins_in_tb <= "001";
    wait for 80ns;
    coins_in_tb <= "000";
    wait until falling_edge(earbuds_tb);
    wait for 80ns;
    
    
    -- Case 6: Buying earbuds with $20
    coins_in_tb <= "011";
    wait for 80ns;
    coins_in_tb <= "000";
    wait until falling_edge(earbuds_tb);
    wait for 80ns;
    

    -- Case 7: Buying earbuds with $60
    coins_in_tb <= "010";
    wait for 80ns;
    coins_in_tb <= "100";
    wait for 80ns;
    coins_in_tb <= "000";
    wait until falling_edge(earbuds_tb);
    wait for 80ns;
    
    -- Case 8: Buying earbuds with $30
    coins_in_tb <= "010";
    wait for 80ns;
    coins_in_tb <= "011";
    wait for 80ns;
    coins_in_tb <= "000";
    wait until falling_edge(earbuds_tb);
    
    -------******************************------
    
    wait;


end process tb;

end Behavioral;

