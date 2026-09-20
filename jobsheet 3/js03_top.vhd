----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.09.2026 14:21:10
-- Design Name: 
-- Module Name: js03_top - Behavioral
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

entity js03_top is
    Port ( 
        sw  : in  STD_LOGIC_VECTOR (15 downto 0); -- Switch 0..15
        led : out STD_LOGIC_VECTOR (4 downto 0)   -- LED 0..4
    );
end js03_top;

architecture Behavioral of js03_top is
begin
    -- Instansiasi modul alu4
    u_alu: entity work.alu4
        port map (
            a      => sw(3 downto 0),   -- sw 0..3 -> input a
            b      => sw(7 downto 4),   -- sw 4..7 -> input b
            opcode => sw(15),           -- sw 15   -> opcode
            result => led(3 downto 0),  -- led 0..3 -> hasil
            carry  => led(4)            -- led 4   -> carry
        );
end Behavioral;