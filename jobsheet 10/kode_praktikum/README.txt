KODE PRAKTIKUM JOBSHEET 10 (Protokol AXI, IP Integrator, MIG/DDR2)

01_versi_dasar/
  axi_lite_gpio_v1_0.vhd   IP AXI4-Lite versi dasar (reg0..reg3 semuanya baca/tulis)   -> Kode 2 di laporan
  tb_axi_lite_gpio.vhd     Testbench versi dasar                                         -> Kode 3 di laporan

02_versi_akhir_tugas1/
  axi_lite_gpio_v1_0.vhd   IP versi akhir: reg1 = status switch (port sw, baca saja)    -> Lampiran A
  tb_axi_lite_gpio.vhd     Testbench versi akhir (menguji sw dan reg1)                  -> Lampiran B

03_constraint/
  basys3.xdc               Constraint Basys 3 untuk Block Design (clk_100MHz, reset_rtl_0_0,
                           gpio_out_0[15:0], sw_0[15:0])                                -> Kode 1 di laporan

Catatan:
- Untuk simulasi, buat project RTL terpisah: file IP sebagai design source, testbench sebagai
  simulation source (top = tb_axi_lite_gpio). Pakai pasangan IP dan testbench dari folder yang sama.
- Jangan campur IP versi dasar dengan testbench versi akhir (port sw tidak cocok).
- Nama port di basys3.xdc harus sama dengan port pada design_1_wrapper di project Vivado-mu.
