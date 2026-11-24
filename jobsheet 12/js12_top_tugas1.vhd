-- ============================================================
-- js12_top_tugas1.vhd  (Jobsheet 12, Tugas 1)
-- Menampilkan scan code dan kode ASCII-nya pada seven-segment:
--   2 digit kiri  = scan code tombol terakhir
--   2 digit kanan = kode ASCII (hex) dari scan code tersebut
-- Contoh tekan O : "444F"   tekan 4 : "2534"
-- Port sama dengan js12_top sehingga Basys-3-Master.xdc tetap dipakai.
-- ============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity js12_top_tugas1 is
  Port ( clk     : in  STD_LOGIC;
         PS2Clk  : in  STD_LOGIC;
         PS2Data : in  STD_LOGIC;
         seg     : out STD_LOGIC_VECTOR (6 downto 0);
         dp      : out STD_LOGIC;
         an      : out STD_LOGIC_VECTOR (3 downto 0);
         led     : out STD_LOGIC_VECTOR (15 downto 0) );
end js12_top_tugas1;

architecture Behavioral of js12_top_tugas1 is
  signal code, last_code : std_logic_vector(7 downto 0) := (others => '0');
  signal ascii  : std_logic_vector(7 downto 0);
  signal ready  : std_logic;
  signal cnt    : unsigned(17 downto 0) := (others => '0');
  signal sel    : std_logic_vector(1 downto 0);
  signal nibble : std_logic_vector(3 downto 0);
  signal disp   : std_logic_vector(15 downto 0);
begin
  u_rx: entity work.ps2_receiver
    port map (clk => clk, ps2_clk => PS2Clk, ps2_data => PS2Data,
              scan_code => code, data_ready => ready);

  -- tabel lookup scan code -> ASCII (kombinasional)
  u_lut: entity work.scan2ascii
    port map (scan => last_code, ascii => ascii);

  process(clk)
  begin
    if rising_edge(clk) then
      cnt <= cnt + 1;
      if ready = '1' and code /= x"F0" then
        last_code <= code;                  -- simpan scan code (awalan F0 diabaikan)
      end if;
    end if;
  end process;

  disp <= last_code & ascii;                -- kiri: scan code, kanan: ASCII
  led  <= (others => '0');                  -- LED tidak dipakai pada Tugas 1
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
