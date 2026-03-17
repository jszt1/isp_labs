library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top is
end tb_top;

architecture Behavioral of tb_top is

    signal clk_i      : std_logic := '0';
    signal btn_i      : std_logic_vector(3 downto 0) := "0000";
    signal sw_i       : std_logic_vector(7 downto 0) := "00000000";
    signal led7_an_o  : std_logic_vector(3 downto 0);
    signal led7_seg_o : std_logic_vector(7 downto 0);

    constant clk_period : time := 10 ns;

begin
    UUT: entity work.top
        port map (
            clk_i      => clk_i,
            btn_i      => btn_i,
            sw_i       => sw_i,
            led7_an_o  => led7_an_o,
            led7_seg_o => led7_seg_o
        );

    clk_process : process
    begin
        clk_i <= '0';
        wait for clk_period / 2;
        clk_i <= '1';
        wait for clk_period / 2;
    end process;

    stim_proc: process
    begin
        -- Zapalone kropki SW7 i SW5
        sw_i(7 downto 4) <= "1010"; 
        wait for 1 ms;

        -- 1 na AN3
        sw_i(3 downto 0) <= "0001";
        btn_i(3) <= '1';
        wait for 1 ms;
        btn_i(3) <= '0';
        
        
        wait for 1 ms;
        
        -- 2 na AN2
        sw_i(3 downto 0) <= "0010";
        wait for 1 ms;
        btn_i(2) <= '1';
        wait for 1 ms;
        btn_i(2) <= '0';
        wait for 1 ms;
        
        
        sw_i(7 downto 4) <= "0101";
        -- 3 na AN1
        sw_i(3 downto 0) <= "0011";
        wait for 1 ms;
        btn_i(1) <= '1';
        wait for 1 ms;
        btn_i(1) <= '0';
        wait for 1 ms;
        
        -- 4 na AN0
        sw_i(3 downto 0) <= "0100";
        wait for 1 ms;
        btn_i(0) <= '1';
        wait for 1 ms;
        btn_i(0) <= '0';
        wait for 1 ms;
        
        -- zmiana kropek, F na AN3
        sw_i(7 downto 4) <= "1000";
        sw_i(3 downto 0) <= "1111";
        wait for 1 ms;
        
        btn_i(3) <= '1';
        wait for 1 ms;
        btn_i(3) <= '0';

        wait for 2 ms;
        wait;
    end process;

end Behavioral;