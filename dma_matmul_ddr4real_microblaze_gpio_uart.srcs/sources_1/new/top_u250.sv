`timescale 1ns / 1ps

module top_u250 (
    input SYSCLK0_300_N,
    input SYSCLK0_300_P,
    
    input USER_SI570_CLOCK_N,
    input USER_SI570_CLOCK_P,

    input USB_UART_RX,
    output USB_UART_TX,

    output c0_ddr4_act_n,
    output [16:0] c0_ddr4_adr,
    output [1:0] c0_ddr4_ba,
    output [1:0] c0_ddr4_bg,
    output c0_ddr4_ck_c,
    output c0_ddr4_ck_t,
    output c0_ddr4_cke,
    output c0_ddr4_cs_n,
    inout [71:0] c0_ddr4_dq,
    inout [17:0] c0_ddr4_dqs_c,
    inout [17:0] c0_ddr4_dqs_t,
    output c0_ddr4_odt,
    output c0_ddr4_parity,
    output c0_ddr4_reset_n
);

  reg rst_n = 1'b0;

  /***********************************************/
  /******** BEGIN OF INTERFACE FOR MATMUL ********/
  /***********************************************/

  // Synchronized clock for all component
  wire clk;

  wire start_matmul_request;
  wire [3:0] v_reg_dest_addr;
  wire [3:0] v_reg_src_addr;
  wire [3:0] m_reg_src_addr;

  // Matrix Register File 0 signals
  logic [3:0] matrix_regfile0_port_addr;
  logic matrix_regfile0_port_en;
  logic matrix_regfile0_port_rst;
  logic [511:0] matrix_regfile0_port_we;
  logic [4095:0] matrix_regfile0_port_din;
  logic [4095:0] matrix_regfile0_port_dout;

  // Matrix Register File 1 signals
  logic [3:0] matrix_regfile1_port_addr;
  logic matrix_regfile1_port_en;
  logic matrix_regfile1_port_rst;
  logic [511:0] matrix_regfile1_port_we;
  logic [4095:0] matrix_regfile1_port_din;
  logic [4095:0] matrix_regfile1_port_dout;

  // Matrix Register File 2 signals
  logic [3:0] matrix_regfile2_port_addr;
  logic matrix_regfile2_port_en;
  logic matrix_regfile2_port_rst;
  logic [511:0] matrix_regfile2_port_we;
  logic [4095:0] matrix_regfile2_port_din;
  logic [4095:0] matrix_regfile2_port_dout;

  // Matrix Register File 3 signals
  logic [3:0] matrix_regfile3_port_addr;
  logic matrix_regfile3_port_en;
  logic matrix_regfile3_port_rst;
  logic [511:0] matrix_regfile3_port_we;
  logic [4095:0] matrix_regfile3_port_din;
  logic [4095:0] matrix_regfile3_port_dout;

  // Vector Register File signals
  logic [3:0] vector_regfile_port_addr;
  logic vector_regfile_port_en;
  logic vector_regfile_port_rst;
  logic [127:0] vector_regfile_port_we;
  logic [1023:0] vector_regfile_port_din;
  logic [1023:0] vector_regfile_port_dout;

  /***********************************************/
  /******** END OF INTERFACE FOR MATMUL ********/
  /***********************************************/





  /***********************************************/
  /************ BEGIN OF MATMUL LOGIC ************/
  /***********************************************/




  /***********************************************/
  /************* END OF MATMUL LOGIC *************/
  /***********************************************/



  // Instantiate the memory system wrapper
  memory_system_wrapper memory_system_wrapper_inst (
      .ddr4_sdram_c0_act_n(c0_ddr4_act_n),
      .ddr4_sdram_c0_adr(c0_ddr4_adr),
      .ddr4_sdram_c0_ba(c0_ddr4_ba),
      .ddr4_sdram_c0_bg(c0_ddr4_bg),
      .ddr4_sdram_c0_ck_c(c0_ddr4_ck_c),
      .ddr4_sdram_c0_ck_t(c0_ddr4_ck_t),
      .ddr4_sdram_c0_cke(c0_ddr4_cke),
      .ddr4_sdram_c0_cs_n(c0_ddr4_cs_n),
      .ddr4_sdram_c0_dq(c0_ddr4_dq),
      .ddr4_sdram_c0_dqs_c(c0_ddr4_dqs_c),
      .ddr4_sdram_c0_dqs_t(c0_ddr4_dqs_t),
      .ddr4_sdram_c0_odt(c0_ddr4_odt),
      .ddr4_sdram_c0_par(c0_ddr4_parity),
      .ddr4_sdram_c0_reset_n(c0_ddr4_reset_n),
      .default_300mhz_clk0_clk_n(SYSCLK0_300_N),
      .default_300mhz_clk0_clk_p(SYSCLK0_300_P),
      .matrix_regfile0_port_addr(matrix_regfile0_port_addr),
      .matrix_regfile0_port_clk(clk),
      .matrix_regfile0_port_din(matrix_regfile0_port_din),
      .matrix_regfile0_port_dout(matrix_regfile0_port_dout),
      .matrix_regfile0_port_en(matrix_regfile0_port_en),
      .matrix_regfile0_port_rst(matrix_regfile0_port_rst),
      .matrix_regfile0_port_we(matrix_regfile0_port_we),
      .matrix_regfile1_port_addr(matrix_regfile1_port_addr),
      .matrix_regfile1_port_clk(clk),
      .matrix_regfile1_port_din(matrix_regfile1_port_din),
      .matrix_regfile1_port_dout(matrix_regfile1_port_dout),
      .matrix_regfile1_port_en(matrix_regfile1_port_en),
      .matrix_regfile1_port_rst(matrix_regfile1_port_rst),
      .matrix_regfile1_port_we(matrix_regfile1_port_we),
      .matrix_regfile2_port_addr(matrix_regfile2_port_addr),
      .matrix_regfile2_port_clk(clk),
      .matrix_regfile2_port_din(matrix_regfile2_port_din),
      .matrix_regfile2_port_dout(matrix_regfile2_port_dout),
      .matrix_regfile2_port_en(matrix_regfile2_port_en),
      .matrix_regfile2_port_rst(matrix_regfile2_port_rst),
      .matrix_regfile2_port_we(matrix_regfile2_port_we),
      .matrix_regfile3_port_addr(matrix_regfile3_port_addr),
      .matrix_regfile3_port_clk(clk),
      .matrix_regfile3_port_din(matrix_regfile3_port_din),
      .matrix_regfile3_port_dout(matrix_regfile3_port_dout),
      .matrix_regfile3_port_en(matrix_regfile3_port_en),
      .matrix_regfile3_port_rst(matrix_regfile3_port_rst),
      .matrix_regfile3_port_we(matrix_regfile3_port_we),
      .resetn(rst_n),
      .rs232_uart_rxd(USB_UART_RX),
      .rs232_uart_txd(USB_UART_TX),
      .ui_clk(clk),
      .user_si570_clk_clk_n(USER_SI570_CLOCK_N),
      .user_si570_clk_clk_p(USER_SI570_CLOCK_P),
      .vector_regfile_port_addr(vector_regfile_port_addr),
      .vector_regfile_port_clk(clk),
      .vector_regfile_port_din(vector_regfile_port_din),
      .vector_regfile_port_dout(vector_regfile_port_dout),
      .vector_regfile_port_en(vector_regfile_port_en),
      .vector_regfile_port_rst(vector_regfile_port_rst),
      .vector_regfile_port_we(vector_regfile_port_we),
      .start_matmul_request(start_matmul_request),
      .v_reg_dest_addr(v_reg_dest_addr),
      .v_reg_src_addr(v_reg_src_addr),
      .m_reg_src_addr(m_reg_src_addr)
  );

  reg [63:0] clk_count = 0;
  // Generate a reset signal and initialize BRAM controls
  always @(posedge clk) begin
    clk_count <= clk_count + 1;
    if (clk_count < 64'd10) begin
      rst_n <= 1'b0;  // Assert reset for the first 10 clock cycles
    end else begin
      rst_n <= 1'b1;  // Release reset
    end

    if (clk_count == 64'd100000000) begin
      clk_count <= 64'd20;
    end
  end

endmodule
