library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( 
        clk_i      : in  STD_LOGIC;
        btn_i      : in  STD_LOGIC_VECTOR (3 downto 0);
        sw_i       : in  STD_LOGIC_VECTOR (7 downto 0);
        led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
        led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
    );
end top;

architecture Structural of top is

    signal digit_bus : std_logic_vector(31 downto 0);

begin

    U1_Encoder: entity work.encoder_and_memory
        port map (
            clk_i   => clk_i,
            rst_i   => '0',
            btn_i   => btn_i,
            sw_i    => sw_i,
            digit_o => digit_bus
        );

    U2_Display: entity work.display
        generic map (
            SYSTEM_CLOCK_FREQ => 100_000_000,
            MULTIPLEX_FREQ    => 1_000
        )
        port map (
            clk_i      => clk_i,
            rst_i      => '0',
            digit_i    => digit_bus,
            led7_an_o  => led7_an_o,
            led7_seg_o => led7_seg_o
        );

end Structural;