library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is
-- Testbench nie posiada portów
end tb;

architecture Behavioral of tb is
    signal clk_i      : std_logic := '0';
    signal rst_i      : std_logic := '0';
    signal RXD_i      : std_logic := '1';
    signal led7_an_o  : std_logic_vector(3 downto 0);
    signal led7_seg_o : std_logic_vector(7 downto 0);

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz
    constant BIT_TIME_9600 : time := 104167 ns; -- 9600 bps
    constant BIT_TIME_9600_PLUS_4P    : time := 108507 ns; -- 9600 bps - 4% = 9216 bps
    constant BIT_TIME_9600_MINUS_4P    : time := 100160 ns; -- 9600 bps + 4% = 9984 bps

begin
    UUT: entity work.top
        port map (
            clk_i      => clk_i,
            rst_i      => rst_i,
            RXD_i      => RXD_i,
            led7_an_o  => led7_an_o,
            led7_seg_o => led7_seg_o
        );

    clk_process: process
    begin
        clk_i <= '0';
        wait for CLK_PERIOD / 2;
        clk_i <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    tester: process
    
        -- jeden bajt na rxd_i
        procedure send_byte(
            constant data       : in std_logic_vector(7 downto 0);
            constant bit_send_time : in time
        ) is
        begin
            -- START (BIT = 0)
            RXD_i <= '0';
            wait for bit_send_time;

            for i in 0 to 7 loop
                RXD_i <= data(i);
                wait for bit_send_time;
            end loop;
            
            -- Bit stopu ('1')
            RXD_i <= '1';
            wait for bit_send_time;
        end procedure;

    begin
        -- RESET
        rst_i <= '1';
        wait for 100 ns;
        rst_i <= '0';
        wait for 100 ns;

        send_byte("01100111", BIT_TIME_9600);
        wait for 5 ms;

        send_byte("01100110", BIT_TIME_9600_PLUS_4P);
        wait for 5 ms;

        send_byte("01110110", BIT_TIME_9600_MINUS_4P);
        wait for 5 ms;

        wait;
    end process;
end Behavioral;