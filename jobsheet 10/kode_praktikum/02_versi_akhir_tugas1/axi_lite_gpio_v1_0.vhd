library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity axi_lite_gpio_v1_0 is
  Generic (
    C_S_AXI_ADDR_WIDTH : integer := 4;  -- 4 register x 4 byte = 16 byte -> 4 bit alamat
    C_S_AXI_DATA_WIDTH : integer := 32
  );
  Port (
    S_AXI_ACLK    : in  STD_LOGIC;
    S_AXI_ARESETN : in  STD_LOGIC;
    S_AXI_AWADDR  : in  STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID : in  STD_LOGIC;
    S_AXI_AWREADY : out STD_LOGIC;
    S_AXI_WDATA   : in  STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WVALID  : in  STD_LOGIC;
    S_AXI_WREADY  : out STD_LOGIC;
    S_AXI_BRESP   : out STD_LOGIC_VECTOR(1 downto 0);
    S_AXI_BVALID  : out STD_LOGIC;
    S_AXI_BREADY  : in  STD_LOGIC;
    S_AXI_ARADDR  : in  STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID : in  STD_LOGIC;
    S_AXI_ARREADY : out STD_LOGIC;
    S_AXI_RDATA   : out STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP   : out STD_LOGIC_VECTOR(1 downto 0);
    S_AXI_RVALID  : out STD_LOGIC;
    S_AXI_RREADY  : in  STD_LOGIC;
    gpio_out      : out STD_LOGIC_VECTOR(15 downto 0);  -- ke LED
    sw            : in  STD_LOGIC_VECTOR(15 downto 0)   -- dari switch (reg1)
  );
end axi_lite_gpio_v1_0;

architecture rtl of axi_lite_gpio_v1_0 is
  type reg_array is array (0 to 3) of std_logic_vector(31 downto 0);
  signal regs    : reg_array := (others => (others => '0'));
  signal awready : std_logic := '0';
  signal wready  : std_logic := '0';
  signal bvalid  : std_logic := '0';
  signal arready : std_logic := '0';
  signal rvalid  : std_logic := '0';
  signal rdata   : std_logic_vector(31 downto 0) := (others => '0');
begin
  S_AXI_AWREADY <= awready;
  S_AXI_WREADY  <= wready;
  S_AXI_BVALID  <= bvalid;
  S_AXI_BRESP   <= "00";          -- OKAY
  S_AXI_ARREADY <= arready;
  S_AXI_RVALID  <= rvalid;
  S_AXI_RRESP   <= "00";          -- OKAY
  S_AXI_RDATA   <= rdata;

  -- reg0(15:0) dipetakan ke LED
  gpio_out <= regs(0)(15 downto 0);

  ----------------------------------------------------------------
  -- Transaksi TULIS (alamat dan data diterima bersamaan)
  ----------------------------------------------------------------
  write_proc : process(S_AXI_ACLK)
    variable idx : integer range 0 to 3;
  begin
    if rising_edge(S_AXI_ACLK) then
      if S_AXI_ARESETN = '0' then
        awready <= '0';
        wready  <= '0';
        bvalid  <= '0';
        regs    <= (others => (others => '0'));
      else
        awready <= '0';
        wready  <= '0';
        if (awready = '0' and wready = '0' and bvalid = '0' and
            S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
          awready <= '1';
          wready  <= '1';
          bvalid  <= '1';
          idx := to_integer(unsigned(S_AXI_AWADDR(3 downto 2)));
          if idx /= 1 then                -- reg1 (switch) hanya-baca
            regs(idx) <= S_AXI_WDATA;
          end if;
        elsif bvalid = '1' and S_AXI_BREADY = '1' then
          bvalid <= '0';
        end if;
      end if;
    end if;
  end process;

  ----------------------------------------------------------------
  -- Transaksi BACA
  ----------------------------------------------------------------
  read_proc : process(S_AXI_ACLK)
    variable idx : integer range 0 to 3;
  begin
    if rising_edge(S_AXI_ACLK) then
      if S_AXI_ARESETN = '0' then
        arready <= '0';
        rvalid  <= '0';
        rdata   <= (others => '0');
      else
        arready <= '0';
        if (arready = '0' and rvalid = '0' and S_AXI_ARVALID = '1') then
          arready <= '1';
          rvalid  <= '1';
          idx := to_integer(unsigned(S_AXI_ARADDR(3 downto 2)));
          case idx is
            when 1      => rdata <= x"0000" & sw;   -- reg1 = status switch
            when others => rdata <= regs(idx);
          end case;
        elsif rvalid = '1' and S_AXI_RREADY = '1' then
          rvalid <= '0';
        end if;
      end if;
    end if;
  end process;

end rtl;
