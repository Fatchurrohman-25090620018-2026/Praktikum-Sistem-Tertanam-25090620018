----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.09.2026 13:54:55
-- Design Name: 
-- Module Name: alu4 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity alu4 is
    Port ( 
        a      : in  STD_LOGIC_VECTOR (3 downto 0);
        b      : in  STD_LOGIC_VECTOR (3 downto 0);
        opcode : in  STD_LOGIC_VECTOR (1 downto 0); -- Opcode diubah jadi 2-bit
        result : out STD_LOGIC_VECTOR (7 downto 0)  -- Result diubah jadi 8-bit
    );
end alu4;

architecture Behavioral of alu4 is
begin
    process(a, b, opcode)
        variable a_uns, b_uns : unsigned(3 downto 0);
        variable res_mult     : unsigned(7 downto 0);
        variable res_add_sub  : unsigned(4 downto 0);
    begin
        a_uns := unsigned(a);
        b_uns := unsigned(b);
        
        case opcode is
            when "00" => -- Penjumlahan (A + B)
                res_add_sub := resize(a_uns, 5) + resize(b_uns, 5);
                result      <= std_logic_vector(resize(res_add_sub, 8));

            when "01" => -- Pengurangan (A - B)
                res_add_sub := resize(a_uns, 5) - resize(b_uns, 5);
                result      <= std_logic_vector(resize(res_add_sub, 8));

            when "10" => -- Perkalian (A * B)
                res_mult := a_uns * b_uns;
                result   <= std_logic_vector(res_mult);

            when others =>
                result <= (others => '0');
        end case;
    end process;
end Behavioral;