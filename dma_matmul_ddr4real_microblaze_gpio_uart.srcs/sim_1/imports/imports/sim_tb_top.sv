`timescale 1ps / 1ps

`ifdef XILINX_SIMULATOR
module short (
    in1,
    in1
);
  inout in1;
endmodule
`endif

module sim_tb_top;

  localparam ADDR_WIDTH = 17;
  localparam DQ_WIDTH = 72;
  localparam DQS_WIDTH = 18;
  localparam DM_WIDTH = 9;
  localparam DRAM_WIDTH = 4;
  localparam tCK = 833;  //DDR4 interface clock period in ps
  localparam real SYSCLK_PERIOD = tCK;
  localparam NUM_PHYSICAL_PARTS = (DQ_WIDTH / DRAM_WIDTH);
  localparam CLAMSHELL_PARTS = (NUM_PHYSICAL_PARTS / 2);
  localparam ODD_PARTS = ((CLAMSHELL_PARTS * 2) < NUM_PHYSICAL_PARTS) ? 1 : 0;
  parameter RANK_WIDTH = 1;
  parameter CS_WIDTH = 1;
  parameter ODT_WIDTH = 1;
  parameter CA_MIRROR = "OFF";


  localparam MRS = 3'b000;
  localparam REF = 3'b001;
  localparam PRE = 3'b010;
  localparam ACT = 3'b011;
  localparam WR = 3'b100;
  localparam RD = 3'b101;
  localparam ZQC = 3'b110;
  localparam NOP = 3'b111;
  //Added to support RDIMM wrapper
  localparam ODT_WIDTH_RDIMM = 1;
  localparam CKE_WIDTH_RDIMM = 1;
  localparam CS_WIDTH_RDIMM = 1;
  localparam RANK_WIDTH_RDIMM = 1;
  localparam RDIMM_SLOTS = 1;
  localparam BANK_WIDTH_RDIMM = 2;
  localparam BANK_GROUP_WIDTH_RDIMM = 2;

  localparam DM_DBI = "NONE";
  localparam DM_WIDTH_RDIMM = 18;

  localparam MEM_PART_WIDTH = "x4";
  localparam REG_CTRL = "ON";

  import arch_package::*;
  parameter UTYPE_density CONFIGURED_DENSITY = _8G;

  // Input clock is assumed to be equal to the memory clock frequency
  // User should change the parameter as necessary if a different input
  // clock frequency is used
  localparam real CLKIN_PERIOD_NS = 3332 / 1000.0;

  //initial begin
  //   $shm_open("waves.shm");
  //   $shm_probe("ACMTF");
  //end

  reg         sys_clk_i;
  reg         sys_rst;

  wire        c0_sys_clk_p;
  wire        c0_sys_clk_n;

  reg         user_clk_i;

  wire        user_clk_p;
  wire        user_clk_n;

  reg  [16:0] c0_ddr4_adr_sdram       [1:0];
  reg  [ 1:0] c0_ddr4_ba_sdram        [1:0];
  reg  [ 1:0] c0_ddr4_bg_sdram        [1:0];


  wire        c0_ddr4_act_n;
  wire [16:0] c0_ddr4_adr;
  wire [ 1:0] c0_ddr4_ba;
  wire [ 1:0] c0_ddr4_bg;
  wire [ 0:0] c0_ddr4_cke;
  wire [ 0:0] c0_ddr4_odt;
  wire [ 0:0] c0_ddr4_cs_n;

  wire [ 0:0] c0_ddr4_ck_t_int;
  wire [ 0:0] c0_ddr4_ck_c_int;

  wire        c0_ddr4_ck_t;
  wire        c0_ddr4_ck_c;

  wire        c0_ddr4_reset_n;
  wire        c0_ddr4_parity;

  wire [71:0] c0_ddr4_dq;
  wire [17:0] c0_ddr4_dqs_c;
  wire [17:0] c0_ddr4_dqs_t;
  wire        c0_init_calib_complete;
  wire        c0_data_compare_error;


  reg  [31:0] cmdName;
  bit         en_model;
  tri         model_enable = en_model;



  //**************************************************************************//
  // Reset Generation
  //**************************************************************************//
  initial begin
    sys_rst = 1'b0;
    #200 sys_rst = 1'b1;
    en_model = 1'b0;
    #5 en_model = 1'b1;
    #200;
    sys_rst = 1'b0;
    #100;
  end

  //**************************************************************************//
  // Clock Generation
  //**************************************************************************//

  initial sys_clk_i = 1'b0;
  always sys_clk_i = #(3332 / 2.0) ~sys_clk_i;

  assign c0_sys_clk_p = sys_clk_i;
  assign c0_sys_clk_n = ~sys_clk_i;

  initial user_clk_i = 1'b0;
  always user_clk_i = #(6400 / 2.0) ~user_clk_i;

  assign user_clk_p = user_clk_i;
  assign user_clk_n = ~user_clk_i;

  assign c0_ddr4_ck_t = c0_ddr4_ck_t_int[0];
  assign c0_ddr4_ck_c = c0_ddr4_ck_c_int[0];

  always @(*) begin
    c0_ddr4_adr_sdram[0] <= c0_ddr4_adr;
    c0_ddr4_adr_sdram[1]   <=  (CA_MIRROR == "ON") ?
                                       {c0_ddr4_adr[ADDR_WIDTH-1:14],
                                        c0_ddr4_adr[11], c0_ddr4_adr[12],
                                        c0_ddr4_adr[13], c0_ddr4_adr[10:9],
                                        c0_ddr4_adr[7], c0_ddr4_adr[8],
                                        c0_ddr4_adr[5], c0_ddr4_adr[6],
                                        c0_ddr4_adr[3], c0_ddr4_adr[4],
                                        c0_ddr4_adr[2:0]} :
                                        c0_ddr4_adr;
    c0_ddr4_ba_sdram[0] <= c0_ddr4_ba;
    c0_ddr4_ba_sdram[1] <= (CA_MIRROR == "ON") ? {c0_ddr4_ba[0], c0_ddr4_ba[1]} : c0_ddr4_ba;
    c0_ddr4_bg_sdram[0] <= c0_ddr4_bg;
    c0_ddr4_bg_sdram[1]    <=  (CA_MIRROR == "ON" && DRAM_WIDTH != 16) ?
                                        {c0_ddr4_bg[0],
                                         c0_ddr4_bg[1]} :
                                         c0_ddr4_bg;
  end


  //===========================================================================
  //                         FPGA Memory Controller instantiation
  //===========================================================================

  top_u250 top (
      .SYSCLK0_300_N(c0_sys_clk_n),
      .SYSCLK0_300_P(c0_sys_clk_p),

      .USER_SI570_CLOCK_N(user_clk_n),
      .USER_SI570_CLOCK_P(user_clk_p),

      .c0_ddr4_act_n  (c0_ddr4_act_n),
      .c0_ddr4_adr    (c0_ddr4_adr),
      .c0_ddr4_ba     (c0_ddr4_ba),
      .c0_ddr4_bg     (c0_ddr4_bg),
      .c0_ddr4_cke    (c0_ddr4_cke),
      .c0_ddr4_odt    (c0_ddr4_odt),
      .c0_ddr4_cs_n   (c0_ddr4_cs_n),
      .c0_ddr4_ck_t   (c0_ddr4_ck_t_int),
      .c0_ddr4_ck_c   (c0_ddr4_ck_c_int),
      .c0_ddr4_reset_n(c0_ddr4_reset_n),
      .c0_ddr4_parity (c0_ddr4_parity),
      .c0_ddr4_dq     (c0_ddr4_dq),
      .c0_ddr4_dqs_c  (c0_ddr4_dqs_c),
      .c0_ddr4_dqs_t  (c0_ddr4_dqs_t)
  );


  reg [ADDR_WIDTH-1:0] DDR4_ADRMOD[RANK_WIDTH-1:0];

  always @(*)
    if (c0_ddr4_cs_n == 4'b1111) cmdName = "DSEL";
    else if (c0_ddr4_act_n)
      casez (DDR4_ADRMOD[0][16:14])
        MRS:     cmdName = "MRS";
        REF:     cmdName = "REF";
        PRE:     cmdName = "PRE";
        WR:      cmdName = "WR";
        RD:      cmdName = "RD";
        ZQC:     cmdName = "ZQC";
        NOP:     cmdName = "NOP";
        default: cmdName = "***";
      endcase
    else cmdName = "ACT";

  reg wr_en;
  always @(posedge c0_ddr4_ck_t) begin
    if (!c0_ddr4_reset_n) begin
      wr_en <= #100 1'b0;
    end else begin
      if (cmdName == "WR") begin
        wr_en <= #100 1'b1;
      end else if (cmdName == "RD") begin
        wr_en <= #100 1'b0;
      end
    end
  end

  genvar rnk;
  generate
    localparam IDX = CS_WIDTH;
    for (rnk = 0; rnk < IDX; rnk++) begin : rankup
      always @(*)
        if (c0_ddr4_act_n)
          casez (c0_ddr4_adr_sdram[0][16:14])
            WR, RD: begin
              DDR4_ADRMOD[rnk] = c0_ddr4_adr_sdram[rnk];
            end
            default: begin
              DDR4_ADRMOD[rnk] = c0_ddr4_adr_sdram[rnk];
            end
          endcase
        else begin
          DDR4_ADRMOD[rnk] = c0_ddr4_adr_sdram[rnk];
        end
    end
  endgenerate

  //===========================================================================
  //                         Memory Model instantiation
  //===========================================================================
  genvar rdimm_x;

  generate
    for (rdimm_x = 0; rdimm_x < RDIMM_SLOTS; rdimm_x = rdimm_x + 1) begin : instance_of_rdimm_slots
      ddr4_rdimm_wrapper #(
          .MC_DQ_WIDTH(DQ_WIDTH),
          .MC_DQS_BITS(DQS_WIDTH),
          .MC_DM_WIDTH(DM_WIDTH_RDIMM),
          .MC_CKE_NUM(CKE_WIDTH_RDIMM),
          .MC_ODT_WIDTH(ODT_WIDTH_RDIMM),
          .MC_ABITS(ADDR_WIDTH),
          .MC_BANK_WIDTH(BANK_WIDTH_RDIMM),
          .MC_BANK_GROUP(BANK_GROUP_WIDTH_RDIMM),
          .MC_CS_NUM(CS_WIDTH_RDIMM),
          .MC_RANKS_NUM(RANK_WIDTH_RDIMM),
          .NUM_PHYSICAL_PARTS(NUM_PHYSICAL_PARTS),
          .CALIB_EN("NO"),
          .tCK(tCK),
          .tPDM(),
          .MIN_TOTAL_R2R_DELAY(),
          .MAX_TOTAL_R2R_DELAY(),
          .TOTAL_FBT_DELAY(),
          .MEM_PART_WIDTH(MEM_PART_WIDTH),
          .MC_CA_MIRROR(CA_MIRROR),
          // .SDRAM("DDR4"),
`ifdef SAMSUNG
          .DDR_SIM_MODEL("SAMSUNG"),

