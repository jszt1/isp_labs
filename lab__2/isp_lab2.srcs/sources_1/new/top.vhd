----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2026 12:38:03 PM
-- Design Name: 
-- Module Name: top - Behavioral
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
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned valuesuse IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           led_o : out STD_LOGIC_VECTOR (2 downto 0));
end top;

architecture Behavioral of top is

    signal bin_cnt : unsigned(2 downto 0) := "000";

begin
    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            bin_cnt <= (others => '0');
        elsif rising_edge(clk_i) then
            bin_cnt <= bin_cnt + 1;
        end if;
    end process;
    
    -- Binary to gray conversion: G(i) = B(i) XOR B(i+1)
    
    led_o(2) <= bin_cnt(2);
    led_o(1) <= bin_cnt(2) xor bin_cnt(1);
    led_o(0) <= bin_cnt(1) xor bin_cnt(0);
    
end Behavioral;
