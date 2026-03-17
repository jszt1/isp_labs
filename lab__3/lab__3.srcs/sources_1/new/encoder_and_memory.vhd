library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity encoder_and_memory is
    Port (
        clk_i   : in  std_logic;
        rst_i   : in  std_logic;
        btn_i   : in  std_logic_vector(3 downto 0);  -- Przyciski: 3=L, 2=C, 1=R, 0=D
        sw_i    : in  std_logic_vector(7 downto 0);  -- SW7-SW4: Kropki (DP), SW3-SW0: Wartość Hex
        digit_o : out std_logic_vector(31 downto 0)  -- Wyjście do kontrolera wyświetlacza
    );
end encoder_and_memory;

architecture Behavioral of encoder_and_memory is
    
    -- pamiec wyswietlaczy
    signal memory_an3 : std_logic_vector(6 downto 0) := "1111111";
    signal memory_an2 : std_logic_vector(6 downto 0) := "1111111";
    signal memory_an1 : std_logic_vector(6 downto 0) := "1111111";
    signal memory_an0 : std_logic_vector(6 downto 0) := "1111111";

    -- reprezentacja segmentowa cyfry
    signal decoded_hex : std_logic_vector(6 downto 0);

begin
    process(sw_i)
    begin
        case sw_i(3 downto 0) is
            -- zamiana cyfry 4 bitowej na jej reprezentacje segmentowa
            when "0000" => 
                decoded_hex <= "1000000";
            when "0001" => 
                decoded_hex <= "1111001";
            when "0010" => 
                decoded_hex <= "0100100";
            when "0011" => 
                decoded_hex <= "0110000";
            when "0100" => 
                decoded_hex <= "0011001";
            when "0101" =>
                 decoded_hex <= "0010010";
            when "0110" => 
                decoded_hex <= "0000010";
            when "0111" => 
                decoded_hex <= "1111000";
            when "1000" => 
                decoded_hex <= "0000000";
            when "1001" => 
                decoded_hex <= "0010000";
            when "1010" => 
                decoded_hex <= "0001000";
            when "1011" => 
                decoded_hex <= "0000011";
            when "1100" => 
                decoded_hex <= "1000110";
            when "1101" => 
                decoded_hex <= "0100001";
            when "1110" => 
                decoded_hex <= "0000110";
            when "1111" => 
                decoded_hex <= "0001110";
            when others => 
                decoded_hex <= "1111111"; -- nie powinno tutaj trafic
        end case;
    end process;

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            memory_an3 <= "1111111";
            memory_an2 <= "1111111";
            memory_an1 <= "1111111";
            memory_an0 <= "1111111";
        elsif rising_edge(clk_i) then
            if btn_i(3) = '1' then 
                memory_an3 <= decoded_hex; 
            end if;
            if btn_i(2) = '1' then 
                memory_an2 <= decoded_hex;
            end if;
            if btn_i(1) = '1' then 
                memory_an1 <= decoded_hex;
            end if;
            if btn_i(0) = '1' then 
                memory_an0 <= decoded_hex;
            end if;
        end if;
    end process;

    -- najstarszy bit to dp
    digit_o(31) <= not sw_i(7);
    digit_o(30 downto 24) <= memory_an3;

    digit_o(23) <= not sw_i(6);
    digit_o(22 downto 16) <= memory_an2;

    digit_o(15) <= not sw_i(5);
    digit_o(14 downto 8) <= memory_an1;

    digit_o(7) <= not sw_i(4);
    digit_o(6 downto 0) <= memory_an0;

end Behavioral;