`else
          .DDR_SIM_MODEL("MICRON"),
`endif
          .DM_DBI(DM_DBI),
          .MC_REG_CTRL(REG_CTRL),
          .DIMM_MODEL("RDIMM"),
          .RDIMM_SLOTS(RDIMM_SLOTS),
          .CONFIGURED_DENSITY(CONFIGURED_DENSITY)
      ) u_ddr4_rdimm_wrapper (
          .ddr4_act_n   (c0_ddr4_act_n),                     // input
          .ddr4_addr    (c0_ddr4_adr),                       // input
          .ddr4_ba      (c0_ddr4_ba),                        // input
          .ddr4_bg      (c0_ddr4_bg),                        // input
          .ddr4_par     (c0_ddr4_parity),                    // input
          .ddr4_cke     (c0_ddr4_cke[CKE_WIDTH_RDIMM-1:0]),  // input
          .ddr4_odt     (c0_ddr4_odt[ODT_WIDTH_RDIMM-1:0]),  // input
          .ddr4_cs_n    (c0_ddr4_cs_n[CS_WIDTH_RDIMM-1:0]),  // input
          .ddr4_ck_t    (c0_ddr4_ck_t),                      // input
          .ddr4_ck_c    (c0_ddr4_ck_c),                      // input
          .ddr4_reset_n (c0_ddr4_reset_n),                   // input
          .ddr4_dm_dbi_n(),
          .ddr4_dq      (c0_ddr4_dq),                        // inout
          .ddr4_dqs_t   (c0_ddr4_dqs_t),                     // inout
          .ddr4_dqs_c   (c0_ddr4_dqs_c),                     // inout
          .ddr4_alert_n (),                                  // inout
          .initDone     (c0_init_calib_complete),            // inout
          .scl          (),                                  // input
          .sa0          (),                                  // input
          .sa1          (),                                  // input
          .sa2          (),                                  // input
          .sda          (),                                  // inout
          .bfunc        (),                                  // input
          .vddspd       ()                                   // input
      );
    end
  endgenerate

  //===========================================================================
  //                         Testbench
  //===========================================================================

  integer log_file;  // File handle for logging
  integer dump_file;  // File handle for BRAM dump

  initial begin
    $dumpfile("sim_tb_top.vcd");
    $dumpvars(0, sim_tb_top);
  end

   initial begin
     // Open log file
     log_file = $fopen("sim_top_u250.log", "w");
     $fdisplay(log_file, "Simulation started");

     #500;

     @(posedge top.start_matmul_request);
     $display("Start request: %d", top.start_matmul_request);

    // Call task to dump vector_regfile
    dump_vector_regfile;
    dump_matrix_regfile0;
    dump_matrix_regfile1;
    dump_matrix_regfile2;
    dump_matrix_regfile3;

    $fclose(log_file);  // Close the log file before finishing
    $finish;
   end


   // Task to dump vector_regfile contents to bram_dump.txt
  task dump_vector_regfile;
    integer addr;
    integer dump_file;
    begin
      // Open dump file
      dump_file = $fopen("vector_dump.txt", "w");
      if (dump_file == 0) begin
        $display("Error: Could not open vector_dump.txt for writing");
        $finish;
      end
      $fdisplay(dump_file, "Vector Register File Dump");
      $fdisplay(dump_file, "------------------------");

      // Wait for reset to be released (clk_count >= 10 in top_u250)
      @(posedge top.clk);
      while (top.rst_n == 0) @(posedge top.clk);

      // Enable vector_regfile for reading
      top.vector_regfile_port_en  = 1;
      top.vector_regfile_port_rst = 0;
      top.vector_regfile_port_we  = 0;

      // Loop through all addresses (0 to 15)
      for (addr = 0; addr < 16; addr = addr + 1) begin
        top.vector_regfile_port_addr = addr;
        @(posedge top.clk);  // Wait for address to be set
        @(posedge top.clk);  // Wait for 2-cycle latency
        @(posedge top.clk);
        $fdisplay(dump_file, "ADDR: %0d DATA: %h", addr, top.vector_regfile_port_dout);
      end

      // Disable vector_regfile
      top.vector_regfile_port_en = 0;

      // Close dump file
      $fclose(dump_file);
    end
  endtask

  // Task to dump vector_regfile contents to matrix_dump.txt
  task dump_matrix_regfile0;
    integer addr;
    integer dump_file;
    begin
      // Open dump file
      dump_file = $fopen("matrix0_dump.txt", "w");
      if (dump_file == 0) begin
        $display("Error: Could not open matrix0_dump.txt for writing");
        $finish;
      end
      $fdisplay(dump_file, "Matrix Register File 0 Dump");
      $fdisplay(dump_file, "------------------------");

      // Wait for reset to be released (clk_count >= 10 in top_u250)
      @(posedge top.clk);
      while (top.rst_n == 0) @(posedge top.clk);

      // Enable vector_regfile for reading
      top.matrix_regfile0_port_en  = 1;
      top.matrix_regfile0_port_rst = 0;
      top.matrix_regfile0_port_we  = 0;

      // Loop through all addresses (0 to 15)
      for (addr = 0; addr < 16; addr = addr + 1) begin
        top.matrix_regfile0_port_addr = addr;
        @(posedge top.clk);  // Wait for address to be set
        @(posedge top.clk);  // Wait for 2-cycle latency
        @(posedge top.clk);
        $fdisplay(dump_file, "ADDR: %0d DATA: %h", addr, top.matrix_regfile0_port_dout);
      end

      // Disable vector_regfile
      top.matrix_regfile0_port_en = 0;

      // Close dump file
      $fclose(dump_file);
    end
  endtask

  // Task to dump vector_regfile contents to matrix_dump.txt
  task dump_matrix_regfile1;
    integer addr;
    integer dump_file;
    begin
      // Open dump file
      dump_file = $fopen("matrix1_dump.txt", "w");
      if (dump_file == 0) begin
        $display("Error: Could not open matrix1_dump.txt for writing");
        $finish;
      end
      $fdisplay(dump_file, "Matrix Register File 1 Dump");
      $fdisplay(dump_file, "------------------------");

      // Wait for reset to be released (clk_count >= 10 in top_u250)
      @(posedge top.clk);
      while (top.rst_n == 0) @(posedge top.clk);

      // Enable vector_regfile for reading
      top.matrix_regfile1_port_en  = 1;
      top.matrix_regfile1_port_rst = 0;
      top.matrix_regfile1_port_we  = 0;

      // Loop through all addresses (0 to 15)
      for (addr = 0; addr < 16; addr = addr + 1) begin
        top.matrix_regfile1_port_addr = addr;
        @(posedge top.clk);  // Wait for address to be set
        @(posedge top.clk);  // Wait for 2-cycle latency
        @(posedge top.clk);
        $fdisplay(dump_file, "ADDR: %0d DATA: %h", addr, top.matrix_regfile1_port_dout);
      end

      // Disable vector_regfile
      top.matrix_regfile1_port_en = 0;

      // Close dump file
      $fclose(dump_file);
    end
  endtask

  // Task to dump vector_regfile contents to matrix_dump.txt
  task dump_matrix_regfile2;
    integer addr;
    integer dump_file;
    begin
      // Open dump file
      dump_file = $fopen("matrix2_dump.txt", "w");
      if (dump_file == 0) begin
        $display("Error: Could not open matrix_dump.txt for writing");
        $finish;
      end
      $fdisplay(dump_file, "Matrix Register File 2 Dump");
      $fdisplay(dump_file, "------------------------");

      // Wait for reset to be released (clk_count >= 10 in top_u250)
      @(posedge top.clk);
      while (top.rst_n == 0) @(posedge top.clk);

      // Enable vector_regfile for reading
      top.matrix_regfile2_port_en  = 1;
      top.matrix_regfile2_port_rst = 0;
      top.matrix_regfile2_port_we  = 0;

      // Loop through all addresses (0 to 15)
      for (addr = 0; addr < 16; addr = addr + 1) begin
        top.matrix_regfile2_port_addr = addr;
        @(posedge top.clk);  // Wait for address to be set
        @(posedge top.clk);  // Wait for 2-cycle latency
        @(posedge top.clk);
        $fdisplay(dump_file, "ADDR: %0d DATA: %h", addr, top.matrix_regfile2_port_dout);
      end

      // Disable vector_regfile
      top.matrix_regfile2_port_en = 0;

      // Close dump file
      $fclose(dump_file);
    end
  endtask

  // Task to dump vector_regfile contents to matrix_dump.txt
  task dump_matrix_regfile3;
    integer addr;
    integer dump_file;
    begin
      // Open dump file
      dump_file = $fopen("matrix3_dump.txt", "w");
      if (dump_file == 0) begin
        $display("Error: Could not open matrix_dump.txt for writing");
        $finish;
      end
      $fdisplay(dump_file, "Matrix Register File 3 Dump");
      $fdisplay(dump_file, "------------------------");

      // Wait for reset to be released (clk_count >= 10 in top_u250)
      @(posedge top.clk);
      while (top.rst_n == 0) @(posedge top.clk);

      // Enable vector_regfile for reading
      top.matrix_regfile3_port_en  = 1;
      top.matrix_regfile3_port_rst = 0;
      top.matrix_regfile3_port_we  = 0;

      // Loop through all addresses (0 to 15)
      for (addr = 0; addr < 16; addr = addr + 1) begin
        top.matrix_regfile3_port_addr = addr;
        @(posedge top.clk);  // Wait for address to be set
        @(posedge top.clk);  // Wait for 2-cycle latency
        @(posedge top.clk);
        $fdisplay(dump_file, "ADDR: %0d DATA: %h", addr, top.matrix_regfile3_port_dout);
      end

      // Disable vector_regfile
      top.matrix_regfile3_port_en = 0;

      // Close dump file
      $fclose(dump_file);
    end
  endtask

endmodule
