`timescale 1ns / 1ps

module sim_top_u250;

  reg clk;
  wire clk_p, clk_n;
  integer log_file;  // File handle for logging
  integer dump_file;  // File handle for BRAM dump

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  assign clk_p = clk;
  assign clk_n = ~clk;

  top_u250 top (
      .SYSCLK0_300_P(clk_p),
      .SYSCLK0_300_N(clk_n)
  );

  initial begin
    $dumpfile("sim_top_u250.vcd");
    $dumpvars(0, sim_top_u250);
  end

  initial begin
    // Open log file
    log_file = $fopen("sim_top_u250.log", "w");
    $fdisplay(log_file, "Simulation started");

    #500;
    @(posedge top.start_matmul_request);

    // Call task to dump vector_regfile
    dump_vector_regfile;
    dump_matrix_regfile0;
    dump_matrix_regfile1;
    dump_matrix_regfile2;
    dump_matrix_regfile3;

    $fclose(log_file);  // Close the log file before finishing
    $finish;
  end

  // initial begin
  //   while (1) begin
  //     @(posedge clk) begin
  //       if (top.memory_system_wrapper_inst.memory_system_i.axi_cdma_0.cdma_introut == 1) begin
  //         $fdisplay(log_file, "Time = %-0t | cdma_introut = %0d", $time,
  //                   top.memory_system_wrapper_inst.memory_system_i.axi_cdma_0.cdma_introut);
  //       end
  //       if ((top.memory_system_wrapper_inst.memory_system_i.axi_cdma_0.m_axi_rready == 1) && 
  //           (top.memory_system_wrapper_inst.memory_system_i.axi_cdma_0.m_axi_rvalid == 1)) begin
  //         $fdisplay(log_file, "Time = %-0t | m_axi_rdata = %0h", $time,
  //                   top.memory_system_wrapper_inst.memory_system_i.axi_cdma_0.m_axi_rdata);
  //       end
  //     end
  //   end
  // end












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

// task automatic dump_matrix_regfile(input integer matrix_idx, output reg port_en,
//                                    output reg port_rst, output reg [511:0] port_we,
//                                    output reg [3:0] port_addr, input [4095:0] port_dout);
//   integer addr;
//   integer dump_file;
//   string  filename;
//   begin
//     // Generate filename based on matrix index
//     filename  = $sformatf("matrix%0d_dump_hello.txt", matrix_idx);

//     // Open dump file
//     dump_file = $fopen(filename, "w");
//     if (dump_file == 0) begin
//       $display("Error: Could not open %s for writing", filename);
//       $finish;
//     end
//     $fdisplay(dump_file, "Matrix Register File %0d Dump", matrix_idx);
//     $fdisplay(dump_file, "------------------------");

//     // Wait for reset to be released
//     @(posedge clk);
//     while (top.rst_n == 0) @(posedge clk);

//     // Enable the BRAM for reading
//     port_en  = 1;
//     port_rst = 0;
//     port_we  = 0;

//     // Loop through all addresses (0 to 15)
//     for (addr = 0; addr < 16; addr = addr + 1) begin
//       port_addr = addr;
//       @(posedge clk);  // Wait for address to be set
//       @(posedge clk);  // Wait for 2-cycle latency
//       $fdisplay(dump_file, "ADDR: %0d DATA: %h", addr, port_dout);
//     end

//     // Disable the BRAM
//     port_en = 0;

//     // Close dump file
//     $fclose(dump_file);
//   end
// endtask



// // Dump matrix2
// dump_matrix_regfile(2, top.matrix_regfile0_port_en, top.matrix_regfile0_port_rst,
//                     top.matrix_regfile0_port_we, top.matrix_regfile0_port_addr,
//                     top.matrix_regfile0_port_dout);
// // Dump matrix3
// dump_matrix_regfile(3, top.matrix_regfile3_port_en, top.matrix_regfile3_port_rst,
//                     top.matrix_regfile3_port_we, top.matrix_regfile3_port_addr,
//                     top.matrix_regfile3_port_dout);
