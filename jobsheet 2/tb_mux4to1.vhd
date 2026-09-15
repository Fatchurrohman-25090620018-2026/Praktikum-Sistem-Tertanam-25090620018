----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.09.2026 08:48:53
-- Design Name: 
-- Module Name: tb_mux4to1 - Behavioral
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

entity tb_mux4to1 is
end tb_mux4to1;

architecture sim of tb_mux4to1 is
    signal sel_tb : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal in0_tb : STD_LOGIC_VECTOR(3 downto 0) := "0001"; 
    signal in1_tb : STD_LOGIC_VECTOR(3 downto 0) := "0010"; 
    signal in2_tb : STD_LOGIC_VECTOR(3 downto 0) := "0100"; 
    signal in3_tb : STD_LOGIC_VECTOR(3 downto 0) := "1000"; 
    signal y_tb   : STD_LOGIC_VECTOR(3 downto 0);
begin
    -- Instansiasi DUT (Device Under Test)
    DUT: entity work.mux4to1
        port map (
            sel => sel_tb,
            in0 => in0_tb,
            in1 => in1_tb,
            in2 => in2_tb,
            in3 => in3_tb,
            y   => y_tb
        );

    stim_proc: process
    begin
        sel_tb <= "00"; wait for 20 ns;
        sel_tb <= "01"; wait for 20 ns;
        sel_tb <= "10"; wait for 20 ns;
        sel_tb <= "11"; wait for 20 ns;
        
        -- Pernyataan assert tunggal di akhir pengujian
        assert (y_tb = in3_tb)
            report "MUX 4-to-1 gagal: hasil akhir seharusnya sesuai in3" severity error;
            
        wait; -- Hentikan simulasi
    end process;
end sim;