----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.09.2026 15:53:07
-- Design Name: 
-- Module Name: tb_leading_one_detector - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_leading_one_detector is
end tb_leading_one_detector;

architecture Behavioral of tb_leading_one_detector is
    signal din   : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal pos   : STD_LOGIC_VECTOR (2 downto 0);
    signal valid : STD_LOGIC;
begin
    uut: entity work.leading_one_detector
        generic map (WIDTH => 8)
        port map (din => din, pos => pos, valid => valid);

    stim_proc: process
    begin
        -- Kasus 1: Tidak ada bit '1'
        din <= "00000000"; wait for 10 ns;
        assert (valid = '0') report "Error Kasus 1: valid harus '0'" severity error;

        -- Kasus 2: Bit '1' di MSB (indeks 7)
        din <= "10000000"; wait for 10 ns;
        assert (pos = "111" and valid = '1') report "Error Kasus 2: pos harus 7" severity error;

        -- Kasus 3: Bit '1' terbanyak di indeks 4
        din <= "00010110"; wait for 10 ns;
        assert (pos = "100" and valid = '1') report "Error Kasus 3: pos harus 4" severity error;

        -- Kasus 4: Bit '1' di LSB (indeks 0)
        din <= "00000001"; wait for 10 ns;
        assert (pos = "000" and valid = '1') report "Error Kasus 4: pos harus 0" severity error;

        -- Kasus 5: Bit '1' di indeks 2
        din <= "00000100"; wait for 10 ns;
        assert (pos = "010" and valid = '1') report "Error Kasus 5: pos harus 2" severity error;

        report "Simulasi tb_leading_one_detector SELESAI!";
        wait;
    end process;
end Behavioral;
