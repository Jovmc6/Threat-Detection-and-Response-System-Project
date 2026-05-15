`timescale 1ns / 1ps

module spi_cs_ctrl (
    input  wire sys_clk,
    input  wire sys_rst_n,
    input  wire assert_cs,
    input  wire deassert_cs,
    output reg  cs_n
);

    always @(posedge sys_clk) begin
        if (!sys_rst_n) begin
            cs_n <= 1'b1;
        end else if (assert_cs) begin
            cs_n <= 1'b0;
        end else if (deassert_cs) begin
            cs_n <= 1'b1;
        end
    end

endmodule