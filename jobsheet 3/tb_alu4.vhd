----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.09.2026 13:56:16
-- Design Name: 
-- Module Name: tb_alu4 - Behavioral
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

entity tb_alu4 is
end tb_alu4;

architecture Behavioral of tb_alu4 is
    signal a, b   : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal opcode : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal result : STD_LOGIC_VECTOR(7 downto 0);
begin
    uut: entity work.alu4 
        port map (
            a => a, 
            b => b, 
            opcode => opcode, 
            result => result
        );

    stim_proc: process
    begin
        -- Test Penjumlahan: 7 + 3 = 10 (0x0A)
        a <= "0111"; b <= "0011"; opcode <= "00";
        wait for 10 ns;

        -- Test Pengurangan: 15 - 5 = 10 (0x0A)
        a <= "1111"; b <= "0101"; opcode <= "01";
        wait for 10 ns;

        -- Test Perkalian: 15 * 15 = 225 ("11100001")
        a <= "1111"; b <= "1111"; opcode <= "10";
        wait for 10 ns;

        wait;
    end process;
end Behavioral;