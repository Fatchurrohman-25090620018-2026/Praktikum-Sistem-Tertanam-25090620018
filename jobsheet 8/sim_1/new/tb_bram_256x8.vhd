library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_bram_256x8 is
end tb_bram_256x8;

architecture Behavioral of tb_bram_256x8 is
    component bram_256x8
        Port (
            clk  : in  STD_LOGIC;
            we   : in  STD_LOGIC;
            addr : in  STD_LOGIC_VECTOR (7 downto 0);
            din  : in  STD_LOGIC_VECTOR (7 downto 0);
            dout : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    signal clk  : STD_LOGIC := '0';
    signal we   : STD_LOGIC := '0';
    signal addr : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal din  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal dout : STD_LOGIC_VECTOR(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;
begin
    uut: bram_256x8 port map (
        clk => clk, we => we, addr => addr, din => din, dout => dout
    );

    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD/2;
        clk <= '1'; wait for CLK_PERIOD/2;
    end process;

    stim_proc: process
    begin
        wait for 20 ns;
        
        -- Tulis data X"A5" ke alamat 0x05
        we <= '1'; addr <= x"05"; din <= x"A5";
        wait for CLK_PERIOD;
        
        -- Tulis data X"5C" ke alamat 0x0A
        addr <= x"0A"; din <= x"5C";
        wait for CLK_PERIOD;
        
        -- Nonaktifkan Write Enable untuk mode Baca
        we <= '0';
        
        -- Baca alamat 0x05
        addr <= x"05";
        wait for CLK_PERIOD * 2;
        assert (dout = x"A5") report "Gagal membaca alamat 0x05!" severity error;

        -- Baca alamat 0x0A
        addr <= x"0A";
        wait for CLK_PERIOD * 2;
        assert (dout = x"5C") report "Gagal membaca alamat 0x0A!" severity error;

        wait;
    end process;
end Behavioral;