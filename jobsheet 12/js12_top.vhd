library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity js12_top is
  Port ( clk     : in  STD_LOGIC;
         PS2Clk  : in  STD_LOGIC;
         PS2Data : in  STD_LOGIC;
         seg     : out STD_LOGIC_VECTOR (6 downto 0);
         dp      : out STD_LOGIC;
         an      : out STD_LOGIC_VECTOR (3 downto 0);
         led     : out STD_LOGIC_VECTOR (15 downto 0) );
end js12_top;

architecture Behavioral of js12_top is
  signal code, last_code : std_logic_vector(7 downto 0) := (others => '0');
  signal ready  : std_logic;
  signal cnt    : unsigned(17 downto 0) := (others => '0');
  signal sel    : std_logic_vector(1 downto 0);
  signal nibble : std_logic_vector(3 downto 0);
  signal disp   : std_logic_vector(15 downto 0);
  signal brk, pressed, f0_seen : std_logic := '0';
  constant TARGET : std_logic_vector(7 downto 0) := x"2d";  -- tombol A
begin
  u_rx: entity work.ps2_receiver
    port map (clk => clk, ps2_clk => PS2Clk, ps2_data => PS2Data,
              scan_code => code, data_ready => ready);

  process(clk)
  begin
    if rising_edge(clk) then
      cnt <= cnt + 1;
      if ready = '1' then
        if code = x"F0" then
          brk <= '1';                       -- byte berikutnya = break code
          f0_seen <= '1';                   -- tandai: ada F0 (tombol dilepas)
        else
          brk <= '0';
          if brk = '0' then
            last_code <= code;              -- make code
            f0_seen <= '0';                 -- tombol baru ditekan: hapus tanda F0
          end if;
          if code = TARGET then pressed <= not brk; end if;
        end if;
      end if;
    end if;
  end process;

  led(0) <= pressed;
  led(15 downto 1) <= (others => '0');

  disp <= x"F0" & last_code when f0_seen = '1' else x"00" & last_code;
  dp   <= '1';
  sel  <= std_logic_vector(cnt(17 downto 16));

  with sel select
    an <= "1110" when "00",
          "1101" when "01",
          "1011" when "10",
          "0111" when others;

  with sel select
    nibble <= disp(3 downto 0)   when "00",
              disp(7 downto 4)   when "01",
              disp(11 downto 8)  when "10",
              disp(15 downto 12) when others;

  with nibble select
    seg <= "1000000" when x"0", "1111001" when x"1",
           "0100100" when x"2", "0110000" when x"3",
           "0011001" when x"4", "0010010" when x"5",
           "0000010" when x"6", "1111000" when x"7",
           "0000000" when x"8", "0010000" when x"9",
           "0001000" when x"A", "0000011" when x"B",
           "1000110" when x"C", "0100001" when x"D",
           "0000110" when x"E", "0001110" when x"F",
           "1111111" when others;
end Behavioral;