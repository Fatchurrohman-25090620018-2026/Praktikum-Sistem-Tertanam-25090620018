library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity scan2ascii is
  Port ( scan  : in  STD_LOGIC_VECTOR (7 downto 0);
         ascii : out STD_LOGIC_VECTOR (7 downto 0) );
end scan2ascii;

architecture Behavioral of scan2ascii is
begin
  with scan select
    ascii <= x"41" when x"1C", x"42" when x"32", x"43" when x"21", x"44" when x"23",
             x"45" when x"24", x"46" when x"2B", x"47" when x"34", x"48" when x"33",
             x"49" when x"43", x"4A" when x"3B", x"4B" when x"42", x"4C" when x"4B",
             x"4D" when x"3A", x"4E" when x"31", x"4F" when x"44", x"50" when x"4D",
             x"51" when x"15", x"52" when x"2D", x"53" when x"1B", x"54" when x"2C",
             x"55" when x"3C", x"56" when x"2A", x"57" when x"1D", x"58" when x"22",
             x"59" when x"35", x"5A" when x"1A",
             x"30" when x"45", x"31" when x"16", x"32" when x"1E", x"33" when x"26",
             x"34" when x"25", x"35" when x"2E", x"36" when x"36", x"37" when x"3D",
             x"38" when x"3E", x"39" when x"46",
             x"00" when others;
end Behavioral;