---- Company: Department of Electrical and Computer Engineering, University of Alberta
---- Engineer: Shyama Gandhi and Bruce Cockburn
---- 
---- Create Date: 28/09/2022 04:52:32 PM
---- Design Name: 
---- Module Name: seq_fsm - Behavioral
---- Project Name: 
---- Target Devices: Zybo Z7-10 
---- Tool Versions: 
---- Description: SEQUENCE DETECTOR : 10X01 - OVERLAPPING CASE : MEALY FSM
---- 
---- Dependencies: 
---- 
---- Revision:
---- Revision 0.01 - File Created

------------------------------------------------------------------------------------

---- Additional Comments:
---- **************** IMPORTANT COMMENTS ****************
---- ADD THE CODE IN THE COMMENTED SECTION. THERE ARE TWO INTENTIONAL MISTAKES TOO IN THIS CODE TEMPLATE! 
---- CORRECT THE MISTAKES TO ENSURE CORRECT WORKING OF FSM.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seq_fsm is
Port (clk           : in std_logic;
      reset         : in std_logic;
      seq_in        : in std_logic;
      output_detect : out std_logic);
end seq_fsm;

architecture Behavioral of seq_fsm is

signal clk_o : std_logic;

type states is (S0,S1,S2,S3,S4,S5,S6,S7,S8);
signal state_reg, state_next: states;

---------------------------------------------
-- Add the clk_divider component here
-- Remember, you want to add this component here and then use it later when you wish to have the divided clock by a factor of 62500000
component clk_divider is
    port(clk_in : in STD_LOGIC;
         clk_out : out STD_LOGIC
         );
end component;
---------------------------------------------
  
begin
---------------------------------------------
-- port map the clk_divider here
label_clk_divider : clk_divider 
    port map(clk_in => clk,
             clk_out => clk_o
             );
---------------------------------------------
    
    -- the process below uses the 'clk' i.e. the undivided clock , i.e. the clock signal from the entity.
    -- you can replace it with the divided clock signal later on when you add the 'clk_divider' component.
    -- same way, you will need to change the clock signal name in the 'elsif' statement inside the process below, later on!
    process(clk_o, reset) -- "clk" gets replaced with the divided clock later on!
        begin
           if(reset='1')then
                state_reg <= S0;
           elsif(rising_edge(clk_o))then  -- "clk" gets replaced with the divided clock later on!
                state_reg <= state_next;
           end if; 
    end process;
    
    process(clk_o, state_reg, seq_in) 
        begin
        case state_reg is
            when S0 =>    
                    if seq_in = '0' then -- if input is 0 then output 0 and loop back to state 0
                        state_next <= S0;
                        output_detect <= '0';
                    else -- if input is 1 then output 0 and move to state 1
                        state_next <= S1;
                        output_detect <= '0';
                    end if;
                    
             when S1 =>
                    if seq_in = '0' then
                        state_next <= S2;
                        output_detect <= '0';
                    else
                        state_next <= S1;
                        output_detect <= '0';
                    end if;
                    
             when S2 =>
                    if seq_in = '0' then
                        state_next <= S3;
                        output_detect <= '0';
                    else
                        state_next <= S6;
                        output_detect <= '0';
                    end if;
                    
             when S3 =>
                    if seq_in = '0' then
                         state_next <= S4;
                         output_detect <= '0';
                    else
                         state_next <= S1;
                         output_detect <= '0';
                    end if;
                    
             when S4 =>
                    if seq_in = '0' then
                        state_next <= S0;
                        output_detect <= '0';
                    else
                        state_next <= S5; -- here is when the 10001 sequence is detected
                        output_detect <= '1';
                    end if;
             
             when S5 =>
                    if seq_in = '0' then
                        state_next <= S2;
                        output_detect <= '0';
                    else
                        state_next <= S1;
                        output_detect <= '0';
                    end if;
                    
             when S6 =>
                    if seq_in = '0' then
                        state_next <= S7;
                        output_detect <= '0';
                    else
                        state_next <= S1;
                        output_detect <= '0';
                    end if;
             
             when S7 =>
                    if seq_in = '0' then
                        state_next <= S3;
                        output_detect <= '0';
                    else
                        state_next <= S8; -- here is when the 10101 sequence is detected
                        output_detect <= '1';
                    end if;
                    
             when S8 =>
                    if seq_in = '0' then
                        state_next <= S7;
                        output_detect <= '0';
                    else
                        state_next <= S1;
                        output_detect <= '0';
                    end if;                                        
             
             when others =>
                    state_next <= state_reg;
        
        end case;
    end process;
end Behavioral;


 