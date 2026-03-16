library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( sw_i       : in STD_LOGIC_VECTOR (7 downto 0);
           led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
           led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0));
end top;

architecture Behavioral of top is

signal parity_bit : std_logic;

begin
    -- xorowanie wszystkich bitow zwraca liczbe_jedynek % 2
    parity_bit <= sw_i(7) xor sw_i(6) xor sw_i(5) xor sw_i(4) xor 
                  sw_i(3) xor sw_i(2) xor sw_i(1) xor sw_i(0);

    -- interesuje nas tylko wyswieltacz AN3
    led7_an_o <= "0111"; 

    process(parity_bit)
    begin
        if parity_bit = '0' then
            led7_seg_o <= "01100001";
        else
            led7_seg_o <= "00000011";
        end if;
    end process;

end Behavioral;