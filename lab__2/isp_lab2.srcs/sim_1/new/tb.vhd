----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2026 12:49:24 PM
-- Design Name: 
-- Module Name: tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb is
--  Port ( );
end tb;

architecture Behavioral of tb is


component top is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           led_o : out STD_LOGIC_VECTOR (2 downto 0));
end component top;

signal clk_i : STD_LOGIC := '0';
signal rst_i : STD_LOGIC := '0';
signal led_o : STD_LOGIC_VECTOR (2 downto 0);

begin

dut: top port map (
    clk_i => clk_i,
    rst_i => rst_i,
    led_o => led_o
);

clk_process : process
begin
    wait for 10ns;
    clk_i <= not clk_i;
end process;

stim_proc: process
begin
    -- First reset
    rst_i <= '1';
    wait for 25ns;
    rst_i <= '0';
    
    wait for 100ns;
    
    -- Second reset during work
    rst_i <= '1';
    wait for 25ns;
    rst_i <= '0';
    
    wait for 200ns;
    wait;
    
end process;


end Behavioral;
