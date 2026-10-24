library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2c_master is
    Generic (
        INPUT_CLK : integer := 100_000_000; -- 100 MHz
        BUS_CLK   : integer := 100_000      -- 100 kHz I2C SCL
    );
    Port (
        clk       : in    STD_LOGIC;
        reset     : in    STD_LOGIC;
        ena       : in    STD_LOGIC;
        addr      : in    STD_LOGIC_VECTOR(6 downto 0);
        rw        : in    STD_LOGIC; -- '0' untuk write, '1' untuk read
        data_wr   : in    STD_LOGIC_VECTOR(7 downto 0);
        busy      : out   STD_LOGIC;
        data_rd   : out   STD_LOGIC_VECTOR(7 downto 0);
        ack_error : out   STD_LOGIC;
        scl       : inout STD_LOGIC;
        sda       : inout STD_LOGIC
    );
end i2c_master;

architecture Behavioral of i2c_master is
    constant DIVIDER : integer := (INPUT_CLK / BUS_CLK) / 4; -- 250
    type i2c_state is (S_IDLE, S_START, S_ADDR, S_ADDR_ACK, S_DATA, S_DATA_ACK, S_STOP);
    signal state     : i2c_state := S_IDLE;

    signal count     : integer range 0 to DIVIDER*4 := 0;
    signal data_clk  : STD_LOGIC := '0';
    signal scl_clk   : STD_LOGIC := '0';
    signal scl_ena   : STD_LOGIC := '0';

    signal bit_cnt   : integer range 0 to 7 := 7;
    signal addr_rw   : STD_LOGIC_VECTOR(7 downto 0);
    signal data_tx   : STD_LOGIC_VECTOR(7 downto 0);
    signal sda_out   : STD_LOGIC := '1';
begin

    -- Pembangkit Clock SCL dan Pulsa Strobe Data (1 siklus clock)
    process(clk, reset)
    begin
        if reset = '1' then
            count <= 0;
            scl_clk <= '0';
            data_clk <= '0';
        elsif rising_edge(clk) then
            data_clk <= '0'; -- default pulse
            if count = DIVIDER*4 - 1 then
                count <= 0;
            else
                count <= count + 1;
            end if;

            case count is
                when 0 =>
                    scl_clk <= '0';
                when DIVIDER =>
                    data_clk <= '1'; -- Pulsa strobe 1 siklus
                when DIVIDER*2 =>
                    scl_clk <= '1';
                when others =>
                    null;
            end case;
        end if;
    end process;

    scl <= '0' when (scl_ena = '1' and scl_clk = '0') else 'Z';
    sda <= '0' when sda_out = '0' else 'Z';

    -- FSM I2C Master
    process(clk, reset)
    begin
        if reset = '1' then
            state <= S_IDLE;
            busy <= '1';
            scl_ena <= '0';
            sda_out <= '1';
            ack_error <= '0';
            data_rd <= (others => '0');
        elsif rising_edge(clk) then
            if state = S_IDLE then
                busy <= '0';
                scl_ena <= '0';
                sda_out <= '1';
                if ena = '1' then
                    busy <= '1';
                    addr_rw <= addr & rw;
                    data_tx <= data_wr;
                    state <= S_START;
                end if;
            elsif data_clk = '1' then
                case state is
                    when S_START =>
                        scl_ena <= '1';
                        sda_out <= '0';
                        bit_cnt <= 7;
                        state <= S_ADDR;

                    when S_ADDR =>
                        sda_out <= addr_rw(bit_cnt);
                        if bit_cnt = 0 then
                            state <= S_ADDR_ACK;
                        else
                            bit_cnt <= bit_cnt - 1;
                        end if;

                    when S_ADDR_ACK =>
                        sda_out <= '1';
                        if sda = '0' then
                            ack_error <= '0';
                        else
                            ack_error <= '1';
                        end if;
                        bit_cnt <= 7;
                        state <= S_DATA;

                    when S_DATA =>
                        if rw = '0' then
                            sda_out <= data_tx(bit_cnt);
                        else
                            sda_out <= '1';
                        end if;

                        if bit_cnt = 0 then
                            state <= S_DATA_ACK;
                        else
                            bit_cnt <= bit_cnt - 1;
                        end if;

                    when S_DATA_ACK =>
                        sda_out <= '1';
                        state <= S_STOP;

                    when S_STOP =>
                        sda_out <= '0';
                        scl_ena <= '0';
                        state <= S_IDLE;

                    when others =>
                        state <= S_IDLE;
                end case;
            end if;
        end if;
    end process;
end Behavioral;