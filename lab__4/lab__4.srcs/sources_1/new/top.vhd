library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( 
        clk_i      : in  STD_LOGIC;
        rst_i      : in  STD_LOGIC;
        RXD_i      : in  STD_LOGIC;
        led7_an_o  : out STD_LOGIC_VECTOR (3 downto 0);
        led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
    );
end top;

architecture Structural of top is

    signal rx_data   : std_logic_vector(7 downto 0) := (others => '0');
    signal digit_bus : std_logic_vector(31 downto 0);

    -- hex -> segment
    function decode_hex(hex_val : std_logic_vector(3 downto 0)) return std_logic_vector is
    begin
        case hex_val is
            when "0000" => return "1000000";
            when "0001" => return "1111001";
            when "0010" => return "0100100";
            when "0011" => return "0110000";
            when "0100" => return "0011001";
            when "0101" => return "0010010";
            when "0110" => return "0000010";
            when "0111" => return "1111000";
            when "1000" => return "0000000";
            when "1001" => return "0010000";
            when "1010" => return "0001000";
            when "1011" => return "0000011";
            when "1100" => return "1000110";
            when "1101" => return "0100001";
            when "1110" => return "0000110";
            when "1111" => return "0001110";
            when others => return "1111111";
        end case;
    end function;

begin

    U1_RS232: entity work.rs232_receiver
        generic map (
            CLK_FREQ  => 100_000_000,
            BAUD_RATE => 9600
        )
        port map (
            clk_i   => clk_i,
            rst_i   => rst_i,
            rxd_i   => RXD_i,
            data_o  => rx_data
        );

    -- wyświetlanie na AN0, AN1, kropka wyłączona
    digit_bus(31 downto 24) <= "11111111";
    digit_bus(23 downto 16) <= "11111111";
    digit_bus(15 downto 8)  <= '1' & decode_hex(rx_data(7 downto 4)); -- AN1 - starsza czesc
    digit_bus(7 downto 0)   <= '1' & decode_hex(rx_data(3 downto 0)); -- AN0 - mlodsza czesc

    U2_Display: entity work.display
        generic map (
            SYSTEM_CLOCK_FREQ => 100_000_000,
            MULTIPLEX_FREQ    => 1_000
        )
        port map (
            clk_i      => clk_i,
            rst_i      => rst_i,
            digit_i    => digit_bus,
            led7_an_o  => led7_an_o,
            led7_seg_o => led7_seg_o
        );

end Structural;