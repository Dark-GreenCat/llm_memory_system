//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.1 (lin64) Build 5076996 Wed May 22 18:36:09 MDT 2024
//Date        : Fri Apr 25 14:44:27 2025
//Host        : edabk running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target memory_system_wrapper.bd
//Design      : memory_system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module memory_system_wrapper
   (ddr4_sdram_c0_act_n,
    ddr4_sdram_c0_adr,
    ddr4_sdram_c0_ba,
    ddr4_sdram_c0_bg,
    ddr4_sdram_c0_ck_c,
    ddr4_sdram_c0_ck_t,
    ddr4_sdram_c0_cke,
    ddr4_sdram_c0_cs_n,
    ddr4_sdram_c0_dq,
    ddr4_sdram_c0_dqs_c,
    ddr4_sdram_c0_dqs_t,
    ddr4_sdram_c0_odt,
    ddr4_sdram_c0_par,
    ddr4_sdram_c0_reset_n,
    default_300mhz_clk0_clk_n,
    default_300mhz_clk0_clk_p,
    m_reg_src_addr,
    matrix_regfile0_port_addr,
    matrix_regfile0_port_clk,
    matrix_regfile0_port_din,
    matrix_regfile0_port_dout,
    matrix_regfile0_port_en,
    matrix_regfile0_port_rst,
    matrix_regfile0_port_we,
    matrix_regfile1_port_addr,
    matrix_regfile1_port_clk,
    matrix_regfile1_port_din,
    matrix_regfile1_port_dout,
    matrix_regfile1_port_en,
    matrix_regfile1_port_rst,
    matrix_regfile1_port_we,
    matrix_regfile2_port_addr,
    matrix_regfile2_port_clk,
    matrix_regfile2_port_din,
    matrix_regfile2_port_dout,
    matrix_regfile2_port_en,
    matrix_regfile2_port_rst,
    matrix_regfile2_port_we,
    matrix_regfile3_port_addr,
    matrix_regfile3_port_clk,
    matrix_regfile3_port_din,
    matrix_regfile3_port_dout,
    matrix_regfile3_port_en,
    matrix_regfile3_port_rst,
    matrix_regfile3_port_we,
    resetn,
    rs232_uart_rxd,
    rs232_uart_txd,
    start_matmul_request,
    ui_clk,
    v_reg_dest_addr,
    v_reg_src_addr,
    vector_regfile_port_addr,
    vector_regfile_port_clk,
    vector_regfile_port_din,
    vector_regfile_port_dout,
    vector_regfile_port_en,
    vector_regfile_port_rst,
    vector_regfile_port_we);
  output ddr4_sdram_c0_act_n;
  output [16:0]ddr4_sdram_c0_adr;
  output [1:0]ddr4_sdram_c0_ba;
  output [1:0]ddr4_sdram_c0_bg;
  output ddr4_sdram_c0_ck_c;
  output ddr4_sdram_c0_ck_t;
  output ddr4_sdram_c0_cke;
  output ddr4_sdram_c0_cs_n;
  inout [71:0]ddr4_sdram_c0_dq;
  inout [17:0]ddr4_sdram_c0_dqs_c;
  inout [17:0]ddr4_sdram_c0_dqs_t;
  output ddr4_sdram_c0_odt;
  output ddr4_sdram_c0_par;
  output ddr4_sdram_c0_reset_n;
  input default_300mhz_clk0_clk_n;
  input default_300mhz_clk0_clk_p;
  output [3:0]m_reg_src_addr;
  input [3:0]matrix_regfile0_port_addr;
  input matrix_regfile0_port_clk;
  input [4095:0]matrix_regfile0_port_din;
  output [4095:0]matrix_regfile0_port_dout;
  input matrix_regfile0_port_en;
  input matrix_regfile0_port_rst;
  input [511:0]matrix_regfile0_port_we;
  input [3:0]matrix_regfile1_port_addr;
  input matrix_regfile1_port_clk;
  input [4095:0]matrix_regfile1_port_din;
  output [4095:0]matrix_regfile1_port_dout;
  input matrix_regfile1_port_en;
  input matrix_regfile1_port_rst;
  input [511:0]matrix_regfile1_port_we;
  input [3:0]matrix_regfile2_port_addr;
  input matrix_regfile2_port_clk;
  input [4095:0]matrix_regfile2_port_din;
  output [4095:0]matrix_regfile2_port_dout;
  input matrix_regfile2_port_en;
  input matrix_regfile2_port_rst;
  input [511:0]matrix_regfile2_port_we;
  input [3:0]matrix_regfile3_port_addr;
  input matrix_regfile3_port_clk;
  input [4095:0]matrix_regfile3_port_din;
  output [4095:0]matrix_regfile3_port_dout;
  input matrix_regfile3_port_en;
  input matrix_regfile3_port_rst;
  input [511:0]matrix_regfile3_port_we;
  input resetn;
  input rs232_uart_rxd;
  output rs232_uart_txd;
  output [0:0]start_matmul_request;
  output ui_clk;
  output [3:0]v_reg_dest_addr;
  output [3:0]v_reg_src_addr;
  input [3:0]vector_regfile_port_addr;
  input vector_regfile_port_clk;
  input [1023:0]vector_regfile_port_din;
  output [1023:0]vector_regfile_port_dout;
  input vector_regfile_port_en;
  input vector_regfile_port_rst;
  input [127:0]vector_regfile_port_we;

  wire ddr4_sdram_c0_act_n;
  wire [16:0]ddr4_sdram_c0_adr;
  wire [1:0]ddr4_sdram_c0_ba;
  wire [1:0]ddr4_sdram_c0_bg;
  wire ddr4_sdram_c0_ck_c;
  wire ddr4_sdram_c0_ck_t;
  wire ddr4_sdram_c0_cke;
  wire ddr4_sdram_c0_cs_n;
  wire [71:0]ddr4_sdram_c0_dq;
  wire [17:0]ddr4_sdram_c0_dqs_c;
  wire [17:0]ddr4_sdram_c0_dqs_t;
  wire ddr4_sdram_c0_odt;
  wire ddr4_sdram_c0_par;
  wire ddr4_sdram_c0_reset_n;
  wire default_300mhz_clk0_clk_n;
  wire default_300mhz_clk0_clk_p;
  wire [3:0]m_reg_src_addr;
  wire [3:0]matrix_regfile0_port_addr;
  wire matrix_regfile0_port_clk;
  wire [4095:0]matrix_regfile0_port_din;
  wire [4095:0]matrix_regfile0_port_dout;
  wire matrix_regfile0_port_en;
  wire matrix_regfile0_port_rst;
  wire [511:0]matrix_regfile0_port_we;
  wire [3:0]matrix_regfile1_port_addr;
  wire matrix_regfile1_port_clk;
  wire [4095:0]matrix_regfile1_port_din;
  wire [4095:0]matrix_regfile1_port_dout;
  wire matrix_regfile1_port_en;
  wire matrix_regfile1_port_rst;
  wire [511:0]matrix_regfile1_port_we;
  wire [3:0]matrix_regfile2_port_addr;
  wire matrix_regfile2_port_clk;
  wire [4095:0]matrix_regfile2_port_din;
  wire [4095:0]matrix_regfile2_port_dout;
  wire matrix_regfile2_port_en;
  wire matrix_regfile2_port_rst;
  wire [511:0]matrix_regfile2_port_we;
  wire [3:0]matrix_regfile3_port_addr;
  wire matrix_regfile3_port_clk;
  wire [4095:0]matrix_regfile3_port_din;
  wire [4095:0]matrix_regfile3_port_dout;
  wire matrix_regfile3_port_en;
  wire matrix_regfile3_port_rst;
  wire [511:0]matrix_regfile3_port_we;
  wire resetn;
  wire rs232_uart_rxd;
  wire rs232_uart_txd;
  wire [0:0]start_matmul_request;
  wire ui_clk;
  wire [3:0]v_reg_dest_addr;
  wire [3:0]v_reg_src_addr;
  wire [3:0]vector_regfile_port_addr;
  wire vector_regfile_port_clk;
  wire [1023:0]vector_regfile_port_din;
  wire [1023:0]vector_regfile_port_dout;
  wire vector_regfile_port_en;
  wire vector_regfile_port_rst;
  wire [127:0]vector_regfile_port_we;



  wire start_matmul_request_from_mem_system;
  memory_system memory_system_i
       (.ddr4_sdram_c0_act_n(ddr4_sdram_c0_act_n),
        .ddr4_sdram_c0_adr(ddr4_sdram_c0_adr),
        .ddr4_sdram_c0_ba(ddr4_sdram_c0_ba),
        .ddr4_sdram_c0_bg(ddr4_sdram_c0_bg),
        .ddr4_sdram_c0_ck_c(ddr4_sdram_c0_ck_c),
        .ddr4_sdram_c0_ck_t(ddr4_sdram_c0_ck_t),
        .ddr4_sdram_c0_cke(ddr4_sdram_c0_cke),
        .ddr4_sdram_c0_cs_n(ddr4_sdram_c0_cs_n),
        .ddr4_sdram_c0_dq(ddr4_sdram_c0_dq),
        .ddr4_sdram_c0_dqs_c(ddr4_sdram_c0_dqs_c),
        .ddr4_sdram_c0_dqs_t(ddr4_sdram_c0_dqs_t),
        .ddr4_sdram_c0_odt(ddr4_sdram_c0_odt),
        .ddr4_sdram_c0_par(ddr4_sdram_c0_par),
        .ddr4_sdram_c0_reset_n(ddr4_sdram_c0_reset_n),
        .default_300mhz_clk0_clk_n(default_300mhz_clk0_clk_n),
        .default_300mhz_clk0_clk_p(default_300mhz_clk0_clk_p),
        .m_reg_src_addr(m_reg_src_addr),
        .matrix_regfile0_port_addr(matrix_regfile0_port_addr),
        .matrix_regfile0_port_clk(matrix_regfile0_port_clk),
        .matrix_regfile0_port_din(matrix_regfile0_port_din),
        .matrix_regfile0_port_dout(matrix_regfile0_port_dout),
        .matrix_regfile0_port_en(matrix_regfile0_port_en),
        .matrix_regfile0_port_rst(matrix_regfile0_port_rst),
        .matrix_regfile0_port_we(matrix_regfile0_port_we),
        .matrix_regfile1_port_addr(matrix_regfile1_port_addr),
        .matrix_regfile1_port_clk(matrix_regfile1_port_clk),
        .matrix_regfile1_port_din(matrix_regfile1_port_din),
        .matrix_regfile1_port_dout(matrix_regfile1_port_dout),
        .matrix_regfile1_port_en(matrix_regfile1_port_en),
        .matrix_regfile1_port_rst(matrix_regfile1_port_rst),
        .matrix_regfile1_port_we(matrix_regfile1_port_we),
        .matrix_regfile2_port_addr(matrix_regfile2_port_addr),
        .matrix_regfile2_port_clk(matrix_regfile2_port_clk),
        .matrix_regfile2_port_din(matrix_regfile2_port_din),
        .matrix_regfile2_port_dout(matrix_regfile2_port_dout),
        .matrix_regfile2_port_en(matrix_regfile2_port_en),
        .matrix_regfile2_port_rst(matrix_regfile2_port_rst),
        .matrix_regfile2_port_we(matrix_regfile2_port_we),
        .matrix_regfile3_port_addr(matrix_regfile3_port_addr),
        .matrix_regfile3_port_clk(matrix_regfile3_port_clk),
        .matrix_regfile3_port_din(matrix_regfile3_port_din),
        .matrix_regfile3_port_dout(matrix_regfile3_port_dout),
        .matrix_regfile3_port_en(matrix_regfile3_port_en),
        .matrix_regfile3_port_rst(matrix_regfile3_port_rst),
        .matrix_regfile3_port_we(matrix_regfile3_port_we),
        .resetn(resetn),
        .rs232_uart_rxd(rs232_uart_rxd),
        .rs232_uart_txd(rs232_uart_txd),
        .start_matmul_request(start_matmul_request_from_mem_system),
        .ui_clk(ui_clk),
        .v_reg_dest_addr(v_reg_dest_addr),
        .v_reg_src_addr(v_reg_src_addr),
        .vector_regfile_port_addr(vector_regfile_port_addr),
        .vector_regfile_port_clk(vector_regfile_port_clk),
        .vector_regfile_port_din(vector_regfile_port_din),
        .vector_regfile_port_dout(vector_regfile_port_dout),
        .vector_regfile_port_en(vector_regfile_port_en),
        .vector_regfile_port_rst(vector_regfile_port_rst),
        .vector_regfile_port_we(vector_regfile_port_we));

    reg start_matmul_request_from_mem_system_pre = 0;
    reg start_matmul_request_real = 0;

    always @ (posedge ui_clk) begin
        start_matmul_request_from_mem_system_pre <= start_matmul_request_from_mem_system;
    end

    always @ (posedge ui_clk) begin
        if (start_matmul_request_from_mem_system_pre == 0 && start_matmul_request_from_mem_system == 1) begin
            start_matmul_request_real <= 1;
        end
        else begin
            start_matmul_request_real <= 0;
        end
    end

    assign start_matmul_request = start_matmul_request_real;
endmodule
