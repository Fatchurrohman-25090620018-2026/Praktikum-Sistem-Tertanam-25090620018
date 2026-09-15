library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mux8to1 is
end tb_mux8to1;

architecture sim of tb_mux8to1 is
    signal sel_tb : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal in0_tb : STD_LOGIC_VECTOR(3 downto 0) := "0001"; -- 1
    signal in1_tb : STD_LOGIC_VECTOR(3 downto 0) := "0010"; -- 2
    signal in2_tb : STD_LOGIC_VECTOR(3 downto 0) := "0011"; -- 3
    signal in3_tb : STD_LOGIC_VECTOR(3 downto 0) := "0100"; -- 4
    signal in4_tb : STD_LOGIC_VECTOR(3 downto 0) := "0101"; -- 5
    signal in5_tb : STD_LOGIC_VECTOR(3 downto 0) := "0110"; -- 6
    signal in6_tb : STD_LOGIC_VECTOR(3 downto 0) := "0111"; -- 7
    signal in7_tb : STD_LOGIC_VECTOR(3 downto 0) := "1000"; -- 8
    signal y_tb   : STD_LOGIC_VECTOR(3 downto 0);
begin
    -- Instansiasi DUT (Device Under Test) MUX 8-to-1
    DUT: entity work.mux8to1
        port map (
            sel => sel_tb,
            in0 => in0_tb,
            in1 => in1_tb,
            in2 => in2_tb,
            in3 => in3_tb,
            in4 => in4_tb,
            in5 => in5_tb,
            in6 => in6_tb,
            in7 => in7_tb,
            y   => y_tb
        );

    stim_proc: process
    begin
        sel_tb <= "000"; wait for 20 ns;
        sel_tb <= "001"; wait for 20 ns;
        sel_tb <= "010"; wait for 20 ns;
        sel_tb <= "011"; wait for 20 ns;
        sel_tb <= "100"; wait for 20 ns;
        sel_tb <= "101"; wait for 20 ns;
        sel_tb <= "110"; wait for 20 ns;
        sel_tb <= "111"; wait for 20 ns;
        
        -- Assert tunggal untuk validasi akhir
        assert (y_tb = in7_tb)
            report "MUX 8-to-1 gagal: hasil akhir seharusnya sesuai in7" severity error;
            
        wait; -- Hentikan simulasi
    end process;
end sim;