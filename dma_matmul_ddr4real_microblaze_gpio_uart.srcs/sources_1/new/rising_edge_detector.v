`timescale 1ns / 1ps

module rising_edge_detector (
    input clk,
    input rst_n,

    input  signal_i,
    output reg pulse
);

    wire signal_q;
    reg signal_d;

    assign signal_q = signal_i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) signal_d <= 1'b0;
        else signal_d <= signal_q;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) pulse <= 1'b0;
        else begin
            if (signal_d == 1'b0 && signal_q == 1'b1)
                pulse = 1'b1;
            else
                pulse = 1'b0;
        end
    end
endmodule
