library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display is
    generic (
        SYSTEM_CLOCK_FREQ : integer := 100000000;
        MULTIPLEX_FREQ     : integer := 1000
    );
    Port ( clk_i       : in  std_logic;
           rst_i       : in  std_logic;
           digit_i     : in  std_logic_vector(31 downto 0);
           led7_an_o   : out std_logic_vector(3 downto 0);
           led7_seg_o  : out std_logic_vector(7 downto 0)
        );
end display;

architecture Behavioral of display is
constant CYCLES_PER_DIGIT : integer := SYSTEM_CLOCK_FREQ / MULTIPLEX_FREQ;
signal digit_selector   : unsigned(1 downto 0) := "00";
signal sys_cycles_passed : integer range 0 to CYCLES_PER_DIGIT - 1 := 0;
begin
    process(clk_i, rst_i)
    begin
        -- dla rst_i = 1 zapal wszystkie segmenty
        if rst_i = '1' then
            digit_selector <= "00";
            led7_an_o <= "0000";
            led7_seg_o <= "00000000";
            sys_cycles_passed <= 0;
        elsif rising_edge(clk_i) then
            -- cyfra wybrana jest na czas 1MHz / 1KHz
            if sys_cycles_passed = CYCLES_PER_DIGIT - 1 then
                sys_cycles_passed <= 0;
                digit_selector <= digit_selector + 1;
            else
                sys_cycles_passed <= sys_cycles_passed + 1;
            end if;
            
            -- zapal segmenty odpowiedniej cyfry
            case digit_selector is
                when "00" =>
                    led7_an_o  <= "1110";
                    led7_seg_o <= digit_i(7 downto 0);
                when "01" =>
                    led7_an_o  <= "1101";
                    led7_seg_o <= digit_i(15 downto 8);
                when "10" =>
                    led7_an_o  <= "1011";
                    led7_seg_o <= digit_i(23 downto 16);
                when "11" =>
                    led7_an_o  <= "0111";
                    led7_seg_o <= digit_i(31 downto 24);
                when others =>
                    led7_an_o  <= "1111";
                    led7_seg_o <= "11111111";
            end case;
        end if;
    end process;
end Behavioral;
