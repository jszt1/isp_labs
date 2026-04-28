library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rs232_receiver is
    Generic (
        CLK_FREQ  : integer := 100_000_000; -- 100 MHz
        BAUD_RATE : integer := 9600         -- 9600 bps
    );
    Port (
        clk_i   : in  STD_LOGIC;
        rst_i   : in  STD_LOGIC;
        rxd_i   : in  STD_LOGIC;
        data_o  : out STD_LOGIC_VECTOR(7 downto 0)
    );
end rs232_receiver;

architecture Behavioral of rs232_receiver is
    constant CLKS_PER_BIT  : integer := CLK_FREQ / BAUD_RATE;
    constant CLKS_HALF_BIT : integer := CLKS_PER_BIT / 2;

    type state_type is (IDLE, START, DATA, STOP);
    signal state : state_type := IDLE;

    signal baud_counter  : integer range 0 to CLKS_PER_BIT := 0;
    signal cur_bit_id   : integer range 0 to 7 := 0;
    signal temp_value : std_logic_vector(7 downto 0) := (others => '0');

    -- synchro
    signal rxd_sync_1 : std_logic := '1';
    signal rxd_sync   : std_logic := '1';
begin

    -- synchronizacja rxd_i z clk
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            rxd_sync_1 <= rxd_i;
            rxd_sync   <= rxd_sync_1;
        end if;
    end process;

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            state    <= IDLE;
            baud_counter <= 0;
            cur_bit_id  <= 0;
            data_o   <= (others => '0');
        elsif rising_edge(clk_i) then
            case state is
                when IDLE =>
                    baud_counter <= 0;

                    if rxd_sync = '0' then
                        state <= START;
                    end if;
                when START =>
                    -- Czekamy do połowy czasu trwania bitu, aby upewnić się, że to nie szum
                    if baud_counter = CLKS_HALF_BIT - 1 then
                        if rxd_sync = '0' then 
                            baud_counter <= 0;
                            cur_bit_id  <= 0;
                            state    <= DATA;
                        else
                            state <= IDLE;
                        end if;
                    else
                        baud_counter <= baud_counter + 1;
                    end if;
                when DATA =>
                    if baud_counter = CLKS_PER_BIT - 1 then
                        baud_counter <= 0;
                        temp_value(cur_bit_id) <= rxd_sync; -- RS232 wysyła najpierw LSB
                        if cur_bit_id = 7 then
                            state <= STOP;
                        else
                            cur_bit_id <= cur_bit_id + 1;
                        end if;
                    else
                        baud_counter <= baud_counter + 1;
                    end if;
                when STOP =>
                    if baud_counter = CLKS_PER_BIT - 1 then
                        baud_counter <= 0;
                        data_o   <= temp_value;
                        state    <= IDLE;
                    else
                        baud_counter <= baud_counter + 1;
                    end if;
            end case;
        end if;
    end process;

end Behavioral;