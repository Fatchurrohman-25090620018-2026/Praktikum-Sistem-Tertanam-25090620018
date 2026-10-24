library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_i2c_master is
end tb_i2c_master;

architecture Behavioral of tb_i2c_master is
    component i2c_master
        Port (
            clk       : in    STD_LOGIC;
            reset     : in    STD_LOGIC;
            ena       : in    STD_LOGIC;
            addr      : in    STD_LOGIC_VECTOR(6 downto 0);
            rw        : in    STD_LOGIC;
            data_wr   : in    STD_LOGIC_VECTOR(7 downto 0);
            busy      : out   STD_LOGIC;
            data_rd   : out   STD_LOGIC_VECTOR(7 downto 0);
            ack_error : out   STD_LOGIC;
            scl       : inout STD_LOGIC;
            sda       : inout STD_LOGIC
        );
    end component;

    signal clk       : STD_LOGIC := '0';
    signal reset     : STD_LOGIC := '1';
    signal ena       : STD_LOGIC := '0';
    signal addr      : STD_LOGIC_VECTOR(6 downto 0) := "1001000"; -- Alamat Slave ADT7420
    signal rw        : STD_LOGIC := '0';
    signal data_wr   : STD_LOGIC_VECTOR(7 downto 0) := x"3B";
    signal busy      : STD_LOGIC;
    signal data_rd   : STD_LOGIC_VECTOR(7 downto 0);
    signal ack_error : STD_LOGIC;
    signal scl       : STD_LOGIC;
    signal sda       : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;
begin
    uut: i2c_master port map (
        clk => clk, reset => reset, ena => ena, addr => addr,
        rw => rw, data_wr => data_wr, busy => busy,
        data_rd => data_rd, ack_error => ack_error, scl => scl, sda => sda
    );

    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;

    stim_proc: process
    begin
        reset <= '1'; wait for 100 ns;
        reset <= '0'; wait for 100 ns;

        -- Picu transaksi I2C
        ena <= '1';
        wait for 20 ns;
        ena <= '0';

        wait;
    end process;
end Behavioral;