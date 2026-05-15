`timescale 1ns / 1ps

module interrupt_generator (
    input  wire sys_clk,
    input  wire sys_rst_n,
    input  wire int_en,
    input  wire int_clr,
    input  wire sig_in,
    output reg  int_out
);

    reg sig_in_d1;
    reg sig_in_d2;

    always @(posedge sys_clk) begin
        if (!sys_rst_n) begin
            sig_in_d1 <= 1'b0;
            sig_in_d2 <= 1'b0;
            int_out   <= 1'b0;
        end
        else begin
            // Two-stage synchronizer / edge-detect delay chain
            sig_in_d1 <= sig_in;
            sig_in_d2 <= sig_in_d1;

            // Clear has priority
            if (int_clr) begin
                int_out <= 1'b0;
            end
            // Rising-edge detect on synchronized input
            else if (int_en && sig_in_d1 && !sig_in_d2) begin
                int_out <= 1'b1;
            end
            // Otherwise hold previous interrupt state
            else begin
                int_out <= int_out;
            end
        end
    end

endmodule