
----------------------------------------------------------------------------------
-- Company: University of Alberta, Edmonton
-- Engineer: 
-- 
-- Create Date: 02/10/2022
-- Design Name: 
-- Module Name: seven_segment.vhd - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity seven_segment is
    Port ( clk : in STD_LOGIC;
           val : in STD_LOGIC_VECTOR (7 downto 0);
           anode : out STD_LOGIC;
           seg_lines : out STD_LOGIC_VECTOR (6 downto 0));
end seven_segment;

architecture Behavioral of seven_segment is
    signal clk_slow: std_logic;
    signal highvalue, lowvalue: std_logic_vector (6 downto 0);
    
    component clk_divider generic( divider: positive := 62500000);
    Port ( clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
    end component;
    
begin

    clk_div: clk_divider generic map (
        divider => 625000) -- 3 ms
        port map( clk_in => clk,
                  clk_out => clk_slow);
    
    anode <= clk_slow;
    
    with val(3 downto 0) select 
    lowvalue <=   "1111110" when "0000", --0
                  
                  -- *** write the 7-bit value to display numbers 1 to 6 on the seven segment *** --- 

                  "0000110" when "0001", --1
                  "1101101" when "0010", --2
                  "1001111" when "0011", --3
                  "0010111" when "0100", --4
                  "1011011" when "0101", --5
                  "1111011" when "0110", --6
                  "0001110" when "0111", --7
                  "1111111" when "1000", --8
                  "1011111" when "1001", --9
                  "1110111" when "1010", --A
                  "1111100" when "1011", --B
                  "0111001" when "1100", --C
                  "1011110" when "1101", --D
                  "1111001" when "1110", --E
                  "1110001" when "1111", --F
                  "XXXXXXX" when others;
			      
                  --- ****************************** ---

    
    with val(7 downto 4) select 
    highvalue <=  "1111110" when "0000", --0

                  -- *** write the 7-bit value to display numbers 1 to 6 on the seven segment *** ---
                  
                  "0000110" when "0001", --1
                  "1101101" when "0010", --2
                  "1001111" when "0011", --3
                  "0010111" when "0100", --4
                  "1011011" when "0101", --5
                  "1111011" when "0110", --6
                  "0001110" when "0111", --7
                  "1111111" when "1000", --8
                  "1011111" when "1001", --9
                  "1110111" when "1010", --A
                  "1111100" when "1011", --B
                  "0111001" when "1100", --C
                  "1011110" when "1101", --D
                  "1111001" when "1110", --E
                  "1110001" when "1111", --F
                  "XXXXXXX" when others;  
               
    
    -- Switch between the two signals using clk_slow
    with clk_slow select
    seg_lines <= highvalue when '1',
                 lowvalue when '0',
                 "XXXXXXX" when others;

end Behavioral;

