library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ps2_receiver is
end tb_ps2_receiver;

architecture sim of tb_ps2_receiver is
  signal clk, ps2_clk, ps2_data : std_logic := '0';
  signal scan_code  : std_logic_vector(7 downto 0);
  signal data_ready : std_logic;
  signal seen       : std_logic := '0';
  constant HALF  : time := 30 us;
  constant FRAME : std_logic_vector(0 to 10) := "00011100001";
begin
  uut: entity work.ps2_receiver
    port map (clk => clk, ps2_clk => ps2_clk, ps2_data => ps2_data,
              scan_code => scan_code, data_ready => data_ready);

  clk <= not clk after 5 ns;   -- 100 MHz

  monitor: process
  begin
    wait until data_ready = '1';
    seen <= '1';
    assert scan_code = x"1C" report "scan_code SALAH" severity error;
    report "scan_code diterima dengan benar" severity note;
    wait;
  end process;

  stim: process
  begin
    ps2_clk <= '1'; ps2_data <= '1';
    wait for 100 us;
    for i in 0 to 10 loop
      ps2_data <= FRAME(i);
      wait for HALF;
      ps2_clk <= '0';          -- tepi turun: sampel data
      wait for HALF;
      ps2_clk <= '1';
    end loop;
    ps2_data <= '1';
    wait for 20 us;
    assert seen = '1' report "data_ready tidak pernah muncul" severity error;
    report "Simulasi selesai" severity note;
    wait;
  end process;
end sim;